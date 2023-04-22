extends StaticBody2D

@export var movement_speed = 1
@export_enum("meteoroid","alien") var enemy_type: String

@export var shooting_speed = 60
var shooting_counter = 0;
var bullet = preload("res://Scenes/bullet.tscn")

var player : StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the player instance
	player = get_tree().get_root().get_node("res://Scenes/player.tscn")
	#Play the animation based on enemy type
	$EnemyAnimation.play(enemy_type)

# Called every physics frame. 60 frames per second by default.
func _physics_process(delta):
	#Shoot at player if not cooldown
	if (shooting_counter >= shooting_speed):
		fire()
		shooting_counter = 0
	else:
		shooting_counter+=1
	
	#Look at player
	look_at(player.global_position)
	#Move towards player
	var velocity = global_position.direction_to(player.global_position)
	move_and_collide(velocity * movement_speed * delta)
	
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.position = position
	bullet.set_linear_velocity(Vector2(movement_speed*0.1,0.0).rotated(rotation-1.570796))
	get_parent().add_child(bullet)
	
	
