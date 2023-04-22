extends AnimatedSprite2D

var last_score : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if(last_score > 0):
		$GameOverLabel.visible = true
		$LastScoreLabel.text = "[center]Last Score : " + str(last_score) + "[/center]"
		$LastScoreLabel.visible = true
	$StartButton.button_pressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/space.tscn")
	self.queue_free()


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
	
func _game_restarted(score:int):
	last_score = score
