extends YSort

onready var audioStreamPlayer = $AudioStreamPlayer
onready var playerMessage = $Camera2D/PlayerMessage


func play_sound(audioFile):
	print(audioFile)
	if File.new().file_exists(audioFile):
		print(audioFile)
		var sfx = load(audioFile) 
		audioStreamPlayer.stream = sfx
		audioStreamPlayer.play()

func _display_player_message(message):
	playerMessage.display_message(message)
