extends Area2D

export (int) var item_no

onready var collider = $CollisionShape2D

func _ready():
	if Gamestate.state.items.has(item_no):
		self.deactivate()
		return
	$Sprite.texture = Game.item_menu.items[item_no].get_node("item_image").texture
	$AnimationPlayer.play("default")

func deactivate():
	self.hide()
	collider.disabled = true
	$AnimationPlayer.stop()

func _on_item_body_entered(_body):
	call_deferred("deactivate")
	$AudioStreamPlayer.play()
	Game.main.get_node("hud_layer").show_text("New item get.")

	Gamestate.state.items.append(item_no)
	Gamestate.state.current_pos = "item"
	Game.item_menu.load_item()
