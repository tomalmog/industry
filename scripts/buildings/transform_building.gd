extends Building

class_name TransformBuilding

var input_type: int
var output_type: int

var is_generating: bool = false
var generating_type: int

	
func can_accept_item(item: Item, input_direction: Vector2) -> bool:
	if is_empty() && !is_generating && inputs.has(input_direction) && item.type % 10 == inputs[input_direction]:
		return true
	return false
	
func input_item():
	output_type = stored_item.type
	
	ItemManager.delete_item(stored_item)
	stored_item = null
	
	tick_counter = 0
	is_generating = true
	
func _run_tick():
	if is_empty() && is_generating && tick_counter >= operation_interval:
		var item = ItemManager.spawn_item(output_type + 1, self)
		
		is_generating = false
	pass
	
