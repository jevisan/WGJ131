extends RigidBody2D
class_name PickableMask

var picked = false

signal picked(name)

func _process(delta):
	var bodies = $Area2D.get_overlapping_bodies()
	for b in bodies:
		if b.name == "Player":
			picked = true
			print("player picks ", name)
			emit_signal("picked", name)
			queue_free()