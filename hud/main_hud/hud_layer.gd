extends CanvasLayer

onready var health_bar = $hud/margin/hud_h/bars/coverh/health
onready var damage_bar = $hud/margin/hud_h/bars/coverh/damage
onready var magicka_bar = $hud/margin/hud_h/bars/coverm/magicka
onready var haniwa_label = $hud/margin/hud_h/bars/Haniwa_lb
onready var debug_label = $hud/margin/hud_h/bars/debug_lb

onready var boss_hud = $hud/margin/hud_h/boss_pr
onready var boss_sg01 = $hud/margin/hud_h/boss_pr/cover/health1
onready var boss_sg02 = $hud/margin/hud_h/boss_pr/cover/health2
onready var boss_name_lb = $hud/margin/hud_h/boss_pr/boss_lb

onready var below_lb = $hud/margin/h/v/label
onready var below_tween = $hud/margin/h/v/label/Tween
onready var below_timer = $hud/margin/h/v/label/Timer

var boss_max_health
var boss_sg_health
var boss_health

onready var tween = $Tween
onready var tween2 = $Tween2
var _res

var health_temp

var refresh_time = 1.0

func _ready():
	# initialize()
	_res = Gamestate.connect("player_hurt", self, "on_player_hurt")
	_res = Gamestate.connect("player_health_changed", self, "on_health_change")
	_res = Gamestate.connect("player_max_health_changed", self, "on_max_health_change")
	_res = Gamestate.connect("player_magicka_changed", self, "on_magicka_change")
	_res = Gamestate.connect("player_max_magicka_changed", self, "on_max_magicka_change")
	_res = Gamestate.connect("boss_ready", self, "on_boss_ready")
	_res = Gamestate.connect("boss_health_changed", self, "on_boss_health_change")
	_res = Gamestate.connect("boss_clear", self, "on_boss_clear")
	

func _process(delta):
	if Game._debug:
		if refresh_time > 0:
			refresh_time -= delta
		else:
			refresh_time = 1.0
			update_debug()

func update_debug():
	var msg = """
	Debug message:
health: {h}
magicka: {m}
fps: {fps}
test version""".format({"h": Gamestate.state.health,
"hb": health_bar.value,
"m": Gamestate.state.magicka,
"fps": Engine.get_frames_per_second()})
	debug_label.text = msg

func show_text(msg: String = ""):
	below_lb.text = msg
	below_tween.interpolate_property(below_lb, "percent_visible", 0.0, 1.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	below_tween.start()
	below_timer.start(5.0)
	yield(below_timer, "timeout")
	below_tween.interpolate_property(below_lb, "percent_visible", 1.0, 0.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	below_tween.start()

func initialize():
	health_bar.value = Gamestate.state.max_health
	damage_bar.value = Gamestate.state.max_health
	magicka_bar.value = Gamestate.state.max_magicka
	health_bar.max_value = Gamestate.state.max_health
	damage_bar.max_value = Gamestate.state.max_health
	magicka_bar.max_value = Gamestate.state.max_magicka
	boss_hud.modulate.a = 0.0

func on_player_hurt(v):
	health_bar.value = Gamestate.state.health
	tween.interpolate_property(damage_bar, "value", v, Gamestate.state.health, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	

func on_health_change():
	health_bar.value = Gamestate.state.health
	
func on_magicka_change():
	magicka_bar.value = Gamestate.state.magicka

func on_max_health_change():
	health_bar.value = Gamestate.state.max_health
	health_bar.max_value = Gamestate.state.max_health
	
func on_max_magicka_change():
	magicka_bar.value = Gamestate.state.magicka
	magicka_bar.max_value = Gamestate.state.max_magicka

func on_boss_ready():
	boss_name_lb.text = Game.cur_boss.boss_name
	boss_max_health = Game.cur_boss.MAX_HEALTH
	boss_sg_health = boss_max_health / 2
	boss_sg01.max_value = boss_sg_health
	boss_sg02.max_value = boss_sg_health
	tween2.interpolate_property(boss_hud, "modulate:a", 0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.interpolate_property(boss_sg02, "value", 0, boss_sg_health, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()
	yield(tween2, "tween_all_completed")
	tween2.interpolate_property(boss_sg01, "value", 0, boss_sg_health, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()

func on_boss_health_change():
	var health = Game.cur_boss.health
	if health > boss_sg_health:
		boss_sg01.value = health - boss_sg_health
	else:
		if boss_sg01.value !=0:
			boss_sg01.value = 0
		boss_sg02.value = health

func on_boss_clear():
	tween2.interpolate_property(boss_hud, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()
