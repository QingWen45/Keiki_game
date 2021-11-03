extends KinematicBody2D


export (int) var DAMAGE = 20
export (int) var MOVE_SPEED = 60

onready var fsm = FSM.new(self, $states, $states/idle)

onready var anim = $anim
onready var anim_fx = $anim_fx

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
var is_first_attack: bool
var attack_range: int
var velo = Vector2()

# Enemy attributes ---
var health = 200
# --------------------

func _ready():
	is_first_attack = false
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
	
	velo = move_and_slide(velo, Vector2.UP)

	if is_player_detected \
		and fsm.state_next != fsm.states.dead \
		and fsm.state_next != fsm.states.attack\
		and fsm.state_last != fsm.states.attack:
		is_first_attack = true
		fsm.state_next = fsm.states.chase

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

func can_player_be_attacked() -> bool:
	if not is_player_detected: return false
	if is_first_attack:
		attack_range = 120
	else:
		attack_range = 60
	var player_rela_pos = Game.player.global_position - global_position
	if abs(player_rela_pos.x) < attack_range and abs(player_rela_pos.y) < 50:
		return true
	else:
		return false

func _on_player_dead():
	is_player_detected = false

func _on_hitbox_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

func _on_player_detect_body_entered(_body):
	is_player_detected = true

func _on_player_detect_body_exited(_body):
	is_player_detected = false
