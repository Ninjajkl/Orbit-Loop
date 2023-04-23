extends CharacterBody2D

@export var rotation_speed = 3
@export var bullet_speed = 3
@export var bullet_scene: PackedScene
@export var shooting_speed : float = 0.5
@export var health = 100
@export var shooting_angle : float = 0.5

var shooting_cooldown = 0;
var dead = false
var healthBar : TextureProgressBar

var PlayerAnim: AnimatedSprite2D
var prevAnim = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerAnim = get_node("PlayerAnim")
	PlayerAnim.set_animation("idle")
	healthBar = get_parent().get_parent().get_parent().get_node("GUI/TextureProgressBar")
	healthBar.set_max(health)
	healthBar.set_value(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		return
	var nextAnim = "idle"
	shooting_cooldown+=delta
	
	#Inputs
	if(Input.is_action_pressed("ui_right")):
		rotation += rotation_speed * delta
		nextAnim = "turnRight"
	elif(Input.is_action_pressed("ui_left")):
		rotation -= rotation_speed*1.5 * delta
		nextAnim = "turnLeft"
	if(Input.is_action_pressed("focus")):
		look_at(get_global_mouse_position())
		rotation += 1.57
		pass
	if(Input.is_action_pressed("fire")):
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
		
		bullet.position = position
		bullet.set_collision_layer(0)
		bullet.set_collision_mask(pow(2,2-1)+pow(2,3-1))
		if(i == 0):
			bullet.position.x+=10*sin(rotation-PI/2)
			bullet.position.y-=10*cos(rotation-PI/2)
			bullet.set_linear_velocity(Vector2(bullet_speed,0.0).rotated(global_rotation-PI/2+shooting_angle))
		else:
			bullet.position.x-=10*sin(rotation-PI/2)
			bullet.position.y+=10*cos(rotation-PI/2)
			bullet.set_linear_velocity(Vector2(bullet_speed,0.0).rotated(global_rotation-PI/2-shooting_angle))
		get_parent().add_child(bullet)
		get_node("shootNoise").play()

func gotHit(amount):
	if(!dead):
		health = max(0,health-amount)
		healthBar.set_value(health)
		get_node("hitNoise").play()
		if(health == 0):
			dead=true
			get_node("deathNoise").play()
			PlayerAnim.set_animation("destroyed")

func _on_death_noise_finished():
	get_tree().current_scene.gameover() 
