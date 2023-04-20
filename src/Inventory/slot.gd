extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect

signal slot_clicked(index: int)

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s"%[item_data.name,item_data.description]


# Emit the slot_clicked signal whenever the player left clicks on a slot
func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
				
		slot_clicked.emit(get_index())
