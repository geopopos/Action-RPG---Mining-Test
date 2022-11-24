extends Node2D

export var spawn_rate = 1
export var spawn_frequency = 10
export(String, "rock", "iron", "diamond", "wood") var resourceType
export(Resource) var ResourceScene = preload("res://Forrestry/Resource.tscn")


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

func create_new_resource():
	var resource = ResourceScene.instance()
	resource.set_up(resourceType, self, global_position)
	get_tree().current_scene.add_child(resource)

func set_state(value):
	state = value

func _on_Timer_timeout():
	for _i in range(0, spawn_rate, 1):
		create_new_resource()
		state = INACTIVE
