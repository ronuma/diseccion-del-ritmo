# Attempt to animate the sprite along with the music

extends Sprite2D

var elapsed = 0

func _process(delta: float) -> void:
	elapsed += delta
