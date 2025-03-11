extends Control

# initialize tutorial array of tutorial texts
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
	"[center]The smelter has two input directions and requires both coal and ore to operate. It produces a nugget.[/center]",
	"[center]TIPS: Hold CTRL to move around faster and press SPACE to return to hub.[/center]",
	"[center]Congratulations! You have finished the tutorial! Continue exploring new resources and upgrading buildings![/center]",
	"[center]Complete the hub's missions as fast as you can![/center]",
]

# index of current tutorial step
var current_step: int = 0

# references to the UI components, loads when ready is run
@onready var tutorial_text_label: RichTextLabel = $TutorialText
@onready var back_button: Button = $BackButton
@onready var next_button: Button = $NextButton
@onready var tutorial_panel: Control = self 

# Pre: none
# Post: none
# Description: initialize tutorial display
func _ready():
	# hide panel if panel is supposed to be hidden
	if WorldManager.get_tutorial_data()[1] == false:
		visible = false
	
	# load in current tutorial stepe
	current_step = WorldManager.get_tutorial_data()[2]
	
	# initialize the tutorial display
	update_tutorial_text()

	# connect button signals
	back_button.pressed.connect(on_back_pressed)
	next_button.pressed.connect(on_next_pressed)

# Pre: none
# Post: none
# Description: connects hide panel function to self.pressed
func update_tutorial_text():
	# update current step, and current tutorial text
	WorldManager.set_tutorial_data(current_step, 2)
	tutorial_text_label.text = tutorial_texts[current_step]

	# Update button states based on the current step
	back_button.disabled = current_step <= 0
	
	# update the next button text based on whether it is last step
	if current_step >= tutorial_texts.size() - 1:
		next_button.text = "FINISH"
	else:
		next_button.text = "NEXT"

# Pre: none
# Post: none
# Description: move back a tutorial step
func on_back_pressed():
	# move back if possible
	if current_step > 0:
		current_step -= 1
		update_tutorial_text()
	
	# play button clicked sound effect
	AudioManager.play_button_click_sound()

# Pre: none
# Post: none
# Description: moves forward a tutorial step
func on_next_pressed():
	# if on the last step, finish the tutorial and hide panel
	if current_step >= tutorial_texts.size() - 1:
		tutorial_panel.visible = false
		WorldManager.set_tutorial_data(false, 1)
	else:
		# move to the next tutorial step
		current_step += 1
		update_tutorial_text()
	
	# play button clicked sound effect
	AudioManager.play_button_click_sound()
