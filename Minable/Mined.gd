extends Area2D

export var id = "1"
export var item_name = "rock"
export var stackable = false

export(Texture) var inventory_texture

var item_data = {
	"id": id,
	"item_name": item_name,
	"inventory_texture": inventory_texture,
	"stackable": stackable
}

func _on_Mined_body_entered(body):
	body.inventory.add_item(item_data)


#func _on_Mined_area_entered(area):
#	print("ow you stepped on me")
