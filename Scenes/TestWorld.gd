extends Node

func _on_Player_respawning():
	print("Respawning player")
	var player = load("res://Scenes/Player.tscn").instance()
	call_deferred("add_child", player)