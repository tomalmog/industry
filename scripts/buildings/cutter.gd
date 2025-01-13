extends TransformBuilding

class_name Cutter

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	type = BuildData.CUTTER_ID
	operation_interval = 16
	
	inputs = {BuildData.directions[(rotation + 2) % 4]: 2}
	pass
