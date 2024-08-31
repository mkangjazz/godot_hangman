extends Button

func _ready():
	grab_focus()
	pass

func _process(_delta):
	pass
	
func _on_pressed():
	queue_free();
	pass
