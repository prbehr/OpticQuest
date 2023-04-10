extends Line2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Line2D.set_point_position(1,self.get_point_position(1))
