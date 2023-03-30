extends Node2D

@export var next_scene: PackedScene
@onready var anim_player = $AnimationPlayer
var num_detectors: int = 0

func _ready():
	for node in get_children():
		if(node.is_in_group("detectors")):
			num_detectors += 1

func check_detector_status():
	var current_status = 0
	for node in get_children():
		if(node.is_in_group("detectors")):
			if(!node.receiving_light):
				break # exits loop if any detector is not receiving light
			else:
				current_status += 1
	if(current_status >= num_detectors):
		proceed_to_next_scene()

func proceed_to_next_scene():
	anim_player.play("fade_to_black")
	await anim_player.animation_finished
	get_tree().change_scene_to_packed(next_scene)
