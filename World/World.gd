extends YSort

onready var audioStreamPlayer = $AudioStreamPlayer


func play_sound(audioFile):
	if File.new().file_exists(audioFile):
		print(audioFile)
		var sfx = load(audioFile) 
		audioStreamPlayer.stream = sfx
		audioStreamPlayer.play()
