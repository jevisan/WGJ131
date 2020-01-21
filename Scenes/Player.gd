extends KinematicBody2D

signal respawning
signal health_updated(health)
signal killed()


const UP = Vector2(0, -1)
export var GRAVITY = 8
export var SPEED = 200
export var DASHSPEED = 700

export var max_health = 1
onready var health = max_health setget _set_health

# JUMP mechanic
# source: https://godotengine.org/qa/26160/jump-godot-holding-button-higher-jump-tapping-100%25-same-height
export var fallMultiplier = 2
export var lowJumpMultiplier = 20
export var jumpVelocity = 700

var motion = Vector2()
var move_direction = null
var looking_direction = null

var current_power = null
var current_speed = SPEED

func _ready():
	position = get_node("../Respawn").position
	current_speed = SPEED
	connect("killed", get_parent(), "_on_Player_killed")

func _handle_input():
	if not Input.is_action_pressed("ui_select"):
		move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))

		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion = UP * jumpVelocity # Normal jump action
	
		if $CooldownTimer.is_stopped():
			if Input.is_action_just_pressed("Dash") && $DashTimer.is_stopped():
				current_speed = DASHSPEED
				$DashTimer.start()

func _apply_gravity():
	motion.y += GRAVITY

func _apply_movement():
	motion.x = move_direction * current_speed
	if motion.y > 0: # player is falling
		motion += UP * (-9.81) * (fallMultiplier) # Falling action is faster than jumping | Mario-like
	elif motion.y < 0 && Input.is_action_just_released("ui_up"): # Player is jumping
		motion += UP * (-9.81) * (lowJumpMultiplier) # Jump height depends on how long you hold the key
	motion = move_and_slide(motion, UP)

func _on_MaskMenu_mask_selected(mask):
	match mask:
		"shield": current_power = "3"
		"dash": current_power = "1"
		"attack": current_power = "4"
	print("Selected power", mask)
	var img = Image.new()
	var itex = ImageTexture.new()
	img.load("res://assets/sprites/Player64x64-"+current_power+".png")
	itex.create_from_image(img)
	$Mask.texture = itex


func _on_DashTimer_timeout():
	current_speed = SPEED
	$CooldownTimer.start()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()

func _check_collisions():
	if get_slide_count() > 0:
			for i in range(get_slide_count()):
				var collision = get_slide_collision(i).collider.get_name()
				match collision:
					"Traps":
						damage(1)

func damage(amount):
	_set_health(health - amount)

func kill():
	emit_signal("killed")
	$KilledTimer.start()

func _on_KilledTimer_timeout():
	queue_free()