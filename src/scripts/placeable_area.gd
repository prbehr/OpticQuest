extends Control
class_name PlaceableArea

var item_data: ItemData

signal area_clicked(area: PlaceableArea)

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		print("Placeable area %s clicked at position %s"%[self,self.global_position])
		area_clicked.emit(self)
