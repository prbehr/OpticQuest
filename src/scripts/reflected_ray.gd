extends "res://src/scripts/standard_ray.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	intiate_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_line_pos()
