extends KinematicBody2D

signal resource_broken(audioFile)

# add health option of multiples of threes to keep rock animation consistent
var health
var max_health
var spawner
var type

var resource_data = {
	"rock": {
		"texture": "res://Minable/Minable.png",
		"resource_item": "1",
		"health": 3,
		"hitBoxType": "Mining"
	},
	"iron": {
		"texture": "res://Minable/minable-iron.png",
		"resource_item": "2",
		"health": 6,
		"hitBoxType": "Mining"
	},
	"diamond": {
		"texture": "res://Minable/minable-diamond.png",
		"resource_item": "3",
		"health": 9,
		"hitBoxType": "Mining"
	},
	"wood": {
		"texture": "res://Forrestry/Tree.png",
		"resource_item": "4",
		"health": 3,
		"hitBoxType": "Axe"
	}
}

var hurtboxCollisionShape

onready var sprite = $Sprite as Sprite
onready var treeHurtBox = $Hurtbox/Tree
onready var miningHurtBox = $Hurtbox/Mining

var audioFile = "res://SFX/fall.wav"
var hitAudio = "res://SFX/hitWood.wav"
onready var Effect = preload("res://Effects/Effect.tscn")


export(Resource) var Mined = preload("res://Forrestry/Resource_Item.tscn")

func set_up(minable_type, minable_spawner, global_position):
	self.type = minable_type
	self.spawner = minable_spawner
	self.global_position = global_position
	print(type)
	print(resource_data)
	health = resource_data[type]["health"]
	max_health = health
	

func _ready():
	var _nr = self.connect("tree_broken", get_tree().current_scene, "play_sound")
	var spriteTexture = load(resource_data[type]["texture"])
	sprite.texture = spriteTexture
	if resource_data[type]["hitBoxType"] == "Mining":
		hurtboxCollisionShape = miningHurtBox
	elif resource_data[type]["hitBoxType"] == "Axe":
		hurtboxCollisionShape = treeHurtBox
	hurtboxCollisionShape.disabled = false
	


func death(hitbox_global_position):
	emit_signal("tree_broken", audioFile)
	var effect = Effect.instance()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	spawner.set_state(1)
	hurtboxCollisionShape.set_deferred("disabled", true)
	var mined = Mined.instance()
	mined.set_up(resource_data[type]["resource_item"], global_position)
	mined.set_hitbox_pos(hitbox_global_position)
	get_tree().current_scene.add_child(mined)
	queue_free()
	


func _on_Hurtbox_area_entered(area):
	var damage = area.strength
	if area.get("type") != resource_data[type]["hitBoxType"]:
		damage = damage * .1
	print("hit")
	emit_signal("resource_broken", hitAudio)
	health -= damage
	var frame = ceil(float(health)/(max_health/3))
	sprite.set_frame(frame)
	if health <= 0:
		death(area.get_parent().global_position)

