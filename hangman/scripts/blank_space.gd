extends Node2D

var isHidden:bool = true;
var character:String = "";

func _ready():
	pass

func _process(delta):
	pass

func hideCharacter():
	self.isHidden = true;
	pass

func showCharacter():
	self.isHidden = false;
	pass

func setCharacter(char:String):
	self.character = char;
	pass
