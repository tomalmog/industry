extends Control

# Array of tutorial texts
var tutorial_texts: Array[String] = [
	"[center]Welcome to Industry! Use WASD to move around.[/center]",
	"[center]Press 2 or use your hotbar to select the Harvester. This building generates resources when placed over a resource node[/center]",
	"[center]Place the Harvester over a gold ore resource node. These can be found dotted around the map.[/center]",
	"[center]Press 1 or use your hotbar to select a Belt. This building is used to transport items.[/center]",
	"[center]Using belts, connect your harvester to the center of your world, this center is called the hub.[/center]",
	"[center]To open your inventory, press the chest icon on the top right of your screen. Here you can see every item you have stored.[/center]",
	"[center]Once you have reached 100 gold ore, press the arrow icon besides the chest to open your upgrades tab.[/center]",
	"[center]You should have enough gold ore to upgrade your harvester, it will now begin to produce items faster.[/center]",
	"[center]Press 3 or use your hotbar to select the Smelter.[/center]",
	"[center]The smelter requires an input of ore from the bottom and coal from the side. It produces a nugget.[/center]",
	"[center]TIPS: Hold CTRL to move around faster and press SPACE to return to hub.[/center]",
	"[center]Congratulations! You have finished the tutorial! Continue exploring new resources and upgrading buildings![/center]",
	"[center]Complete the hub's missions as fast as you can![/center]",
]

# Index of the current tutorial step
var current_step: int = 0

# References to the UI components
@onready var tutorial_text_label: RichTextLabel = $TutorialText
@onready var back_button: Button = $BackButton
@onready var next_button: Button = $NextButton
@onready var tutorial_panel: Control = self  # Assuming this script is attached to the TutorialPanel node

func _ready() -> void:
	
	if WorldManager.get_tutorial_data()[1] == false:
		visible = false
	
	current_step = WorldManager.get_tutorial_data()[2]
	
	# Initialize the tutorial display
	update_tutorial_text()

	# Connect button signals using Godot 4 methods
	back_button.pressed.connect(_on_back_pressed)
	next_button.pressed.connect(_on_next_pressed)

func update_tutorial_text() -> void:
	WorldManager.set_tutorial_data(current_step, 2)
	# Update the text label with the current tutorial text
	tutorial_text_label.text = tutorial_texts[current_step]

	# Update button states based on the current step
	back_button.disabled = current_step <= 0
	
	# Update the next button text
	if current_step >= tutorial_texts.size() - 1:
		next_button.text = "FINISH"
	else:
		next_button.text = "NEXT"

func _on_back_pressed() -> void:
	# Move to the previous tutorial step
	if current_step > 0:
		current_step -= 1
		update_tutorial_text()

func _on_next_pressed() -> void:
	# If on the last step, finish the tutorial
	if current_step >= tutorial_texts.size() - 1:
		tutorial_panel.visible = false
		WorldManager.set_tutorial_data(false, 1)
	else:
		# Move to the next tutorial step
		current_step += 1
		update_tutorial_text()
