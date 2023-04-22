extends CharacterBody2D

@export var rotation_speed = 3
@export var bullet_speed = 3
@export var bullet_scene: PackedScene
@export var shooting_speed : float = 0.5
var shooting_cooldown = 0;

var PlayerAnim: AnimatedSprite2D
var prevAnim = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerAnim = get_node("PlayerAnim")
	PlayerAnim.set_animation("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nextAnim = "idle"
	shooting_cooldown+=delta
	
	#Inputs
	if(Input.is_action_pressed("ui_right")):
		rotation += rotation_speed * delta
		nextAnim = "turnRight"
	elif(Input.is_action_pressed("ui_left")):
		rotation -= rotation_speed*1.5 * delta
		nextAnim = "turnLeft"
	if(Input.is_action_pressed("ui_space")):
		match nextAnim:
			"turnRight":
				nextAnim = "turnShootRight"
			"turnLeft":
				nextAnim = "turnShootLeft"
			_:
				nextAnim = "shoot"
		if (shooting_cooldown >= shooting_speed):
			shoot()
			shooting_cooldown = 0
	#Anim
	if(prevAnim!=nextAnim):
		PlayerAnim.set_animation(nextAnim)
		prevAnim=nextAnim

func shoot():
	for i in range(0,2):
		var bullet = bullet_scene.instantiate()
		
		bullet.rotation = rotation
		bullet.position = position
		if(i == 0):
			bullet.position.x+=10*sin(rotation-PI/2)
			bullet.position.y-=10*cos(rotation-PI/2)
		else:
			bullet.position.x-=10*sin(rotation-PI/2)
			bullet.position.y+=10*cos(rotation-PI/2)
		bullet.set_linear_velocity(Vector2(bullet_speed,0.0).rotated(global_rotation-PI/2))
		get_parent().add_child(bullet)
