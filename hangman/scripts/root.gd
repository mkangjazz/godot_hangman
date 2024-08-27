extends Node2D

#var current_scene;
var word_bank:Array = [
	"apple",
	"pear",
	"news",
	"to",
];
var current_word:String;
var player_guesses:Array = [];


func _ready():
	set_up_new_game();
	print(current_word, player_guesses)

	pass

func _process(delta):
	pass

func set_up_new_game():
	current_word = get_random_word();
	player_guesses = [];
	pass

func get_random_word():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var	random_int = rng.randi_range(
		0,
		word_bank.size()
	);
	
	return word_bank[random_int];

	pass;

func submit_player_input():
	print("clicky");
	# when button is clicked
	# commit the value in the text input as a "guess"
	pass

func _on_button_pressed():
	submit_player_input();
	pass

# hangman
# guessing game where you guess word, phrase, sentence
# within a certain # of guesses

# system choose a word from a bank of words
# rules may permit or forbid proper nouns, such as names, places, brands, or slang.
# one word? two? phrase? spaces?

# case insensitive

# show one space for each letter

# show an area for player to input a guess
# player inputs a guess (entire word, or letter)
# get it right, show letter
# get it wrong, add a piece to the guy 
# if player gets all letters, player wins
# if player guesses wrong X times, player loses 

# show the letters that were guessed incorrectly
# show the words that were guessed incorrectly?
