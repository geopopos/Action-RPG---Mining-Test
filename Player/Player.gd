extends KinematicBody2D

signal display_message

export var MAX_SPEED = 100
export var ACCELERATION = 500

enum {
	PICKAXE,
	AXE
}

export var equippable = PICKAXE
export var equipped_item_id = "5"
var equipped_item
var velocity = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var hitbox = $Hitbox
onready var hitboxCollisionShape2D = $Hitbox/CollisionShape2D
onready var inventory = $Inventory
onready var inventoryPanel = $CanvasLayer/Panel
onready var audioStreamPlayer = $AudioStreamPlayer
onready var pickaxeSound = preload("res://SFX/Mining_Sound.wav")
onready var axeSound = preload("res://SFX/hitWood.wav")


func _ready():
	connect("display_message", get_tree().current_scene, "_display_player_message")
	animationPlayer.play("Idle")

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_just_pressed("inventory"):
		inventoryPanel.load_inventory(inventory.inventory)
		inventoryPanel.visible = true
	if Input.is_action_just_released("inventory"):
		get_tree().paused = false
		inventoryPanel.visible = false
		
	
	if Input.is_action_just_pressed("equip"):
		var equippables = []
		for item in inventory.inventory:
			if item["type"] == "Equippable" and item["id"] != equipped_item_id:
				equippables.append(item)
		equipped_item_id = equippables[0]["id"]
		equipped_item = equippables[0]
		if equipped_item["equippable_info"]["category"] == "pickaxe":
			audioStreamPlayer.stream = pickaxeSound
			equippable = PICKAXE
		elif equipped_item["equippable_info"]["category"] == "axe":
			audioStreamPlayer.stream = axeSound
			equippable = AXE
		emit_signal("display_message", "Player Equippable Changed To " + equipped_item["name"])
		
	
	if Input.is_action_just_released("attack"):
		hitboxCollisionShape2D.disabled = true
	
	if Input.is_action_pressed("attack"):
		if equippable == PICKAXE:
			
			animationPlayer.play("Mining")
		elif equippable == AXE:
			animationPlayer.play("Chopping")
	elif direction != Vector2.ZERO:
		animationPlayer.play("Walking")
		if direction.x < 0:
			sprite.flip_h = true
			hitbox.position.x = -42
		else:
			sprite.flip_h = false
			hitbox.position.x = 0
		velocity = velocity.move_toward(direction * MAX_SPEED, 200 * delta)
		velocity = move_and_slide(velocity)
	else:
		velocity = Vector2.ZERO
		animationPlayer.play("Idle")
		
		
		
