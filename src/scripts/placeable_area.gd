extends Control
class_name PlaceableArea

@export var rotation_locked: bool = false
@export var locked_rotation_value: float = 0.0
var stored_slot: SlotData

signal area_clicked(area: PlaceableArea)

func _ready():
	find_parent("LevelMaster").update_placeable_areas.connect(update_area)
	self.add_to_group("placeable areas")
	
	if(rotation_locked):
		$PanelContainer.modulate = Color(1,0,0,0.8)
	else:
		$PanelContainer.modulate = Color(0,0,1,0.8)
	
func update_area():
	# When an item is returned to the inventory, the update_placeable_areas signal is emitted
	#	if the signal is emitted and the area doesn't have an item and it's not visible
	#	turn the visibility back on
	if(!stored_slot and !self.visible):
		self.visible = true

func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		print("Placeable area %s clicked at position %s"%[self,self.global_position])
		area_clicked.emit(self)
