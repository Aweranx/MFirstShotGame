extends Node2D

@export var slime_scene : PackedScene
@export var spawn_timer : Timer
@export var score : int = 0
@export var label_text : Label
@export var confirmation_dialog : ConfirmationDialog
@export var victory_score : int = 5
var is_victory : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		is_game_over(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_victory:
		if spawn_timer.wait_time > 1:
			spawn_timer.wait_time -= 0.2 * delta
		label_text.text = "Score : " + str(score)
		if score == victory_score:
			is_game_over(0)

func _spawn_slime() -> void:
	if not is_victory:
		var slime_node = slime_scene.instantiate()
		# x : 255  y : 39-107
		slime_node.position = Vector2(255, randf_range(39, 107))
		get_tree().current_scene.add_child(slime_node)
		slime_node.add_to_group("slimes")

func is_game_over (status : int) -> void:
	if status == 0:
		victory()
		confirmation_dialog.title = "Enter the next level"
	elif status == 1:
		confirmation_dialog.title = "Retry the level"
	elif status == 2:
		confirmation_dialog.title = "pause"
	show_game_over()
func show_game_over() -> void:
	confirmation_dialog.popup_centered()
	confirmation_dialog.confirmed.connect(_on_confirmation_dialog_confirmed) # ok and retry
	confirmation_dialog.canceled.connect(_on_confirmation_dialog_canceled) # cancel and quit

func _on_confirmation_dialog_confirmed():
	get_tree().reload_current_scene() # retry

func _on_confirmation_dialog_canceled():
	get_tree().quit() # quit
	
func victory() -> void:
	is_victory = true
	$player.victory()
	for slime in get_tree().get_nodes_in_group("slimes"): 
		if is_instance_valid(slime):
			slime.play_death()
