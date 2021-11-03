extends Level

func _ready():
	Game.main.get_node("hud_layer").show_text("Thank you for playing.")

func _on_begin_body_entered(_body):
	Gamestate.state.current_level = "res://zone/zone2/stage06.tscn"
	Gamestate.state.current_pos = "end_position"
	Gamestate.state.current_dir = -1
	Game.main.load_save()
