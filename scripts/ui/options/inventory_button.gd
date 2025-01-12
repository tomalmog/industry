extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pressed.connect(open_inventory)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_inventory():
	# Attempt to load and change to the inventory scene
	var inventory_scene_path = "res://scenes/inventory.tscn"
	
	if ResourceLoader.exists(inventory_scene_path):  # Check if the path is valid
		var inventory_scene = preload("res://scenes/inventory.tscn")
		#get_tree().change_scene(inventory_scene)
		get_tree().change_scene_to_packed(inventory_scene)
	else:
		print("Error: Inventory scene not found at path: ", "res://scenes/inventory.tscn")
