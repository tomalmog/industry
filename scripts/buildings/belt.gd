extends "res://scripts/buildings/building.gd"

class_name Belt

# Properties
@export var speed: float = 2.0  # Speed at which items move on the belt

func _ready() -> void:
	type = BuildData.BELT_ID
	# Ensure direction is normalized (e.g., Vector2.RIGHT becomes (1, 0))
	direction = direction.normalized()  # probably can remove

func update_state(delta: float):
	pass
	#if stored_item != null:
		#var target_position = grid_position + direction
		#if can_move_to(target_position):
			#WorldManager.move_stored_item(self, BuildingManager.get_building(target_position))
		
	
	
func custom_behavior(delta: float):
	pass
