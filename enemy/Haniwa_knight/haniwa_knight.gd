extends KinematicBody2D


export (int) var DAMAGE = 25
export (int) var MOVE_SPEED = 50

onready var fsm = FSM.new(self, $states, $states/idle)

onready var anim = $anim
onready var anim_fx = $anim_fx

onready var hit_box = $rotator/hitbox/collider
onready var spear = $rotator/Sprite/spear

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
var velo = Vector2()

# Enemy attributes ---
var health = 200
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
	
	velo = move_and_slide(velo * dir_cur, Vector2.UP)

	if is_player_detected and fsm.state_next != fsm.states.dead and fsm.state_next != fsm.states.charge:
		fsm.state_next = fsm.states.attack

func check_wall() -> bool:
	return $rotator/wall_detect.is_colliding() or not $rotator/cliff_detect.is_colliding()

func disable_collider():
	$hurtbox/collider.disabled = true
	$rotator/hitbox/collider.disabled = true
	$rotator/player_detect/collider.disabled = true

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
	disable_collider()

func _on_hitbox_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

func _on_player_detect_body_entered(_body):
	is_player_detected = true

func _on_player_detect_body_exited(_body):
	is_player_detected = false
