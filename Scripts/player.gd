extends CharacterBody2D

@export var rotation_speed = 3
@export var bullet_speed = 3
@export var bullet_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("ui_right")):
		rotation += rotation_speed * delta
	elif(Input.is_action_pressed("ui_left")):
		rotation -= rotation_speed*1.5 * delta
	if(Input.is_action_just_pressed("ui_space")):
		shoot()

func shoot():
	for i in range(0,2):
		var bullet = bullet_scene.instantiate()
		
		bullet.rotation = rotation
		bullet.position = position
		if(i == 0):
			bullet.position.x+=8*sin(rotation-PI/2)
			bullet.position.y-=8*cos(rotation-PI/2)
		else:
			bullet.position.x-=8*sin(rotation-PI/2)
			bullet.position.y+=8*cos(rotation-PI/2)
		bullet.set_linear_velocity(Vector2(bullet_speed,0.0).rotated(global_rotation-PI/2))
		print(sin(rotation-PI/2))
		get_parent().add_child(bullet)
