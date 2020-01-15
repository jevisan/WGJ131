extends KinematicBody2D

const UP = Vector2(0, -1)
export var GRAVITY = 8
export var SPEED = 200
export var DASHSPEED = 700

# JUMP mechanic
# source: https://godotengine.org/qa/26160/jump-godot-holding-button-higher-jump-tapping-100%25-same-height
export var fallMultiplier = 2
export var lowJumpMultiplier = 20
export var jumpVelocity = 700

var motion = Vector2()

var current_power = null
var current_speed = SPEED

func _physics_process(delta):
	motion.y += GRAVITY
	if motion.y > 0: # player is falling
		motion += UP * (-9.81) * (fallMultiplier) # Falling action is faster than jumping | Mario-like
	elif motion.y < 0 && Input.is_action_just_released("ui_up"): # Player is jumping
		motion += UP * (-9.81) * (lowJumpMultiplier) # Jump height depends on how long you hold the key
	call_deferred("process_input")
	motion = move_and_slide(motion, UP)

func process_input():
	if not Input.is_action_pressed("ui_select"):
		if Input.is_action_pressed("ui_right"):
			motion.x = current_speed
		elif Input.is_action_pressed("ui_left"):
			motion.x = -current_speed
		else:
			motion.x = 0
			
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion = UP * jumpVelocity # Normal jump action
	
		if $CooldownTimer.is_stopped():
			if Input.is_action_just_pressed("Dash") && $DashTimer.is_stopped():
				current_speed = DASHSPEED
				$DashTimer.start()

func _on_MaskMenu_mask_selected(mask):
	current_power = mask
	print("obtained power", mask)


func _on_DashTimer_timeout():
	current_speed = SPEED
	$CooldownTimer.start()
