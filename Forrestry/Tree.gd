extends KinematicBody2D

signal tree_broken(audioFile)

# add health option of multiples of threes to keep rock animation consistent
var health
var max_health
var spawner
var type

var tree_data = {
	"wood": {
		"texture": "res://Forrestry/Tree.png",
		"tree": "1",
		"health": 3
	},
	"iron": {
		"texture": "res://Minable/minable-iron.png",
		"mined": "2",
		"health": 6
	},
	"diamond": {
		"texture": "res://Minable/minable-diamond.png",
		"mined": "3",
		"health": 9
	}
}

onready var sprite = $Sprite as Sprite
onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D
var audioFile = "res://SFX/fall.wav"
onready var Effect = preload("res://Effects/Effect.tscn")


export(Resource) var Mined = preload("res://Forrestry/Resource.tscn")

func set_up(minable_type, minable_spawner, global_position):
	self.type = minable_type
	self.spawner = minable_spawner
	self.global_position = global_position
	health = tree_data[type]["health"]
	max_health = health
	

func _ready():
	var _nr = self.connect("tree_broken", get_tree().current_scene, "play_sound")
	var spriteTexture = load(tree_data[type]["texture"])
	sprite.texture = spriteTexture


func death(hitbox_global_position):
	emit_signal("tree_broken", audioFile)
	var effect = Effect.instance()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	spawner.set_state(1)
	hurtboxCollisionShape.set_deferred("disabled", true)
	var mined = Mined.instance()
	mined.set_up(tree_data[type]["tree"], global_position)
	mined.set_hitbox_pos(hitbox_global_position)
	get_tree().current_scene.add_child(mined)
	queue_free()
	


func _on_Hurtbox_area_entered(area):
		if area.get("type") == "Mining":
			var damage = area.strength
			health -= damage
			var frame = ceil(float(health)/(max_health/3))
			sprite.set_frame(frame)
			if health <= 0:
				death(area.get_parent().global_position)

