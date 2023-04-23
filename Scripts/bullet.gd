extends RigidBody2D

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if (body.is_in_group("Enemy")):
		get_tree().get_root().get_node("Space").enemy_killed(1)
		body.died()
		queue_free()
	elif (body.is_in_group("Player")):
		body.gotHit()
		queue_free()
	elif (body.is_in_group("Bullet")):
		body.queue_free()
