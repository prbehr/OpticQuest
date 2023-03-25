extends Area2D

@export var accepted_color: Color = "white"
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.add_theme_color_override("font_color",accepted_color)
	add_to_group("detectors")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_light_color(ray: Line2D):
	if(ray.get_default_color()==accepted_color):
		print("You fuckin did it!!!")
