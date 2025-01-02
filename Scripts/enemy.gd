extends Area2D

@export var slime_speed : float = -50
var is_dead : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_dead:
		position += Vector2(slime_speed, 0) * delta
	if position.x < -230:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_dead:
		body.defeat()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		$AnimatedSprite2D.play("death")
		is_dead = true
		get_tree().current_scene.score += 1
		# delete the slime & bullet node
		area.queue_free()
		$DeathSound.play()
		await get_tree().create_timer(0.6).timeout
		queue_free()
func play_death() -> void:
	$AnimatedSprite2D.play("death")
	is_dead = true
	$DeathSound.play()
	await get_tree().create_timer(0.6).timeout
	queue_free()
