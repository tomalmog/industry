extends TransformBuilding

class_name Smelter

var has_coal = false

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	var BD = BuildData
	
	output_direction = BD.directions[rotation]
	inputs = {BD.directions[(rotation + 2) % 2]: 0, BD.directions[(rotation + 3) % 2]: 9}
	
	type = BuildData.SMELTER_ID
	operation_interval = 8
	
	input_type = 0
	pass
	

#func can_accept_item(item: Item, input_direction: Vector2):
	#pass
