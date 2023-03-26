extends RayCast2D

@export var ray_scene: PackedScene = load("res://src/scenes/reflected_ray.tscn")
var is_reflected = false # bool to control whether or not to make a new reflected ray
var has_hit_detector: bool = false
var current_detector

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
		var collider_obj = self.get_collider()
		
		if(collider_obj.is_in_group("reflectors")):
			var ref_direction = Vector2(self.target_position.normalized()).bounce(self.get_collision_normal())
			if(is_reflected==false):
				is_reflected=true
				self.create_reflection(self.get_collision_point(),ref_direction)
				print(rad_to_deg(target_position.normalized().angle_to(get_collision_normal())))
			if(is_reflected==true):
				self.set_reflection_direction(collision_point,ref_direction.normalized()*3000)
				
		elif(collider_obj.is_in_group("detectors")):
			is_reflected = false
			if(has_hit_detector == false): # This will only run on the first time a ray hits a detector
				current_detector = collider_obj
				has_hit_detector = true
				# When ray hits detector, add it to the detector's array of lines
				current_detector.add_to_detector_array($Line2D)
		
	else:
		is_reflected = false
		if(has_hit_detector == true):
			# If not colliding with anything, remove from current detector array
			current_detector.remove_from_detector_array($Line2D)
			has_hit_detector = false
		# If not colliding with anything, update line position to raycast position
		$Line2D.set_point_position(1,self.target_position)
		
	if(is_reflected == false and self.get_child_count() > 1):
		# If a ray is not reflecting but has a reflection child, delete it
		self.get_child(1).queue_free()
		
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

func set_reflection_direction(new_position,direction: Vector2):
	var reflection = get_child(1) # Any given ray ~should~ only have 2 children: Line2D & another ray
	reflection.global_position = new_position
	reflection.target_position = direction
	reflection.update_line_pos()
