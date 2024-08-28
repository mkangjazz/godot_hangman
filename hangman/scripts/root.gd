extends Node2D

const blank_space_scene:Resource = preload("res://scenes/blank_space.tscn");
const allowed_strikes:int = 5;

@onready var keyboard_keys_container = %Keyboard
@onready var blank_spaces_container = %BlankSpaces
@onready var incorrect_guesses_container = %IncorrectGuesses

# need to switch between index num and char, due to unique values
var current_word:String = "";
var incorrect_guesses:Array = [];
var keyboard_keys:Dictionary = {};
var blank_spaces:Array = [];
var word_bank:Array = [
	"apple",
	"pear",
	"news",
	"award",
	"grimace",
	"stack",
];

var allowed_string:String = "qwertyuiopasdfghjklzxcvbnm"; # break into rows? chunk into diff sizes?
var allowed_chars:Array = [];

func _ready():
	set_up_new_game();
	print("current_word: ", current_word)
	print("allowed_chars: ", allowed_chars)
	print("blank spaces container children: ", blank_spaces_container.get_children())

	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		var keycode_string:String = OS.get_keycode_string(event.keycode);
		var key:String = keycode_string.to_lower();
		
		if not keyboard_keys.has(key):
			return;
		else:
			if keyboard_keys[key].disabled:
				return;
			keyboard_keys[key].pressed.emit();
	pass
	
func _process(delta):
	pass

#func add_incorrect_guess():
	

func set_up_current_word():
	var random_word:String = get_random_word();
	
	current_word = random_word;

	for char in random_word:
		var space = blank_space_scene.instantiate()
		blank_spaces_container.add_child(space)

		space.setCharacter(char);
		blank_spaces.append(space);
	pass

func handle_keyboard_keypress(key:String):
	keyboard_keys[key].disabled = true;
	handle_player_input_submission(key);
	pass

func set_up_allowed_chars():
	for char in allowed_string:
		if !allowed_chars.has(char):
			allowed_chars.append(char)
	pass

func set_up_player_keyboard():
	for key in allowed_chars:
		var button = Button.new();
		button.text = key.to_upper();
		button.toggle_mode = true;
		button.grow_horizontal = true
		button.connect("pressed", handle_keyboard_keypress.bind(key))
		keyboard_keys_container.add_child(button)
		keyboard_keys[key] = button;
	pass

func set_up_new_game():
	set_up_allowed_chars();
	set_up_player_keyboard();
	set_up_current_word();

	incorrect_guesses = [];
	pass

func get_random_word():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var	random_int = rng.randi_range(
		0,
		word_bank.size() - 1
	);
	
	return word_bank[random_int];

	pass;

func handle_player_input_submission(key:String):
	var lower_key:String = key.to_lower();
	var found_indexes:Array = [];
	
	if !allowed_chars.has(lower_key):
		return;

	if current_word.find(lower_key) == -1:
		var label = Label.new();

		label.text = lower_key.to_upper();
		incorrect_guesses_container.add_child(label)
		incorrect_guesses.append(lower_key);
	else:
		var i = 0;
		for char in current_word:
			if (char == lower_key):
				found_indexes.append(i);
			i += 1;
	
	for index in found_indexes:
		blank_spaces[index].showAnswer();
		pass
	
	check_win_lose_conditions();

	pass

func show_win():
	print("YOU WIN")
	get_tree().paused = true # or disable inputs and do other things?
	pass

func show_lose():
	print("YOU LOSE")
	get_tree().paused = true # or disable inputs and do other things?
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
			show_win()
	pass
