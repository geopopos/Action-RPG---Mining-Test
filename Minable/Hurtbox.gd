extends Area2D

# add health option of multiples of threes to keep rock animation consistent
var health = 3

onready var sprite = $Sprite as Sprite


func _on_Hurtbox_area_entered(area):
	health -= 1
	sprite.set_frame(health)
	
