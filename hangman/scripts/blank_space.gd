extends TextureRect

@onready var label = %Label

var revealAnswer:bool = false;
var character:String = "Z";

func _ready():
	pass

func _process(_delta):
	if revealAnswer:
		label.show()
	else:
		label.hide()
	pass

func hideAnswer():
	self.revealAnswer = false;
	pass

func showAnswer():
	self.revealAnswer = true;
	pass

func setCharacter(letter:String):
	self.character = letter;
	label.text = character;
	pass
