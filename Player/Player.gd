extends KinematicBody2D


export var MAX_SPEED = 100
export var ACCELERATION = 500
var velocity = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var hitbox = $Hitbox
onready var hitboxCollisionShape2D = $Hitbox/CollisionShape2D
onready var inventory = $Inventory
onready var inventoryPanel = $CanvasLayer/Panel

func _ready():
	animationPlayer.play("Idle")

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_just_pressed("inventory"):
		inventoryPanel.load_inventory()
		inventoryPanel.visible = true
	if Input.is_action_just_released("inventory"):
		inventoryPanel.visible = false
	
	if Input.is_action_just_released("attack"):
		hitboxCollisionShape2D.disabled = true
	
	if Input.is_action_pressed("attack"):
		animationPlayer.play("Mining")
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
		
		
		
