extends Node2D

const blank_space_scene = preload("res://scenes/blank_space.tscn");

@onready var keyboard_keys_container = %Keyboard
@onready var blank_spaces_container = %BlankSpaces

# need to switch between index num and char, due to unique values
var current_word:String = "";
#var blank_spaces:Array = []; can we just get the children of blankSpaces?
var player_guesses:Array = [];
var keyboard_keys:Dictionary = {};
var word_bank:Array = [
	"apple",
	"pear",
	"news",
	"award",
	"grimace",
	"stack",
];

var allowed_string:String = "abcdefghijklmnopqrstuvwxyz";
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

func set_up_current_word():
	var random_word:String = get_random_word();
	
	current_word = random_word;
	
	for char in random_word:
		var space = blank_space_scene.instantiate()

		space.setCharacter(char);
		blank_spaces_container.add_child(space)
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
		button.connect("pressed", handle_keyboard_keypress.bind(key))
		keyboard_keys_container.add_child(button)
		keyboard_keys[key] = button;
	pass

func set_up_new_game():
	set_up_allowed_chars();
	set_up_player_keyboard();
	set_up_current_word();

	player_guesses = [];
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
	var lower_key = key.to_lower();
	
	if !allowed_chars.has(lower_key):
		return;
	else: 
		print("handle_player_input_submission: ", lower_key)
		#var text:String = line_edit.text;
		#player_guesses.append(text);
		#print("player_guesses: ", player_guesses);
		# when button is clicked
		# commit the value in the text input as a "guess"
	pass

