extends Node2D


# Called when the node enters the scene tree for the first time.

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/title.tscn")
