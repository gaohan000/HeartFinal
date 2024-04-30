extends CharacterBody2D

# Variable constants for the speed and jump of the player character
var health = 10
const SPEED = 300.0
const JUMP_VELOCITY = -650.0
var can_control = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

# Keeps player on floor of the game
func _physics_process(delta):
	
	if !(can_control):
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#leaves level when user presses escape
	if Input.is_action_just_pressed("ui_cancel"):
		cont_play("dissolve")
	
	# Plays the attack animation when user presses the spacebar
	if Input.is_action_just_pressed("ui_accept"):
		anim.play("fight")
		
	# Plays jump animation and changes player velocity to be above the ground
	# Checks to make sure the fight animation is not being played to allow for jump animation
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		if (anim.current_animation != "fight") && (anim.current_animation != "death") && (anim.current_animation != "dissolve"):
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			




	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Changes players image to align with the corresponding directions
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
		
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
		# Moves player in direction based on arrow keys 
		# Checks to make sure the fight animation is not being played to allow for idle animation
	if direction:
		velocity.x = direction * SPEED

		if velocity.y == 0:
			if (anim.current_animation != "fight") && (anim.current_animation != "death")&& (anim.current_animation != "dissolve"):
				anim.play("run")
		
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
# When player is not being moved idle animation is played
		if velocity.y == 0:
			if (anim.current_animation != "fight") && (anim.current_animation != "death") && (anim.current_animation != "dissolve"):
				anim.play("idle")
	move_and_slide()
	
	if health <= 0:
		cont_play("death")


func cont_play(anim_name):
	can_control = false
	anim.play(anim_name)
	await anim.animation_finished
	self.queue_free()
	get_tree().change_scene_to_file("res://world_select.tscn")

#func _on_animated_sprite_2d_animation_finished(anim_name):
#	if anim_name == "fight":
#		queue_free()
#		get_tree().change_scene_to_file("res://world_select.tscn")
