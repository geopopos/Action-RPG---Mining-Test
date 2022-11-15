extends Panel

onready var itemList = $ItemList

func _ready():
	load_inventory()

func load_inventory():
	itemList.clear()
	for i in range(0, Global.inventory.size(),1):
		Global.inventory[i]["texture_loaded"] = load(Global.inventory[i]["texture"])
	#Load the ItemList by stepping through it and adding each item.
	for item_slot in Global.inventory:
		itemList.add_item(item_slot["name"] + ": " + str(item_slot["count"]),item_slot["texture_loaded"],true)
				
	itemList.select(0,true) #This sets a default so we don't have
	# to do error catching if an empty selection is captured.


func ReportListItem():
	var ItemNo = get_node("ItemList").get_selected_items()

	#The output ItemNo is a list of selected items.  Use this to select
	#The matching component from the associated array, ItemListContent.
 
	var SelectedItemtext = Global.inventory[ItemNo[0]]
	get_node("Label - output").set_text(str(SelectedItemtext))
	print(ItemNo)
