extends PanelContainer

const slot_scene = preload("res://src/Inventory/slot.tscn")
@onready var slot_grid: GridContainer = $ScrollContainer/GridContainer

func set_inventory_data(inventory_data: InventoryData):
	# Connect to the inventory updated signal to repopulate the grid 
	#	when an item is picked up
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in slot_grid.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_data_array:
		var slot = slot_scene.instantiate()
		slot_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if(slot_data):
			slot.set_slot_data(slot_data)
