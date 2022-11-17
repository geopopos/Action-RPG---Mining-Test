extends Label

onready var timer = $Timer

func display_message(message):
	text = message
	timer.start(2)
	visible = true
	



func _on_Timer_timeout():
	text = ""
	visible = false
