extends Node2D

func _ready() -> void:
	for node in $Console.get_children():
		if node.name == "BG":
			continue
		var player = node.get_child(3)
		player.play()
