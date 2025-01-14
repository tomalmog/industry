extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pressed.connect(open_upgrades)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_upgrades():
	# Attempt to load and change to the inventory scene
	
	get_node("/root/World/Camera").save_camera()
	
	var upgrades_scene = preload("res://scenes/upgrades.tscn")
	get_tree().change_scene_to_packed(upgrades_scene)
	WorldManager.set_state(WorldManager.UPGRADE_STATE)
	for item in ItemManager.items:
		item.set_visibility(false)
