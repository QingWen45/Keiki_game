extends KinematicBody2D

var _debug = false

export (int) var GRAVITY = 800
export (int) var SNAP_LEN = 30

export (float) var JUMP_FORCE = -400
export (float) var MAX_SPEED = 160
export (float) var MAX_FALL_SPEED = 300
export (float) var AIR_ACCEL = 0.3
export (float) var JUMP_MARGIN = 0.2
export (float) var JUMP_AGAIN_TIME = 0.2

onready var fsm = FSM.new(self, $states, $states/idle, _debug)

onready var anim = $anim
onready var anim_fx = $anim_fx

onready var bullet_spawn = $rotator/bullet_spawn
onready var dialog_spawn = $rotator/dialog_spawn
onready var dialog_label = $Label

var run_dust = preload("res://player/effects/run_dust.tscn")
var jump_dust = preload("res://player/effects/jump_dust.tscn")
var bullet = preload("res://player/bullets/bullet.tscn")

var dialog_set = ["create!", "oh!"]

var anim_cur = ""
var anim_next = "idle"
var dir_cur = 1
var dir_next = 1

var is_invulnerable = false
var invulnerable_timer = 0.0

var attack_stun_timer = 0.0
var attack_gap = 0.0
var has_double_jumped : bool = false

var velo = Vector2()
var snap_vector = Vector2()

# warning-ignore: unused_signal
signal player_dead

onready var jump_audio = preload("res://assets/audio/player/jump.wav")
onready var hit_audio = preload("res://assets/audio/player/se_tan00.wav")
onready var death_audio = preload("res://assets/audio/player/se_pldead00.wav")

onready var attack_mp = $AudioStreamPlayer
onready var fx_mp = $AudioStreamPlayer2
onready var graze_mp = $AudioStreamPlayer3
onready var step_mp = $step

func sound_play(stream):
	fx_mp.stream = stream
	fx_mp.play()

func _ready():
	Game.player = self

func _exit_tree():
	fsm.free()

func _physics_process(delta):
	fsm.run_machine(delta)

	if attack_stun_timer >= 0:
		attack_stun_timer -= delta

	if attack_gap >= 0:
		attack_gap -= delta

	if anim_cur != anim_next:
		# if _debug:
			# print("Changing anim to ",anim_next)	
		anim_cur = anim_next
		anim.play(anim_cur)
	
	if dir_cur != dir_next:
		dir_cur = dir_next
		$rotator.scale.x = dir_cur

	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false
	
	velo = move_and_slide_with_snap(velo, snap_vector * SNAP_LEN, Vector2.UP)

	if is_on_floor():
		snap_vector = Vector2.DOWN

func jump():
	sound_play(jump_audio)
	velo.y = JUMP_FORCE
	velo += get_floor_velocity()
	snap_vector = Vector2.ZERO


func attack():
	attack_stun_timer = 0.1
	attack_gap = 0.4

	var b = bullet.instance()
	b.position.x = bullet_spawn.position.x * dir_cur + position.x
	b.position.y = bullet_spawn.position.y + position.y
	b.dir = dir_cur
	get_parent().add_child(b)

	attack_mp.play()

func can_move() -> bool:
	return attack_stun_timer < 0

func can_attack() -> bool:
	return attack_gap < 0


func can_be_hit() -> bool:
	if fsm.state_cur == fsm.states.hurt:
		return false
	if fsm.state_cur == fsm.states.dead:
		return false
	if is_invulnerable:
		return false
	return true


func run_dust_generate():
	var d = run_dust.instance()
	d.position = position + Vector2(dir_cur * -10, 28)
	get_parent().add_child(d)

func jump_dust_generate(v_offset):
	var d = jump_dust.instance()
	# generate under feet
	d.position = position + Vector2(0, v_offset)
	get_parent().add_child(d)


func hurt(area, damage):
	if not can_be_hit():
		return

	Game.camera.shake(2, 0.3)
	
	var hurt_dir = global_position - area.global_position
	Gamestate.player_hurt(Gamestate.state.health - damage, Gamestate.state.health)
	if Gamestate.state.health == 0:
		sound_play(death_audio)
		velo = hurt_dir.normalized() * 300
		fsm.state_next = fsm.states.dead
	else:
		say("OH!")
		sound_play(hit_audio)
		velo = hurt_dir.normalized() * 300
		fsm.state_next = fsm.states.hurt
		

func say(msg, duration = 1.0):
	dialog_label.show_dialog(msg, dialog_spawn.position, duration)

# create!
func graze_effect_create(v, max_v):
	var increment
	increment = v * 0.1 * (max_v * 0.8 - v) / max_v
	return v + increment


func _on_graze_area_exited(area):
	if not Gamestate.state.can_graze:
		 return
	if (area.global_position - global_position).length() < 30:
		return

	var h = Gamestate.state.health
	var mh = Gamestate.state.max_health
	var m = Gamestate.state.magicka
	var mm = Gamestate.state.max_magicka
	if h <= 0.8 * mh:
		h = graze_effect_create(h, mh)
		Gamestate.set_player_health(h)
	if m <= mm * 0.8:
		m = graze_effect_create(m, mm)
		Gamestate.set_player_magicka(m)

	graze_mp.play()

func _on_death_timer_timeout():
	Game.main.load_save()
