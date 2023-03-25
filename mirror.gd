extends Area2D

@export var ray_scene: PackedScene = load("res://reflected_ray.tscn")
@export var can_set_color: bool = false
@export var color_to_set: Color
var can_move: bool = false
var check_for_drag: bool = false

func _ready():
	add_to_group("reflectors")

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
	if(can_move):
		self.global_position = get_global_mouse_position()

func set_line_color(line: Line2D):
	if(can_set_color):
		line.set_default_color(color_to_set)
