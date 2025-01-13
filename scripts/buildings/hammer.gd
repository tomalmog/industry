extends TransformBuilding

class_name Hammer

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	
	inputs = {BuildData.directions[(rotation + 2) % 4]: 1}
	
	type = BuildData.SMELTER_ID
	operation_interval = 12
	
	pass
