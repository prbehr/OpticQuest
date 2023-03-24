extends RayCast2D

@export var ray_scene: PackedScene = load("res://reflected_ray.tscn")
var is_reflected = false # bool to control whether or not to make a new reflected ray

# Called when the node enters the scene tree for the first time.
func _ready():
	collide_with_areas = true # Mirrors are Area2D nodes
	print("I'm here at position: "+str(self.position)) # Debugging
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_line_pos()

func intiate_line():
	$Line2D.set_point_position(1,self.target_position) #Set the line to follow the RayCast2D

func update_line_pos():
	if(self.is_colliding()):
		# Set the line to end at the raycast collision point
		var collision_point = self.get_collision_point()
		$Line2D.set_point_position(1,to_local(collision_point))
		var ref_direction = Vector2(self.target_position.normalized()).bounce(self.get_collision_normal())
		if(is_reflected==false):
			is_reflected=true
			self.create_reflection(self.get_collision_point(),ref_direction)
			print(rad_to_deg(target_position.normalized().angle_to(get_collision_normal())))
		if(is_reflected==true):
			self.set_reflection_direction(collision_point,ref_direction.normalized()*3000)
		
	else:
		if(is_reflected==true):
			is_reflected=false
			self.get_child(1).queue_free()
		$Line2D.set_point_position(1,self.target_position)
		
func create_reflection(new_position,direction: Vector2):
	print("Instantiating a reflection")
	var reflection_instance = ray_scene.instantiate()
	reflection_instance.add_exception(self.get_collider())
	reflection_instance.position = to_local(new_position)
	add_child(reflection_instance)
	reflection_instance.target_position = new_position
	reflection_instance.get_node("Line2D").set_default_color(self.get_node("Line2D").get_default_color())
	if(self.get_collider().can_set_color):
		self.get_collider().set_line_color(reflection_instance.get_node("Line2D"))

func set_reflection_direction(position,direction: Vector2):
	var reflection = get_child(1) # Any given ray ~should~ only have 2 children: Line2D & another ray
	reflection.global_position = position
	reflection.target_position = direction
	reflection.update_line_pos()
