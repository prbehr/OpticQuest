extends Area2D

@export var accepted_color: Color = "white"
@export var rays_required: int = 1
var receiving_light: bool = false
var status_has_changed: bool = true
var current_rays = []
# Maintain a list of current rays and whether or not the array has changed since last frame
# If it has changed, update the status and check


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.add_theme_color_override("font_color",accepted_color)
	add_to_group("detectors")
	
func _process(delta):
	if(status_has_changed):
		update_status()

func update_status():
	var num_rays = 0
	for ray in current_rays:
		print(ray)
		# If a ray is deleted before moving off of a detector, its reference in the array becomes <null>
		#	if that happens it must be deleted or get_default_color() causes error
		if(ray == null):
			current_rays.pop_at(current_rays.find(ray))
			continue
		if(ray.get_default_color() == accepted_color):
			num_rays += 1
		if(num_rays >= rays_required):
			print("Minimum number of rays achieved")
			receiving_light = true
			self.get_parent().check_detector_status()
		else:
			receiving_light = false
	status_has_changed = false

func add_to_detector_array(ray: Line2D):
	current_rays.append(ray)
	print(current_rays)
	await get_tree().physics_frame
	status_has_changed = true
	
func remove_from_detector_array(ray: Line2D):
	var line_index = current_rays.find(ray)
	if(line_index != -1):
		current_rays.pop_at(line_index)
	await get_tree().physics_frame
	status_has_changed = true
	print(current_rays)
