extends CenterContainer

signal play_again

func _ready():
	pass

func _process(delta):
	pass

func _on_button_pressed():
	play_again.emit();
	queue_free();
	pass
