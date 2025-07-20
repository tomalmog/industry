# Author: Tom Almog
# File Name: audio_manager.gd
# Project Name: Industry
# Creation Date: 1/13/2025
# Modified Date: 1/14/2025
# Description: manages game audio
extends Node
var music_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load in the music file and set it to loop
	var music_stream = load("res://assets/audio/music.mp3") 
	music_stream.loop = true
	
	# create music audio player and set its audio stream to the music
	music_player = AudioStreamPlayer.new()
	music_player.stream = music_stream
<<<<<<< HEAD
=======
	music_player.volume_db = -20
>>>>>>> 1c6af5a (Fixed music and sound volume. Added documentation. Fixed visual bugs)
	
	# being playing music and add audioplayer as child so that its always running
	music_player.autoplay = true
	add_child(music_player)

# pre: sound is an audio file
# post: none
# description: plays a given sound
func play_sound(sound: AudioStream):
	# Create a new AudioStreamPlayer instance
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	# Assign the sound and play it
	audio_player.stream = sound
<<<<<<< HEAD
=======
	audio_player.volume_db = -20
>>>>>>> 1c6af5a (Fixed music and sound volume. Added documentation. Fixed visual bugs)
	audio_player.play()
	
	# Queue the node for deletion once the sound is finished
	audio_player.connect("finished", Callable(audio_player.queue_free))

# pre: none
# post: none
# description: plays the button clicked sound
func play_button_click_sound():
	# Create a new AudioStreamPlayer instance
	var audio_player = AudioStreamPlayer.new()
	var clicked_sound = preload("res://assets/audio/click.mp3")
	add_child(audio_player)
	
	# Assign the sound and play it
	audio_player.stream = clicked_sound
<<<<<<< HEAD
=======
	audio_player.volume_db = -20
>>>>>>> 1c6af5a (Fixed music and sound volume. Added documentation. Fixed visual bugs)
	audio_player.play()
	
	# Queue the node for deletion once the sound is finished
	audio_player.connect("finished", Callable(audio_player.queue_free))
