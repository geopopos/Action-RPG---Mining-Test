extends KinematicBody2D

signal minable_broken(audioFile)


# add health option of multiples of threes to keep rock animation consistent
var health = 3
var spawner
var type

var minable_data = {
	"rock": {
		"texture": "res://Minable/Minable.png",
		"mined": "1"
	},
	"iron": {
		"texture": "res://Minable/minable-iron.png",
		"mined": "2"
	}
}

onready var sprite = $Sprite as Sprite
onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D
var audioFile = "res://SFX/Rock_Break.wav"
onready var Effect = preload("res://Effects/Effect.tscn")


export(Resource) var Mined = preload("res://Minable/Mined.tscn")

func set_up(type, spawner, global_position):
	print(minable_data[type]["texture"])
	self.type = type
	self.spawner = spawner
	self.global_position = global_position
	

func _ready():
	print(type)
	var _nr = self.connect("minable_broken",get_tree().current_scene, "play_sound")
	var spriteTexture = load(minable_data[type]["texture"])
	sprite.texture = spriteTexture

func _on_Hurtbox_area_entered(area):
	if area.get("type") == "Mining":
		health -= 1
		sprite.set_frame(health)
		if health <= 0:
			death(area.get_parent().global_position)

func death(hitbox_global_position):
	emit_signal("minable_broken", audioFile)
	var effect = Effect.instance()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	spawner.set_state(1)
	hurtboxCollisionShape.set_deferred("disabled", true)
	var mined = Mined.instance()
	mined.set_up(minable_data[type]["mined"], global_position)
	mined.set_hitbox_pos(hitbox_global_position)
	get_tree().current_scene.add_child(mined)
	queue_free()
	
