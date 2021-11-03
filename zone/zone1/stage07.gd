extends Level

func _ready():
	pass

func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage06.tscn"
	Gamestate.state.current_pos = "end_position"
	Gamestate.state.current_dir = -1
	Game.main.load_save()

func _on_end_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage09.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()

func _on_end2_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone1/stage08.tscn"
	Gamestate.state.current_pos = "initial_position"
	Gamestate.state.current_dir = 1
	Game.main.load_save()
