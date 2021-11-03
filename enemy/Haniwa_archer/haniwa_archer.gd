extends KinematicBody2D

export (int) var ARROW_DAMAGE = 10
export (int) var SCOUT = 0

onready var fsm = FSM.new(self, $states, $states/idle)

onready var arrow_spawn = $arrow_spawn

onready var anim = $anim
onready var anim_fx = $anim_fx

var arrow = preload("res://enemy/Haniwa_archer/arrow.tscn")

onready var music1 = $AudioStreamPlayer
onready var music2 = $AudioStreamPlayer2
onready var hit_audio = preload("res://assets/audio/enemy/hit.wav")
onready var death_audio = preload("res://assets/audio/enemy/haniwa/crash.wav")

func music_play(player, stream):
	player.stream = stream
	player.play()

var anim_cur = ""
var anim_next = "idle"
var dir_cur = 1
var dir_next = -1

var is_player_detected :bool
var start_attack: bool = false
var attack_counter = 5

# Enemy attributes ---
var health = 150
# --------------------

func _ready():
	Game.player.connect("player_dead", self, "_on_player_dead")

func _exit_tree():
	fsm.free()

func _physics_process(delta):
	fsm.run_machine(delta)

	if anim_cur != anim_next:
		anim_cur = anim_next
		anim.play(anim_cur)
	
	if dir_cur != dir_next:
		dir_cur = dir_next
		$rotator.scale.x = dir_cur

	if is_player_detected and fsm.state_next != fsm.states.dead:
		fsm.state_next = fsm.states.attack


func disable_collider():
	$hurtbox/collider.disabled = true
	$rotator/player_detect/collider.disabled = true

func attack():
	$Timer.start()
	# warning-ignore: unused_variable
	for i in range(attack_counter):
		_attack()
		yield($Timer, "timeout")
	$Timer.stop()

func _attack():
	var a = arrow.instance()
	a.dir = dir_cur
	a.position.x = arrow_spawn.position.x * dir_cur + position.x
	a.position.y = arrow_spawn.position.y + position.y
	get_parent().add_child(a)
	music1.play()

func hurt(_area, damage):
	if not is_player_detected:
		is_player_detected = true
	anim_fx.play("hit")
	health -= damage
	if health <= 0:
		music_play(music2, death_audio)
		fsm.state_next = fsm.states.dead
	else:
		music_play(music2, hit_audio)

func _on_player_dead():
	is_player_detected = false

func _on_player_detect_body_entered(_body):
	is_player_detected = true

func _on_player_detect_body_exited(_body):
	is_player_detected = false
