extends Node2D

func go_to_scene(scene_name):
	get_tree().change_scene_to_file("res://scenes/%s.tscn" % scene_name)

func _on_rehearse_btn_pressed() -> void:
	go_to_scene("rehearsal")

func _on_live_btn_pressed() -> void:
	go_to_scene("live")
	
func _on_free_btn_pressed() -> void:
	go_to_scene("free")

func _ready():
	$ElManisero.play()
