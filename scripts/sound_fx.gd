extends Node
class_name SoundFX

var sounds = {
	"Click" : load("res://assets/sound/Click.wav"),
	"Fail" : load("res://assets/sound/Fall.wav"),
	"Jump" : load("res://assets/sound/Jump.wav")
}

@onready var sound_players = get_children()

func play(sound_name: String) -> void:
	var sound_to_play = sounds[sound_name]
	for sound_player in sound_players:
		if !sound_player.playing:
			sound_player.stream = sound_to_play
			sound_player.play()
			return
	print("Too many sounds playing at once, not enough sound players!")
