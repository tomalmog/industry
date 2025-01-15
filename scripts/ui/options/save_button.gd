extends TextureButton

# Pre: none
# Post: none
# Description: connects the button's pressed signal to the save_game_data function
func _ready():
	pressed.connect(save_game_data)

# Pre: none
# Post: saves the game data
# Description: handles the process of saving game data when the save button is pressed
func save_game_data():
	SaveDataManager.save_game_data()
