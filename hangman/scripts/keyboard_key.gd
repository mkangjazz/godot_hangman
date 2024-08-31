extends TextureButton

@onready var label = %Label

const shift_amount:float = 2.0;
var original_position = self.position;

func _ready():
	pass

func _process(_delta):
	pass

func setKeyLabelText(s:String):
	if not label:
		return;
		
	if not label.text:
		return;

	label.text = s;
	pass

func move_up():
	self.position = Vector2(0.0, original_position + shift_amount)
	pass

func move_down():
	self.position = Vector2(0.0, original_position - shift_amount)
	pass
