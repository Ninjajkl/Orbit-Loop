extends Node

var score = 0

#How many ticks it should take to spawn next enemy (at 60 tps)
var spawn_speed : int = 10
var spawn_cooldown = 1

var enemy = preload("res://Scenes/enemy.tscn")
@export var max_enemy : int = 20
var current_enemy_count : int = 0
var spawn_location

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_location = get_node("SpawnPath/MovingSpawnLocation")	


# Called every physics frame.
func _physics_process(_delta):
	if (current_enemy_count < max_enemy && spawn_cooldown >= spawn_speed):
		spawn_enemy()
		spawn_cooldown = 1
	else:
		spawn_cooldown += 1
	
#Spawn enemy
func spawn_enemy():
	var enemy_instance = enemy.instantiate()
	spawn_location.progress_ratio = randf()
	enemy_instance.position = spawn_location.position
	add_child(enemy_instance)
	current_enemy_count += 1

#Method that should be called when enemy is killed
func enemy_killed(score_increase : int):
	current_enemy_count -= 1
	score += score_increase
	#TODO increase difficulty here
