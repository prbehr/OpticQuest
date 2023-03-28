extends RayCast2D

@export var ray_scene: PackedScene = load("res://src/scenes/reflected_ray.tscn")
var is_reflected = false # bool to control whether or not to make a new reflected ray
var is_diffracted = false
var update_diffraction_directions = true
var has_hit_detector: bool = false
var current_detector
var diffraction_directions = {Color("BLUE"):1.0,Color("GREEN"):1.0,Color("RED"):1.0}

# Called when the node enters the scene tree for the first time.
func _ready():
	collide_with_areas = true # Mirrors are Area2D nodes
	print("I'm here at position: "+str(self.position)) # Debugging
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_line_pos()

func get_line_color():
	return self.get_child(0).get_default_color()

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
				self.set_reflection_direction(1,collision_point,ref_direction.normalized()*3000)
		elif(collider_obj.is_in_group("diffractors")):
			# Calculate diffraction directions
			# If is_diffracted is true then the rays have already been created and we only need to update
			#	their position
			# Otherwise, create the 3 new rays in the appropriate directions
			
			# Calculate the incoming angle with dot product to normal. If it's > 90 then use 180-90
			var in_angle = acos(target_position.normalized().dot(get_collision_normal()))
			if(in_angle > PI/2):
				in_angle = PI-in_angle
			print(rad_to_deg(in_angle)) # Working
			for temp_color in diffraction_directions:
				var out_angle = collider_obj.solve_grating_equation(in_angle,temp_color)
				diffraction_directions[temp_color] = self.get_collision_normal().rotated(out_angle)
			if(is_diffracted==false):
				is_diffracted=true
				for temp_color in diffraction_directions:
					create_reflection(collision_point,diffraction_directions[temp_color]*3000,temp_color)
			if(is_diffracted==true):
				for i in range(1,get_child_count()):
					var temp_color = get_child(i).get_line_color()
					print(temp_color)
					set_reflection_direction(i,collision_point,diffraction_directions[temp_color])
		elif(collider_obj.is_in_group("detectors")):
			is_reflected = false
			if(has_hit_detector == false): # This will only run on the first time a ray hits a detector
				current_detector = collider_obj
				has_hit_detector = true
				# When ray hits detector, add it to the detector's array of lines
				current_detector.add_to_detector_array($Line2D)
	else:
		# If it's not colliding then it can't be reflecting or diffracting
		is_reflected = false
		is_diffracted = false
		if(has_hit_detector == true):
			# If not colliding with anything, remove from current detector array
			current_detector.remove_from_detector_array($Line2D)
			has_hit_detector = false
		# If not colliding with anything, update line position to raycast position
		$Line2D.set_point_position(1,self.target_position)
		
	if(is_reflected == false and self.get_child_count() > 1):
		# If a ray is not reflecting but has a reflection child, delete it
		free_children()
		
func create_reflection(new_position,direction: Vector2,line_color: Color = get_child(0).get_default_color()):
	print("Instantiating a reflection")
	var reflection_instance = ray_scene.instantiate()
	reflection_instance.add_exception(self.get_collider())
	reflection_instance.position = to_local(new_position)
	add_child(reflection_instance)
	reflection_instance.target_position = direction
	reflection_instance.get_node("Line2D").set_default_color(line_color)
	if(self.get_collider().can_set_color):
		self.get_collider().set_line_color(reflection_instance.get_node("Line2D"))

func set_reflection_direction(child_ind,new_position,direction: Vector2):
	var reflection = get_child(child_ind)
	reflection.global_position = new_position
	reflection.target_position = direction
	reflection.update_line_pos()
			
func free_children():
	for i in range(1,get_child_count(),1):
		self.get_child(i).queue_free()
