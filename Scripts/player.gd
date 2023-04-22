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
	var bullet = bullet_scene.instantiate()
	
	bullet.rotation = rotation
	bullet.position = position
	bullet.set_linear_velocity(Vector2(bullet_speed,0.0).rotated(get_parent().rotation+rotation-1.570796))
	
	get_parent().add_child(bullet)
