extends Control

export (bool) var is_active = false

onready var items = $margin1/panel/margin2/split/items.get_children()
onready var name_lb = $margin1/panel/margin2/split/description/name_lb
onready var des_lb = $margin1/panel/margin2/split/description/des_lb

onready var pause_menu = get_parent().get_node("pause_menu")

var item_cur = 0
var item_next = 0

func _ready():
	Game.item_menu = self
	if not is_active:
		self.deactivate()
	
	load_item()
	_initialize()

func _input(event):
	if event.is_action_pressed("up"):
		item_next += 6
		if item_next >= items.size():
			item_next -= items.size()
		update_items()
	if event.is_action_pressed("down"):
		item_next -= 6
		if item_next < 0:
			item_next += items.size()
		update_items()
	if event.is_action_pressed("left"):
		item_next -= 1
		if item_next < 0:
			item_next += items.size()
		update_items()
	if event.is_action_pressed("right"):
		item_next += 1
		if item_next >= items.size():
			item_next -= items.size()
		update_items()
	if event.is_action_pressed("quit"):
		$AudioStreamPlayer2.play()
		self.hide()
		self.deactivate()
		pause_menu.activate()

func update_items():
	$AudioStreamPlayer.play()
	if item_cur != item_next:
		items[item_cur].deselect()
		items[item_next].select()
		name_lb.text = items[item_next].get_name()
		des_lb.text = items[item_next].get_description()
		item_cur = item_next

func load_item():
	for i in Gamestate.state.items:
		items[i].unlock()
		items[i].effect()

func _initialize():
	for i in items:
		i.deselect()
	items[0].select()
	name_lb.text = items[0].get_name()
	des_lb.text = items[0].get_description()

func activate():
	item_cur = 0
	is_active = true
	set_physics_process(true)
	set_process_input(true)

func deactivate():
	is_active = false
	set_physics_process(false)
	set_process_input(false)


