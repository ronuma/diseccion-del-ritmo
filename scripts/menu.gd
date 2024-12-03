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
	
var play_icon = preload("res://sprites/Mute.png")
var mute_icon = preload("res://sprites/Play.png")

func _on_play_btn_pressed() -> void:
	if $ElManisero.playing:
		$ElManisero.stop()
		$PlayBtn.set_button_icon(play_icon)
	else:
		$ElManisero.play()
		$PlayBtn.set_button_icon(mute_icon)
