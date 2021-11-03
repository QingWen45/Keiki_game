extends Level


func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone2/stage03.tscn"
	Gamestate.state.current_pos = "end_position"
	Gamestate.state.current_dir = -1
	Game.main.load_save()

func _on_end_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone2/stage05.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()
