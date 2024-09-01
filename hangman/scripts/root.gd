extends Node2D

signal restart_button_pressed;

const intro_text:String = "Guess the word in my head, and I'll ask the judge to push yer date back. You might even finish yer autobiography, HEH";
const win_text:String = "Well, ain't you clever! Looks like you live to write another day.";
const keyboard_key_scene:Resource = preload("res://scenes/keyboard_key.tscn");
const blank_space_scene:Resource = preload("res://scenes/blank_space.tscn");
const play_again_button: Resource = preload("res://scenes/play_again_button.tscn");
const typewriter_font:Font = preload("res://assets/salmon-typewriter-regular.ttf")
const allowed_strikes:int = 5;
const word_bank:Array = [
	"apple",
	"pear",
	"news",
	"award",
	"grimace",
	"stack",
	"whiskey",
	"employment",
	"taxes",
];
const row_qwer:String = "qwertyuiop"; 
const row_asdf:String = "asdfghjkl";
const row_zxcv:String = "zxcvbnm";

@onready var quote = %Quote
@onready var hangman_stage = %"Hangman-stage"
@onready var keyboard_keys_container = %Keyboard
@onready var blank_spaces_container = %BlankSpaces
@onready var incorrect_guesses_container = %IncorrectGuesses
@onready var player_actions_container = %CenterContainer
@onready var quote_panel = %Panel

var current_word:String = "";
var incorrect_guesses:Array = [];
var keyboard_keys:Dictionary = {};
var blank_spaces:Array = [];
var allowed_string:String = row_qwer + row_asdf + row_zxcv;
var allowed_chars:Array = [];
var accept_keyboard_input:bool = false;
var is_player_win:bool = false;

func _ready():
	set_up_allowed_chars();
	set_up_new_game();
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		var keycode_string:String = OS.get_keycode_string(event.keycode);
		var key:String = keycode_string.to_lower();

		# only accept VERY specific keycodes for our pseudo keyboard
		if keyboard_keys:
			if keyboard_keys.has(key):
				if accept_keyboard_input:
					if not keyboard_keys[key].disabled:
						keyboard_keys[key].pressed.emit();
	pass
	
func _process(_delta):
	pass

func remove_all_blank_spaces():
	for n in blank_spaces_container.get_children():
		n.queue_free()
	pass

func set_up_current_word():
	var random_word:String = get_random_word();
	
	current_word = random_word;
	pass;

func set_up_blank_spaces():
	for letter in current_word:
		var space = blank_space_scene.instantiate()
		blank_spaces_container.add_child(space)

		space.setCharacter(letter);
		blank_spaces.append(space);
	pass

func handle_keyboard_keypress(key:String):
	keyboard_keys[key].disabled = true;
	handle_player_input_submission(key);
	pass

func set_up_allowed_chars():
	for letter in allowed_string:
		if !allowed_chars.has(letter):
			allowed_chars.append(letter)
	pass

func remove_all_keyboard_keys():
	for n in keyboard_keys_container.get_children():
		n.queue_free()
	pass
	
func remove_all_incorrect_guesses():
	for n in incorrect_guesses_container.get_children():
		n.queue_free()
	pass
	
func setup_keyboard_row(letters:String):
	var row = HBoxContainer.new();

	keyboard_keys_container.add_child(row)
	row.alignment = BoxContainer.ALIGNMENT_CENTER

	for key in letters:
		var button:TextureButton = keyboard_key_scene.instantiate();
		row.add_child(button)

		button.toggle_mode = true;
		button.connect("pressed", handle_keyboard_keypress.bind(key))
		button.setKeyLabelText(key);

		keyboard_keys[key] = button;
	return row;

func set_up_player_keyboard():
	setup_keyboard_row(row_qwer);
	setup_keyboard_row(row_asdf);
	setup_keyboard_row(row_zxcv);

	pass

func setQuoteText(newText:String):
	quote.text = newText;
	pass;

func show_quote():
	quote_panel.show();
	pass

func hide_quote():
	quote_panel.hide();
	pass

func sync_stage_anim_to_incorrect_guesses():
	var animation_frame:int = incorrect_guesses.size();
	var clamped_frames = clamp(animation_frame, 1,6);

	hangman_stage.play(str(clamped_frames));

	if incorrect_guesses.size() > 0:
		hangman_stage.show()
		hide_quote();
	else:
		hangman_stage.hide();
		setQuoteText(intro_text);
		show_quote();
	pass;

func set_up_new_game():
	current_word = "";
	is_player_win = false;
	incorrect_guesses.clear();
	keyboard_keys.clear();
	blank_spaces.clear();
	accept_keyboard_input = false;
	
	remove_all_blank_spaces();
	remove_all_keyboard_keys();
	remove_all_incorrect_guesses();

	set_up_current_word();
	set_up_blank_spaces();
	set_up_player_keyboard();
	show_keyboard();
	sync_stage_anim_to_incorrect_guesses();

	print("current_word: ", current_word)

	pass

func get_random_word():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var	random_int = rng.randi_range(
		0,
		word_bank.size() - 1
	);
	
	return word_bank[random_int];

func handle_player_input_submission(key:String):
	var lower_key:String = key.to_lower();
	var found_indexes:Array = [];
	
	if !allowed_chars.has(lower_key):
		return;

	if current_word.find(lower_key) == -1:
		var label = Label.new();

		label.add_theme_font_override("font", typewriter_font);

		label.text = lower_key.to_upper();
		incorrect_guesses_container.add_child(label)
		incorrect_guesses.append(lower_key);
	else:
		var i = 0;
		for letter in current_word:
			if (letter == lower_key):
				found_indexes.append(i);
			i += 1;

	for index in found_indexes:
		blank_spaces[index].showAnswer();
		pass

	sync_stage_anim_to_incorrect_guesses()
	check_win_lose_conditions();

	pass
	
func flash_gallows():
	const wait_time = 0.125;

	for i in [0, 1, 2]:
		hangman_stage.play("6");
		await get_tree().create_timer(wait_time).timeout
		hangman_stage.play("5");
		await get_tree().create_timer(wait_time).timeout
	pass;

func show_keyboard():
	keyboard_keys_container.show()
	accept_keyboard_input = true;
	keyboard_keys["h"].grab_focus()

func hide_keyboard():
	keyboard_keys_container.hide()
	accept_keyboard_input = false;

func _on_play_again():
	print("PLAY AGAIN YAY");
	set_up_new_game();
	pass 

func setup_play_again_button():
	var btn = play_again_button.instantiate();
	
	player_actions_container.add_child(btn);
	btn.pressed.connect(_on_play_again)
	pass

func show_win():
	is_player_win = true;
	hangman_stage.hide()
	setQuoteText(win_text);
	show_quote();
	print("YOU WIN")
	hide_keyboard();
	setup_play_again_button();
	pass

func show_lose():
	print("YOU LOSE")
	flash_gallows();
	hide_keyboard();
	setup_play_again_button();
	pass

func check_win_lose_conditions():
	if incorrect_guesses.size() >= allowed_strikes:
		show_lose();
	else:
		var all_spaces_revealed = true;

		for space in blank_spaces:
			if space.revealAnswer == false:
				all_spaces_revealed = false;
				break;
			pass

		if all_spaces_revealed:
			show_win();
	pass
