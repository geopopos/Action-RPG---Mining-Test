extends AnimatedSprite

onready var animatedSprite = $"."

func _ready():
	animatedSprite.play()
	yield(animatedSprite, "animation_finished")
	queue_free()
