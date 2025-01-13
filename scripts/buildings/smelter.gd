extends TransformBuilding

class_name Smelter

var has_coal = false
var has_ore = false

# Called when the node enters the scene tree for the first time.
func initialize(rotation: int):
	var BD = BuildData
	
	inputs = {BD.directions[(rotation + 2) % 4]: 0, BD.directions[(rotation + 3) % 4]: 9}
	
	type = BuildData.SMELTER_ID
	operation_interval = 8
	
	input_type = 0
	pass
	

func can_accept_item(item: Item, input_direction: Vector2) -> bool:
	if item.type == ItemManager.COAL_ORE && has_coal == true:
		return false
	
	if !has_ore && !is_generating && inputs.has(input_direction) && item.type % 10 == inputs[input_direction]:
		return true
	return false
	
func input_item():
	if stored_item.type == ItemManager.COAL_ORE:
		ItemManager.delete_item(stored_item)
		stored_item = null
		has_coal = true
		
		try_generating()
		
	else:
		output_type = stored_item.type
		
		ItemManager.delete_item(stored_item)
		stored_item = null
		
		has_ore = true
		
		try_generating()
		

func try_generating():
	if has_ore && has_coal:
		tick_counter = 0
		is_generating = true
		
		has_coal = false
		has_ore = false
