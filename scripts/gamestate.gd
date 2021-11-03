extends Node

var _fname = "gamestate.dat"
var state = {}
var saved_state = {}
var first_start = true

const ID = "010419"

signal player_hurt(start_health)

signal player_health_changed
signal player_max_health_changed
signal player_magicka_changed
signal player_max_magicka_changed

signal boss_ready
signal boss_health_changed
signal boss_clear

func set_state(k, v, save = false):
	state[k] = v
	if save:
		save_gamestate()
	return true

func player_hurt(v, s):
	if v < 0:
		v = 0
	self.state.health = v
	emit_signal("player_hurt", s)

func set_player_health(v):
	self.state.health = v
	emit_signal("player_health_changed")

func set_player_max_health(v):
	self.state.max_health = v
	emit_signal("player_max_health_changed")

func set_player_magicka(v):
	self.state.magicka = v
	emit_signal("player_magicka_changed")

func set_player_max_magicka(v):
	self.state.magicka = v
	emit_signal("player_max_magicka_changed")

func set_boss():
	emit_signal("boss_ready")

func boss_health_change():
	emit_signal("boss_health_changed")

func clear_boss():
	emit_signal("boss_clear")

#-----------------------------------
# speaking about state:
# current level stores the stage name
# current pos stores A position2D
#------------------------------------


func _ready():
	state_initialize()
	self.pause_mode = PAUSE_MODE_PROCESS


var debug_events = {
	"zone01_stage01_cutscene_over": false,
	"zone02_stage06_cutscene_over": false,
	"zone02_stage06_boss_defeat": false
}

func state_initialize():
	state = {
		"can_double_jump": false, 
		"can_graze": false,
		"current_level": "res://zone/zone1/stage01.tscn",
		"current_pos": "initial_position",
		"current_dir": 1,
		"bullet_damage": 60,
		"bullet_live_time": 0.5,
		"health": 100,
		"max_health": 100,
		"magicka": 100,
		"max_magicka": 100,
		"items": [0],
		"events": debug_events
	}

# save game state to file
func save_gamestate():
	if Game._debug:
		print( "SAVING GAMESTATE:" )
	saved_state = state.duplicate( true )
#	return false
	var f := File.new()
	var err := f.open_encrypted_with_pass( \
			_fname, File.WRITE, ID)
	if err == OK:
		f.store_var( state )
		f.close()
	else:
		f.close()


# load game state from file
func load_gamestate():
	var aux = _load_gamestate()
	if aux.empty():
		if Game._debug: 
			print( "gamestate: unable to load gamestate file" )
		if not saved_state.empty():
			if Game._debug: 
				print( "gamestate: using locally saved variable" )
			state = saved_state.duplicate( true )
		else:
			if Game._debug: 
				print( "gamestate: using initial gamestate" )
			state_initialize()
			saved_state = state.duplicate( true )
		return
	state = aux
	saved_state = state.duplicate( true )
	first_start = false
	Game.item_menu.load_item()

func _load_gamestate() -> Dictionary:
	var f := File.new()
	if not f.file_exists( _fname ):
		return {}
	var err = f.open_encrypted_with_pass( \
			_fname, File.READ, ID)
	if err != OK:
		f.close()
		return {}
	var data = f.get_var()
	f.close()
	return data


