extends Area2D

@export var ray_scene: PackedScene = load("res://src/scenes/reflected_ray.tscn")
@export var draggable: bool = true # Set to false if mirror CANNOT be dragged
@export_group("Grating properties")
@export var order: int = 1
@export var groove_density: float = 1000 # mm^-1

var rotation_locked: bool = false
var can_rotate: bool = false
var can_interact: bool = false
var color_dict = {Color("BLUE"):450,Color("GREEN"):550,Color("RED"):750} # nm
var child_rays = []
var can_set_color = false
@onready var interact_panel = $InteractPanel
@onready var rotation_slider = $InteractPanel/OptionsContainer/RotationSlider
@onready var return_button = $InteractPanel/OptionsContainer/ReturnButton
var area_placed_in: PlaceableArea

signal return_to_inventory(grating: Object, area: PlaceableArea)

func _ready():
	add_to_group("diffractors")
	interact_panel.rotation = -self.rotation
	rotation_slider.value = self.rotation

	if(rotation_locked):
		rotation_slider.value = 0
		rotation_slider.editable = false
			
	rotation_slider.drag_started.connect(toggle_rotation)
	rotation_slider.drag_ended.connect(toggle_rotation)
	return_button.button_up.connect(return_self_to_inventory)

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
		var viewport_rect = get_viewport_rect().end
		var global_pos = interact_panel.global_position
		if(to_global(interact_panel.get_rect().end)[0] > viewport_rect[0]):
			var x_diff = abs(interact_panel.global_position.x - viewport_rect[0])
			interact_panel.global_position = global_pos - Vector2(x_diff,0)
		if(to_global(interact_panel.get_rect().end)[1] > viewport_rect[1]):
			var y_diff = abs(interact_panel.global_position.y - viewport_rect[1])
			interact_panel.global_position = global_pos - Vector2(0,y_diff)
		print(interact_panel.global_position)
	
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
	if(can_rotate):
		self.rotation = rotation_slider.value
		interact_panel.rotation = -rotation_slider.value
		interact_panel.global_position = IP_global_pos

func solve_grating_equation(in_angle,color):
	### Need to put [if(color==white): solve all 3 wavelengths] somewhere
	var out_angle = asin((order*color_dict[color])*(groove_density*1E-6)-sin(in_angle))
	#print("Color: "+str(color)+" Out angle: "+str(rad_to_deg(out_angle))) #debugging
	return out_angle
