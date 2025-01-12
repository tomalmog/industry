extends "res://scripts/buildings/building.gd"

class_name Belt

# Properties
@export var speed: float = 2.0  # Speed at which items move on the belt

func initialize(rotation: int):
	output_direction = BuildData.directions[rotation]
	#inputs = {-1: BuildData.directions[(rotation + 2) % 4]}
	type = BuildData.BELT_ID

func update_state(delta: float):
	pass

func _on_tick():
	pass
