extends Node2D

export var spawn_rate = 1
export var spawn_frequency = 10
export(String, "wood", "iron", "diamond") var minableType
export(Resource) var Minable = preload("res://Forrestry/Tree.tscn")


enum {
	INACTIVE,
	ACTIVE
}

var state = ACTIVE setget set_state

onready var timer = $Timer

func _ready():
	visible = false
	timer.start(0.1)

func _process(_delta):
	if state == ACTIVE and timer.is_stopped():
		timer.start(spawn_frequency)

func create_new_minable():
	var minable = Minable.instance()
	minable.set_up(minableType, self, global_position)
	get_tree().current_scene.add_child(minable)

func set_state(value):
	state = value

func _on_Timer_timeout():
	for _i in range(0, spawn_rate, 1):
		create_new_minable()
		state = INACTIVE
