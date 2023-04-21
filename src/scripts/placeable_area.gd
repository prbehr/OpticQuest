extends Control
class_name PlaceableArea

var stored_slot: SlotData

signal area_clicked(area: PlaceableArea)

func _ready():
	find_parent("LevelMaster").update_placeable_areas.connect(update_area)
	
func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		print("Placeable area %s clicked at position %s"%[self,self.global_position])
		area_clicked.emit(self)

func update_area():
	# When an item is returned to the inventory, the update_placeable_areas signal is emitted
	#	if the signal is emitted and the area doesn't have an item and it's not visible
	#	turn the visibility back on
	if(!stored_slot and !self.visible):
		self.visible = true
