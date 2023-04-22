extends StaticBody2D

@export var movement_speed = 10

enum enemy_types {meteoroid,alien} 
var enemy_type: String

@export var shooting_speed : int = 60
var shooting_cooldown = 0;
var bullet:PackedScene = preload("res://Scenes/bullet.tscn")

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Set the ramdom enemy type
	enemy_type = enemy_types.keys()[randi() % enemy_types.size()]
	#Get the player instance
	player = get_node("../PlayerPivot/Player")
	#Play the animation based on enemy type
	$EnemyAnimation.play(str(enemy_type))
	#If enemy type is meteoriod give it linear
	if(enemy_type == "meteoroid"):
		look_at(player.global_position)
		#move_and_collide(movement_speed)

# Called every physics frame. 60 frames per second by default.
func _physics_process(delta):
	match enemy_type:
		enemy_types.alien:
			sentient_enemy(delta)
		

#Movement code for enemy targeting player
func sentient_enemy(delta):
	#Shoot at player if not cooldown
	if (shooting_cooldown >= shooting_speed):
		fire()
		shooting_cooldown = 0
	else:
		shooting_cooldown+=1
	
	#Look at player
	look_at(player.global_position)
	#Move towards player
	var velocity = global_position.direction_to(player.global_position)
	move_and_collide(velocity * movement_speed * delta)

#Create and give bullet movement
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.position = position
	bullet_instance.set_linear_velocity(Vector2(movement_speed*2,0.0).rotated(rotation))
	get_parent().add_child(bullet_instance)
	
	
