extends Node2D

export var spawn_rate = 1
export var spawn_frequency = 2
export(Resource) var Minable

enum {
	INACTIVE,
	ACTIVE
}

var state = ACTIVE setget set_state

onready var timer = $Timer

func _ready():
	visible = false

func _process(delta):
	if state == ACTIVE and timer.is_stopped():
		print("start_timer")
		timer.start(spawn_frequency)

func create_new_minable():
	print("new minable spawned")
	var minable = Minable.instance()
	minable.spawner = self
	minable.global_position = global_position
	get_tree().current_scene.add_child(minable)

func set_state(value):
	state = value

func _on_Timer_timeout():
	print("timeout")
	for i in range(0, spawn_rate, 1):
		create_new_minable()
		state = INACTIVE
