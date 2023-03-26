extends Node2D

@export var next_scene: PackedScene
@onready var anim_player = $AnimationPlayer

func check_detector_status():
	for node in get_children():
		if(node.is_in_group("detectors")):
			if(!node.receiving_light):
				pass # Passes if any detector is not receiving light
			else:
				proceed_to_next_scene()

func proceed_to_next_scene():
	anim_player.play("fade_to_black")
	await anim_player.animation_finished
	get_tree().change_scene_to_packed(next_scene)
