extends Level

func _ready():
	pass # Replace with function body.

func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage02.tscn"
	Gamestate.state.current_pos = "end_position"
	Gamestate.state.current_dir = -1
	Game.main.load_save()

func _on_end_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage04.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = -1
	Game.main.load_save()

func _on_end2_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage05.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()

func _on_end3_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage11.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()
