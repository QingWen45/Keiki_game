extends FSM_state

var idle_timer

func initialize():
	idle_timer = obj.DECISION_TIMER
	obj.velo = Vector2.ZERO
	obj.anim_next = "idle"

func run(delta):
	if obj.player_dead: return
	if obj.health <= obj.MAX_HEALTH / 2 and not obj.has_summoned:
		obj.has_summoned = true
		fsm.state_next = fsm.states.summon
		return
	if idle_timer > 0:
		idle_timer -= delta
	else:
		idle_timer = obj.DECISION_TIMER
		make_decision()

#----------------------------
# the boss's next decision is based upon various data
#----------------------------
func make_decision():
	var player_pos = obj.get_player_pos()
	var decision_factor = randi() % 10
	if obj.health > obj.MAX_HEALTH / 2:
		if decision_factor <= 6 or abs(player_pos.x) > 300:
			fsm.state_next = fsm.states.chase
		else:
			fsm.state_next = fsm.states.attack2
	else:
		if decision_factor <= 4 or abs(player_pos.x) > 300:
			fsm.state_next = fsm.states.chase
		else:
			fsm.state_next = fsm.states.attack2

	
