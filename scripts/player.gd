extends CharacterBody2D


var SPEED = 150.0
const JUMP_VELOCITY = -300.0
const wall_jump_pushback = 100

var jump_true = 0
var wall_true = 0
var ceiling_true = 0
var dash_true = 0
var dash_cooldown = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var jump_count = 0
var max_jumps = 2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_on_ceiling():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		jump_count = 0
		dash_cooldown = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps and jump_true == 0:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	elif Input.is_action_just_pressed("ui_accept") and jump_count == 0 and jump_true != 0:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	elif Input.is_action_just_pressed("ui_accept") and jump_count == max_jumps:
		if is_on_wall() and Input.is_action_pressed("ui_right") and wall_true == 0:
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback
		elif is_on_wall() and Input.is_action_pressed("ui_left") and wall_true == 0:
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
		elif is_on_ceiling() and Input.is_action_pressed("ui_up") and ceiling_true == 0:
			velocity.x = SPEED
			jump_count = 0
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("dash") and dash_true == 0 and dash_cooldown == 0:
		$dashtimer.start()
		SPEED *= 10
		velocity.x = direction * SPEED
		dash_cooldown += 1

	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.x >0:
			animated_sprite.flip_h = false
		elif velocity.x <0:
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
		

	move_and_slide()


func _on_dashtimer_timeout() -> void:
	SPEED = 150


func _on_dash_button_pressed() -> void:
	dash_true+=1


func _on_double_jump_button_pressed() -> void:
	jump_true += 1


func _on_wall_climb_button_pressed() -> void:
	wall_true += 1


func _on_ceiling_button_pressed() -> void:
	ceiling_true += 1
