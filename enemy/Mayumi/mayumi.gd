extends KinematicBody2D

#------------------------------
# get ready for the first boss!
#------------------------------

export (int) var MAX_HEALTH = 20
export (int) var DAMAGE = 20
export (int) var MOVE_SPEED = 100
export (float) var DECISION_TIMER = 0.5

onready var fsm = FSM.new(self, $states, $states/idle)
onready var arrow = preload("res://enemy/Mayumi/Haniwa/arrow.tscn")
onready var haniwas = get_parent().get_node("haniwas").get_children()

onready var anim = $anim
onready var anim_fx = $anim_fx
onready var gap = $gap_timer

onready var boss_pos = get_parent().get_node("boss_pos")
onready var boss_pos2 = get_parent().get_node("boss_pos2")
onready var tween = $Tween

onready var sprite = $rotator/Sprite
onready var visual_gen = get_parent().get_node("visual_stay")

var anim_cur = ""
var anim_next = "idle"
var dir_cur = 1
var dir_next = 1

var velo = Vector2()

export(bool) var is_active = false

var has_summoned = false
var player_dead = false

# Enemy attributes ---
var boss_name = "Joutougu Mayumi"
var health = MAX_HEALTH
# --------------------

func _ready():
	if not is_active:
		deactivate()
	Game.cur_boss = self
	Game.player.connect("player_dead", self, "_on_player_dead")
	visual_gen.initialize(sprite.texture, sprite.hframes, sprite.vframes)

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
		
	if fsm.state_next != fsm.states.summon:
		velo = move_and_slide(velo, Vector2.UP)

func activate():
	set_physics_process(true)

func deactivate():
	set_physics_process(false)

func get_player_pos() -> bool:
	return Game.player.global_position - global_position

func attack1():
	velo.x = 1600 * dir_cur
	$attack_player.play()

func attack2():
	danmaku_create(5)
	velo.x = 400 * dir_cur
	$attack_player.play()

func danmaku_create(v):
	# warning-ignore:unused_variable
	for i in range(v):
		i *= -1
		var dir =  Vector2.RIGHT.rotated(deg2rad(i*45))
		var a = arrow.instance()
		a.position = position
		a.rotate(dir.angle())
		a.dir = dir
		get_parent().add_child(a)
		$shoot_player.play()
		gap.start(0.05)
		yield(gap, "timeout")

func hurt(_area, damage):
	anim_fx.play("hit")
	health -= damage
	Gamestate.boss_health_change()
	if health <= 0:
		$defeated_player.play()
		fsm.state_next = fsm.states.dead
	else:
		$hit_player.play()

func disable_collider():
	$hurtbox/collider.disabled = true
	$rotator/hitbox_1/collider.disabled = true
	$rotator/hitbox_2/collider.disabled = true

func visual_effect_start():
	$visual_timer.start()

func visual_effect_end():
	$visual_timer.stop()

func _on_player_dead():
	player_dead = true

func _on_visual_timer_timeout():
	visual_gen.bang(sprite.frame, dir_cur, global_position)

func _on_animation_finished(anim_name):
	if anim_name == "attack1" or anim_name == "attack2":
		fsm.state_next = fsm.states.idle

func _on_hitbox1_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)

func _on_hitbox2_area_entered(area):
	area.emit_signal("hurt", self, DAMAGE)
