extends "res://scripts/buildings/building.gd"

class_name Belt

# Properties
@export var speed: float = 2.0  # Speed at which items move on the belt

func initialize():
	type = BuildData.BELT_ID

func update_state(delta: float):
	pass
	#if stored_item != null:
		#var target_position = grid_position + direction
		#if can_move_to(target_position):
			#WorldManager.move_stored_item(self, BuildingManager.get_building(target_position))
		
#func can_accept_item(type: int) -> bool:
	#return stored_item != null
	
func _on_tick():
	pass
