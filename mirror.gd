extends Area2D

@export var ray_scene: PackedScene = load("res://reflected_ray.tscn")
@export var can_set_color: bool = false
@export var color_to_set: Color
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_line_color(line: Line2D):
	if(can_set_color):
		line.set_default_color(color_to_set)
