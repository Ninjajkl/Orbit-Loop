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
	if(randi_range(0,2) > 0):
		enemy_type = "meteoroid"
		movement_speed = 9
	else:
		enemy_type = "alien"
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
			move_and_collide(transform.x * movement_speed * delta)
			#position += transform.x * movement_speed * delta

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
	bullet_instance.get_node("Sprite2D").set_modulate(Color(0,1,0,1))
	bullet_instance.set_collision_mask(pow(2,2-1)+pow(2,1-1))
	bullet_instance.position.x-=20*sin(rotation-PI/2)
	bullet_instance.position.y+=20*cos(rotation-PI/2)
	bullet_instance.set_linear_velocity(Vector2(movement_speed*6,0.0).rotated(rotation))
	get_parent().add_child(bullet_instance)
	get_node("shootPlayer").play()
	
func died():
	
	if(!get_node("deathPlayer").is_playing()):
		set_collision_layer(0)
		set_collision_mask(0)
		shooting_cooldown = -100
		match enemy_type:
			"alien":
				get_node("deathPlayer").set_stream(load("res://Sound/SoundEffects/enemyboom.ogg"))
				randomize()
				if(randi()%50==10):
					get_node("EnemyAnimation").set_animation("joeyDied")
				else:
					get_node("EnemyAnimation").set_animation("alienDied")
				
			"meteoroid":
				get_node("deathPlayer").set_stream(load("res://Sound/SoundEffects/meteoroidboom.ogg"))
				get_node("EnemyAnimation").set_animation("meteroroidDied")
		get_node("deathPlayer").play()

func _on_visible_on_screen_notifier_2d_screen_exited():
	get_parent().get_parent().enemy_killed(0)
	queue_free()

func _on_death_player_finished():
	queue_free()

func _on_body_entered(body):
	if (body.is_in_group("Player")):
		body.gotHit(5)
		get_tree().get_root().get_node("Space").enemy_killed(1)
		died()
		
