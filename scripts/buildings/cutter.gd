extends TransformBuilding

class_name Cutter

# Called when the node enters the scene tree for the first time.
func initialize():
	type = BuildData.CUTTER_ID
	operation_interval = 16
	
	input_type = 2
	pass
