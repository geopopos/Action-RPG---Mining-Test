extends Node

export var inventory_size = 10
export var inventory_stacking = 99
var inventory = [] 

func add_item(item):
	print(item)
	# check if inventory is full (if so, return error keep item in world)
	var inventory_full = inventory.size() >= inventory_size
	if inventory_full:
		print("inventory full. Cannot pick up any more items")
		return {"picked_up": false}
	else:
		var item_exists = false
		var inventory_slot
		for i in range(0, inventory.size(), 1):
			if inventory[i]["id"] == item["id"]:
				item_exists = true
				inventory_slot = i
		if item_exists:
			# check if item is stackable
			if item.get("stackable"):
				# if so check if stack is full
				if inventory[inventory_slot]["count"] >= inventory_stacking:
					append_inventory_item(item["id"], item["item_name"], item["inventory_texture"], 1)
				else:
					# if not full increment inventory count of item by 1
					inventory[inventory_slot]["count"] += 1
					print(inventory)
					return {"picked_up": true}
			else:
				append_inventory_item(item["id"], item["item_name"], item["inventory_texture"], 1)
				print(inventory)
				return {"picked_up": true}
		# If not add item to inventory
		else:
			append_inventory_item(item["id"], item["item_name"], item["inventory_texture"], 1)
			print(inventory)
			return {"picked_up": true}
	
	
func append_inventory_item(id, item_name, texture, count):
	var inventory_item = {
			"id": id,
			"name": item_name,
			"texture": texture,
			"count": count
		}
		
	inventory.append(inventory_item)
