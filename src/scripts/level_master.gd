extends Node2D

@export var next_scene: PackedScene
@onready var anim_player = $AnimationPlayer
@export var inventory_data: InventoryData
@onready var inventory_UI: Control = $CanvasLayer/GUI/Inventory
@onready var grabbed_slot: PanelContainer = $CanvasLayer/GUI/GrabbedSlot

var num_detectors: int = 0
var grabbed_slot_data: SlotData

func _ready():
	for node in get_children():
		if(node.is_in_group("detectors")):
			num_detectors += 1
		if(node.is_in_group("placeable areas")):
			node.find_child("PanelContainer").area_clicked.connect(drop_grabbed_slot)
	
	# Set the inventory to display the items set in the inventory_data
	inventory_UI.set_inventory_data(self.inventory_data)
	# Connect to the inventory_data interact signal to listen for 
	#	inventory clicks
	inventory_data.inventory_interact.connect(on_inventory_interact)
	
func _physics_process(delta):
	# If there is a grabbed slot visible, make it follow the mouse
	if(grabbed_slot.visible):
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(2,2)
	
func on_inventory_interact(inventory: InventoryData, index: int):
	# When a slot is clicked, set grabbed_slot_data 
	#	to the item at the index of inventory
	if(grabbed_slot_data==null):
		grabbed_slot_data = inventory_data.grab_slot_data(index)
	else:
		grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data,index)
	
	update_grabbed_slot()
	print(grabbed_slot_data)
	
func update_grabbed_slot():
	# If the current grabbed slot is not null, show the transparent 
	#	grabbed slot icon
	if(grabbed_slot_data):
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
		
func drop_grabbed_slot(area: PlaceableArea):
	#If you have a grabbed slot data, create an instance of its scene in the area
	print("Attempting to drop grabbed slot")
	if(grabbed_slot_data):
		var item_to_place = grabbed_slot_data.item_data.item_scene.instantiate()
		item_to_place.return_to_inventory.connect(return_optic_to_inventory)
		item_to_place.global_position = area.global_position + Vector2(20,20)
		item_to_place.area_placed_in = area
		area.item_data = grabbed_slot_data.item_data
		area.visible = false
		add_child(item_to_place)
		
		grabbed_slot_data = null
		update_grabbed_slot()
	else:
		print("No grabbed slot")
		
func return_optic_to_inventory(optic):
	inventory_data.return_optic(optic)
	pass
	
func check_detector_status():
	var current_status = 0
	for node in get_children():
		if(node.is_in_group("detectors")):
			if(!node.receiving_light):
				break # exits loop if any detector is not receiving light
			else:
				current_status += 1
	if(current_status >= num_detectors):
		proceed_to_next_scene()

func proceed_to_next_scene():
	anim_player.play("fade_to_black")
	await anim_player.animation_finished
	get_tree().change_scene_to_packed(next_scene)
