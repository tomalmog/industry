extends "res://scripts/buildings/building.gd"

class_name Belt

# Properties

func initialize(rotation: int):
	#output_direction = BuildData.directions[rotation]
	type = BuildData.BELT_ID

func update_state(delta: float):
	pass

func _on_tick():
	pass
