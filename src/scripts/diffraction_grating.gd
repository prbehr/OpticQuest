extends Area2D

@export var ray_scene: PackedScene = load("res://src/scenes/reflected_ray.tscn")
@export var draggable: bool = true # Set to false if mirror CANNOT be dragged
@export_group("Grating properties")
@export var order: int = 1
@export var groove_density: float = 1000 # mm^-1

var can_move: bool = false
var check_for_drag: bool = false
var color_dict = {Color("BLUE"):450,Color("GREEN"):550,Color("RED"):750} # nm
var child_rays = []
var can_set_color = false

func _ready():
	add_to_group("diffractors")

func _mouse_enter():
	check_for_drag = true
	#print("Mouse entered mirror at: "+str(self.position)) #debugging

func _mouse_exit():
	check_for_drag = false
	#print("Mouse exited mirror at: "+str(self.position)) #debugging

func _unhandled_input(event):
	if(check_for_drag and event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT):
		#print("Registered LMB in mirror at: "+str(self.position)) #debugging
		if(event.pressed):
			can_move = true
		if(!event.pressed):
			can_move = false

func _process(delta):
	if(draggable and can_move):
		self.global_position = get_global_mouse_position()

func solve_grating_equation(in_angle,color):
	### Need to put [if(color==white): solve all 3 wavelengths] somewhere
	var out_angle = asin((order*color_dict[color])*(groove_density*1E-6)-sin(in_angle))
	print("Color: "+str(color)+" Out angle: "+str(out_angle))
	return out_angle
