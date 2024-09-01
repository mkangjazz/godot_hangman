extends Label

const intro_text:String = "Guess the word in my head an' I'll git the hangman to push yer date back. You jus' might finish writin' yer book that I'll prolly never read, HEH!";
const win_text:String = "Well, ain't you a clever monkey! Looks like you live to write another day.";

var is_setting_dialogue:bool = false:
	set(value):
		is_setting_dialogue = value;
	get:
		return is_setting_dialogue;

func _ready():
	pass

func _process(delta):
	pass

func set_intro_dialogue():
	set_dialogue(intro_text);
	pass;

func set_win_dialogue():
	set_dialogue(win_text);
	pass;

func set_dialogue(quote:String):
	if is_setting_dialogue:
		return;

	is_setting_dialogue = true;

	const wait_time:float = 0.125;
	var arr:Array = quote.split(" ");
	var punctuation_regex:RegEx = RegEx.new()

	self.text = "";
	punctuation_regex.compile("[!.?]")
	
	for word in arr:
		var add_time:float = 0.0;
		var is_end_of_sentence:bool = true if punctuation_regex.search(word) else false;
		var is_first_word:bool = true if word == arr[0] else false;
		var is_last_word:bool = true if word == arr[arr.size()-1] else false;

		self.text += word
		self.text += " "
		
		if is_end_of_sentence:
			add_time += 1.5;

		await get_tree().create_timer(wait_time + add_time).timeout

		if is_end_of_sentence and !is_last_word:
			self.text = "";

	is_setting_dialogue = false;
	pass
