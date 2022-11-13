extends KinematicBody2D
# add health option of multiples of threes to keep rock animation consistent
var health = 3

onready var sprite = $Sprite as Sprite
onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D

export var Mined = preload("res://Minable/Mined.tscn")

func _on_Hurtbox_area_entered(area):
	if area.get("type") == "Mining":
		health -= 1
		sprite.set_frame(health)
		if health <= 0:
			death()

func death():
	hurtboxCollisionShape.disabled = true
	var mined = Mined.instance()
	mined.global_position = global_position
	get_tree().current_scene.add_child(mined)
	queue_free()
	
