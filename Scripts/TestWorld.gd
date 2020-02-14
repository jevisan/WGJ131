extends Node

func _on_Player_killed():
	$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	var player = load("res://Scenes/Player.tscn").instance()
	call_deferred("add_child", player)