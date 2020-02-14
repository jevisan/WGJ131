extends KinematicBody2D

signal respawning
signal health_updated(health)
signal killed()


const UP = Vector2(0, -1)
export var GRAVITY = 1200
export var SPEED = 10 * Globals.UNIT_SIZE
export var DASHSPEED = 200

export var JUMP_SPEED = -550

export var max_health = 1
onready var health = max_health setget _set_health

var motion = Vector2()
var move_direction = null
var looking_direction = null

var current_power = null
var current_speed = SPEED

func _ready():
	position = get_node("../Respawn").position if get_node("../Respawn") else Vector2(400, 400)
	current_speed = SPEED
	connect("killed", get_parent(), "_on_Player_killed")
	set_process_input(true)

func _handle_input():
	if not Input.is_action_pressed("ui_select"):
		move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))

		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_SPEED
	
		if $CooldownTimer.is_stopped():
			if Input.is_action_just_pressed("Dash") && $DashTimer.is_stopped():
				current_speed = DASHSPEED
				$DashTimer.start()

func _apply_gravity(delta):
	motion.y += GRAVITY * delta

func _input(event):
	if event.is_action_released("ui_up") && motion.y < 0:
		motion.y = 0

func _apply_movement():
	motion.x = move_direction * current_speed
	motion = move_and_slide(motion, UP)

func _on_MaskMenu_mask_selected(mask):
	match mask:
		"shield": current_power = "3"
		"dash": current_power = "1"
		"attack": current_power = "4"
	print("Selected power ", mask)
	$Mask.texture = load("res://assets/sprites/Player64x64-"+current_power+".png")


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
	
func attack():
	var attack_box = $AnimatedSprite.AttackShape.CollisionShape2D
	var animated_sprite = $AnimatedSprite
	if animated_sprite.animation == "Attack" and (animated_sprite.frame == 1 or animated_sprite.frame == 2):
		attack_box.disabled = false
	else: attack_box.disabled = true
	if looking_direction == "left":
		attack_box.position = global_position - Vector2(12, 0)
	elif looking_direction == "right":
		attack_box.position = global_position + Vector2(12, 0)