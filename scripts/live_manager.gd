extends Node

var loop_duration = globals.LOOP_DURATION
var bar_duration = loop_duration / 2
const PASS_RANGE = 0.05

var i = 0
func _ready() -> void:
	pass
	#for node in $Console.get_children():
		#print(node)

func check_score(val: float):
	# Check if value is valid and "in time"
	return val <= PASS_RANGE || val >= loop_duration - PASS_RANGE || (val <= loop_duration / 2 + PASS_RANGE && val >= loop_duration / 2 - PASS_RANGE)

# func _process(_delta):
# 	if Input.is_action_just_pressed("ui_accept"):
# 		node_to_play.play()
# 		if i < len(audio_nodes):
# 			node_to_stop = node_to_play
# 			# Don't go out of the range
# 			i = i + 1 if i != len(audio_nodes) - 1 else i
# 			node_to_play = audio_nodes[i]
# 			update_sprite()
# 		else:
# 			$NextLabel.text = "Todos están tocando"
# 			#change_sprite_texture("FirstBG.png")
			
# 	if Input.is_action_just_pressed("undo"):
# 		if i == 0:
# 			return
# 		node_to_stop.stop()
# 		if i > 0:
# 			i -= 1
# 		node_to_play = audio_nodes[i]
# 		update_sprite()
# 		$NextLabel.text = "Siguiente instrumento: "
# 		if $ResultLabel.visible:
# 			$ResultLabel.visible = false
	
# 	if Input.is_action_just_pressed("restart"):
# 		for node in audio_nodes:
# 			node.stop()
# 		i = 0
# 		node_to_play = audio_nodes[i]
# 		node_to_stop = null
# 		update_sprite()
# 		$ResultLabel.visible = false
