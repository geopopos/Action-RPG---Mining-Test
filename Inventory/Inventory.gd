extends Node

export var inventory_size = 10
export var inventory_stacking = 99
export var inventory = [] 

func add_item(item):
	# check if inventory is full (if so, return error keep item in world)
	if inventory.size() >= inventory_size:
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
					# (if so, return error keep item in world)
					return {"picked_up": false}
				else:
					# if not full increment inventory count of item by 1
					inventory[inventory_slot]["count"] += 1
		# If not add item to inventory
		else:
			var inventory_item = {
				"id": item["id"],
				"name": item["item_name"],
				"texture": item["inventory_texture"],
				"count": 1
			}
			
			inventory.append(inventory_item)
	print(inventory)
