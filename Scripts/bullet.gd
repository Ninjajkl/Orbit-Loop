extends RigidBody2D

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	print(body.name)
	body.queue_free()
	queue_free()
