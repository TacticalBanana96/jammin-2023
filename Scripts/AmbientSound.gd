extends AudioStreamPlayer2D

func _ready() -> void:
	self.play()


func _process(delta: float) -> void:
	if self.playing == false:
		self.play()
