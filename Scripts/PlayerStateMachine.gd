extends StateMachine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("dash")
	add_state("die")
	add_state("respawn")
	call_deferred("set_state", states.respawn)

func _state_logic(delta):
	if state != states.die and state != states.respawn:
		parent._handle_input()
		parent._apply_gravity(delta)
		parent._apply_movement()
		parent._check_collisions()
		
		if parent.move_direction < 0:
			parent.looking_direction = "left"
			parent.get_node("AnimatedSprite").flip_h = true
			parent.get_node("Mask").flip_h = true
		elif parent.move_direction > 0:
			parent.looking_direction = "right"
			parent.get_node("AnimatedSprite").flip_h = false
			parent.get_node("Mask").flip_h = false

func _get_transition(delta):
	match state:
		states.idle:
			if not parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				elif parent.motion.y > 0:
					return states.fall
			elif parent.motion.x != 0:
				return states.run
		states.run:
			if not parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				elif parent.motion.y > 0:
					return states.fall
			elif parent.motion.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.motion.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.motion.y < 0:
				return states.jump
		states.respawn:
			if parent.get_node("AnimatedSprite").animation == "Respawn" and parent.get_node("AnimatedSprite").frame == 3:
				return states.idle
	if parent.health == 0:
		return states.die
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.get_node("AnimatedSprite").play("Idle")
		states.die:
			parent.get_node("AnimatedSprite").play("Death")
		states.respawn:
			parent.get_node("AnimatedSprite").play("Respawn")
			yield(parent.get_node("AnimatedSprite"), "animation_finished")

func _exit_state(old_state, new_state):
	pass