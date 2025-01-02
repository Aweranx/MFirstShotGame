extends CharacterBody2D

@export var move_speed : float = 50
@export var animator : AnimatedSprite2D
var is_game_over : bool = false
@export var bullet_scene : PackedScene

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$RunningSound.stop()
	elif not $RunningSound.playing:
		$RunningSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_game_over:
		velocity = Input.get_vector("left","right","up","down") * move_speed
		
		# Play animations based on the status
		if velocity == Vector2.ZERO:
			animator.play("idle")
		else:
			animator.play("run")
		
		move_and_slide()

func defeat() -> void:
	is_game_over = true
	animator.play("game_over")
	$GameOverSound.play()
	await get_tree().create_timer(2).timeout
	# the player dead
	get_tree().current_scene.is_game_over(1)

func victory() -> void:
	is_game_over = true
	animator.play("game_over")
	await get_tree().create_timer(2).timeout

func _on_fire() -> void:
	if is_game_over:
		return
	var bullet_node = bullet_scene.instantiate()
	$FireSound.play()
	bullet_node.position = position + Vector2(6,6)
	get_tree().current_scene.add_child(bullet_node)
