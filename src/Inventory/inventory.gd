extends PanelContainer

const slot_scene = preload("res://src/Inventory/slot.tscn")
@onready var slot_grid: GridContainer = $ScrollContainer/GridContainer

func _ready() -> void:
	var inv_data = preload("res://src/Inventory/test_inventory.tres")
	populate_item_grid(inv_data.slot_data_array)

func populate_item_grid(slot_datas: Array[SlotData]) -> void:
	for child in slot_grid.get_children():
		child.queue_free()
		
	for slot_data in slot_datas:
		var slot = slot_scene.instantiate()
		slot_grid.add_child(slot)
		
		
		if(slot_data):
			slot.set_slot_data(slot_data)
