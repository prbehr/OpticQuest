extends Resource
class_name InventoryData

signal inventory_interact(inventory_data: InventoryData, index: int)
signal inventory_updated(inventory_data: InventoryData)
@export var slot_data_array: Array[SlotData]

# When a slot is clicked in the inventory emit the inventory interact signal
#	passing the inventory and the slot index that was clicked
func on_slot_clicked(index: int):
	inventory_interact.emit(self, index)

# Set the current grabbed slot to whichever index was clicked
func grab_slot_data(index: int):
	var slot_data = slot_data_array[index]
	
	if(slot_data):
		# If we pick up an item set its current slot data to null
		slot_data_array[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null
		
func drop_slot_data(grabbed_slot_data: SlotData,index: int):
	# Get the current item in the slot if there is one
	var slot_data = slot_data_array[index]
	
	# Set the slot to the grabbed item
	slot_data_array[index] = grabbed_slot_data
	inventory_updated.emit(self)
	
	# If there was an item in the slot previously, return it
	#	This will swap with the grabbed item
	if(slot_data):
		return slot_data
	else:
		return null
		
func return_optic(object_to_return,slot: SlotData):
	print("Returning %s to inventory"%[object_to_return])
	for slot_data in slot_data_array:
		if(!slot_data):
			var slot_index = slot_data_array.find(slot_data)
			slot_data_array[slot_index] = slot
			inventory_updated.emit(self)
			object_to_return.queue_free()
			return
