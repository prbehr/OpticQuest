extends PanelContainer

@export_multiline var pop_up_text = ""
var text_array: Array
var current_text: int = 0
@onready var pop_up_label = $VBoxContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	text_array = pop_up_text.split("\n",false)
	pop_up_label.text = text_array[current_text]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	current_text += 1
	if(current_text < len(text_array)):
		pop_up_label.text = text_array[current_text]
	else:
		self.queue_free()
