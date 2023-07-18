extends Control
@onready var AmbientSound = $"/root/AmbientSound"

func _ready():
	var ambientAudio: AudioStream = load("res://Assets/Audio/262259__shadydave__snowfall-final.mp3");
	AmbientSound.set_stream(ambientAudio);
	AmbientSound.play();
