extends Area2D

@export var ray_scene: PackedScene = load("res://src/scenes/reflected_ray.tscn")
var can_rotate: bool = false
var rotation_locked: bool = false ## This inherits from the placeable area. If true, cannot ever rotate
var can_interact: bool = false
@onready var interact_panel = $InteractPanel
@onready var rotation_slider = $InteractPanel/OptionsContainer/RotationSlider
@onready var return_button = $InteractPanel/OptionsContainer/ReturnButton
var area_placed_in: PlaceableArea

signal return_to_inventory(mirror: Object, area: PlaceableArea)

func _ready():
	add_to_group("reflectors")
	$InteractPanel.rotation = -self.rotation
	rotation_slider.value = self.rotation
	
	if(rotation_locked):
		rotation_slider.value = 0
		rotation_slider.editable = false
	
	rotation_slider.drag_started.connect(toggle_rotation)
	rotation_slider.drag_ended.connect(toggle_rotation)
	return_button.button_up.connect(return_self_to_inventory)

# unhandled input below activates for all mirrors for some reason.
	# Toggling can_interact with mouse enter makes it so only the mouseover mirror is toggled
func _mouse_enter():
	toggle_can_interact(self)
	
func _mouse_exit():
	toggle_can_interact(self)

func toggle_can_interact(object):
	object.can_interact = !object.can_interact
	
func toggle_rotation(value_changed: bool = true):
	if(value_changed):
		can_rotate = true
	else:
		can_rotate = false
	
func toggle_interact_panel(object):
	interact_panel.visible = !interact_panel.visible
	
	if(interact_panel.visible):
		var viewport_bottom_corner = get_viewport_rect().end
		var global_pos = interact_panel.global_position
		var IP_bottom_corner = interact_panel.global_position+Vector2(interact_panel.size[0],interact_panel.size[1])
		
		if(IP_bottom_corner[0] > viewport_bottom_corner[0]):
			var x_diff = abs(IP_bottom_corner[0] - viewport_bottom_corner[0])
			interact_panel.global_position = global_pos - Vector2(x_diff,0)
		if(IP_bottom_corner[1] > viewport_bottom_corner[1]):
			var y_diff = abs(IP_bottom_corner[1] - viewport_bottom_corner[1])
			interact_panel.global_position = global_pos - Vector2(0,y_diff)

func return_self_to_inventory():
	return_to_inventory.emit(self,area_placed_in)
	pass

func _unhandled_input(event):
	if(event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and can_interact):
		if(!event.pressed): # If the event is button released, don't do anything
			return
		else:
			toggle_interact_panel(self)

func _physics_process(delta):
	var IP_global_pos = interact_panel.global_position
	if(can_rotate and !rotation_locked):
		self.rotation = rotation_slider.value
		interact_panel.rotation = -rotation_slider.value
		interact_panel.global_position = IP_global_pos
