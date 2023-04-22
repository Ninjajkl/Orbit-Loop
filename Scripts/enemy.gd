extends RigidBody2D

@export var movement_speed = 10

enum enemy_types {meteoroid,alien} 
var enemy_type: String

@export var shooting_speed : int = 60
var shooting_cooldown = 0;
var bullet:PackedScene = preload("res://Scenes/bullet.tscn")

var player : CharacterBody2D

signal enemy_dead
# Called when the node enters the scene tree for the first time.
func _ready():
	#Set the ramdom enemy type
	enemy_type = enemy_types.keys()[randi() % enemy_types.size()]
	#Get the player instance
	player = get_node("../../NotBackground/PlayerPivot/Player")
	#Play the animation based on enemy type
	$EnemyAnimation.play(enemy_type)
	#Start facing the enemy (only really for non sentient enemies)
	look_at(player.global_position)	

# Called every physics frame. 60 frames per second by default.
func _physics_process(delta):
	match enemy_type:
		"alien":
			sentient_enemy(delta)
		"meteoroid":
			position += transform.x * movement_speed * delta

#Movement code for enemy targeting player
func sentient_enemy(delta):
	#Shoot at player if not cooldown
	if (shooting_cooldown >= shooting_speed):
		fire()
		shooting_cooldown = 0
	else:
		shooting_cooldown+=1
	var velocity = global_position.direction_to(player.global_position)
	#Look at player
	look_at(player.global_position)
	#Move
	move_and_collide(velocity * movement_speed * delta)

#Create and give bullet movement
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.position = position
	bullet_instance.position.x-=20*sin(rotation-PI/2)
	bullet_instance.position.y+=20*cos(rotation-PI/2)
	bullet_instance.set_linear_velocity(Vector2(movement_speed*6,0.0).rotated(rotation))
	get_parent().add_child(bullet_instance)
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	get_parent().get_parent().enemy_killed(0)
	queue_free()
