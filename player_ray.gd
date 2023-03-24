extends "res://standard_ray.gd"

@export var length = 3000
@export var base_speed = 0.25
var true_speed

func _ready():
	intiate_line()
	self.target_position = Vector2(length,0)
	collide_with_areas = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_line_pos()
	
	if Input.is_action_pressed("speedup"):
		true_speed = base_speed*4
	elif Input.is_action_pressed("slowdown"):
		true_speed = base_speed/4
	else:
		true_speed = base_speed
	
	if Input.is_action_pressed("turn_clockwise"):
		self.target_position = self.target_position.rotated(-true_speed*delta)
	if Input.is_action_pressed("turn_counterclockwise"):
		self.target_position = self.target_position.rotated(true_speed*delta)
