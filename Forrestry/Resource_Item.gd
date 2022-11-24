extends KinematicBody2D

enum {
	STOP,
	MOVE,
	TARGET_PLAYER
}

var mined_item_data = {
	"1": {
		"id": "1",
		"item_name": "Rock",
		"stackable": true,
		"inventory_texture": "res://Minable/Mined.png"
	},
	"2": {
		"id": "2",
		"item_name": "Iron Ore",
		"stackable": true,
		"inventory_texture": "res://Minable/mined-iron.png"
	},
	"3": {
		"id": "3",
		"item_name": "Diamond Ore",
		"stackable": true,
		"inventory_texture": "res://Minable/mined-diamond.png"
	},
	"4": {
		"id": "4",
		"item_name": "Wood",
		"stackable": true,
		"inventory_texture": "res://Forrestry/Wood.png"
	}
}

export(String) var id
var mined_item
var direction
var item_data
var velocity = Vector2.ZERO

var state = STOP

onready var timer = $LaunchTimer
onready var freeTimer = $FreeTimer
onready var sprite = $Sprite
onready var playerDetectionArea = $PlayerDetectionArea
onready var playerDetectionAreaCollision = $PlayerDetectionArea/PlayerCollision

export(String) var audioFile = "res://SFX/pickupCoin.wav"

signal item_pickup(audioFile)

func set_up(minable_id, global_position):
	id = minable_id
	mined_item = mined_item_data[id]
	item_data = {
		"id": mined_item["id"],
		"item_name": mined_item["item_name"],
		"inventory_texture": mined_item["inventory_texture"],
		"stackable": mined_item["stackable"]
	}
	self.global_position = global_position
	

func _ready():
	var _nr = self.connect("item_pickup",get_tree().current_scene, "play_sound")
	sprite.texture = load(mined_item["inventory_texture"])
	timer.start(0.5)
	freeTimer.start(10)
	

func set_hitbox_pos(hitbox_global_pos):
	direction = -1 * (self.global_position.direction_to(hitbox_global_pos))
	state = MOVE
	
	
func _physics_process(delta):
	seek_player()
	if state == MOVE:
		position += direction * 20 * delta
	elif state == TARGET_PLAYER:
		var player = playerDetectionArea.player
		print(player)
		if player != null:
			accelerate_towards_point(player.global_position, delta)
		else:
			state = STOP
	velocity = move_and_slide(velocity)

func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * 150, 500 * delta)
	

#func _on_Mined_body_entered(body):

func _on_LaunchTimer_timeout():
	playerDetectionAreaCollision.disabled = false
	state = STOP


func _on_FreeTimer_timeout():
	queue_free()

func seek_player():
	if playerDetectionArea.can_see_player():
		state = TARGET_PLAYER


func _on_PickupDetection_body_entered(body):
	var picked_up = body.inventory.add_item(item_data)
	if picked_up["picked_up"]:
		emit_signal("item_pickup", audioFile)
		queue_free()
	else:
		var playerMessage = get_tree().current_scene.get_node('Camera2D').get_node('PlayerMessage')
		playerMessage.display_message("Your Inventory Is Full")
