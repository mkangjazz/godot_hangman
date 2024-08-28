extends TextureRect

@onready var label = %Label

var revealAnswer:bool = false;
var character:String = "Z";

func _ready():
	pass

func _process(delta):
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

func setCharacter(char:String):
	self.character = char;
	label.text = character;
	pass
