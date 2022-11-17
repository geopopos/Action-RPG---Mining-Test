extends Area2D

enum {
	STOP,
	MOVE
}

export var id = "2"
export var item_name = "Iron Ore"
export var stackable = true
var direction

var state = STOP

onready var timer = $LaunchTimer

export(String) var inventory_texture = "res://Minable/mined-iron.png"
export(String) var audioFile = "res://SFX/pickupCoin.wav"

signal item_pickup(audioFile)

func _ready():
	var _nr = self.connect("item_pickup",get_tree().current_scene, "play_sound")
	timer.start(1.5)

func set_hitbox_pos(hitbox_global_pos):
	direction = -1 * (self.global_position.direction_to(hitbox_global_pos))
	state = MOVE
	
	
	
	
func _physics_process(delta):
	if state == MOVE:
		position += direction * 20 * delta

var item_data = {
	"id": id,
	"item_name": item_name,
	"inventory_texture": inventory_texture,
	"stackable": stackable
}

func _on_Mined_body_entered(body):
	emit_signal("item_pickup", audioFile)
	print("TEXTURE" + str(inventory_texture))
	var picked_up = body.inventory.add_item(item_data)
	if picked_up["picked_up"]:
		queue_free()


#func _on_Mined_area_entered(area):
#	print("ow you stepped on me")


func _on_LaunchTimer_timeout():
	state = STOP
