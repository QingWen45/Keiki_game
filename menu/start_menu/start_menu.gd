extends Menu

var check

func _ready():
	set_selections_path("margin/hbox/selections")
	update_menu()

	check = get_parent().get_node("check")

	var _res = connect("selected", self, "on_selected")
	_res = check.connect("selected", self, "on_check")

	# Game.main.bgm_change(1)
	Gamestate.load_gamestate()

	if not Gamestate.first_start:
		Game.main.hud_layer.initialize()
		Game.item_menu.load_item()
		Game.item_menu.item_effect()
		$margin/hbox/selections/continue.selectable = true
		update_menu()
	
func _input(event):
	if event.is_action_pressed("quit"):
		cancel_fx()
		get_tree().quit()


func on_selected(selection_no):
	match selection_no:
		0:
			if not Gamestate.first_start:
				self.set_physics_process(false)
				check.activate()
				check.set_visible(true)
			else:
				start_new_game()
		1:
			Game.main.load_save()
		2:
			# load option screen ,yet in progress
			pass
		3:
			get_tree().quit()


func on_check(selection):
	match selection:
		0:
			start_new_game()
		1:
			check.deactivate()
			check.set_visible(false)
			set_physics_process(true)
			

func start_new_game():
	Gamestate.state_initialize()
	Gamestate.save_gamestate()
	Game.main.hud_layer.initialize()
	Game.item_menu.load_item()
	Game.item_menu.item_effect()
	Game.main.load_save()
