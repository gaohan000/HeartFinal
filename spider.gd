extends CharacterBody2D

#Variables needed for spider enemy 
var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var player

func _ready():
	player = get_node("../../player/Player")

func _physics_process(delta):
	# Add the gravity for spider.
	velocity.y += gravity * delta
	
	#Moves spider towards player if they are in the the area location
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "death":
		
		#Follows player sprite pased on its direction vector with a constant speed of 50
			get_node("AnimatedSprite2D").play("walk")
		var direction = player.position.x - self.position.x
		#velocity.x = -50
		
		#Switches spider image to follow the direction based on player
		#if player.position.x > self.position.x:
			#get_node("AnimatedSprite2D").flip_h = false
			#print("right")
			#velocity.x = 50
		#else: 
			#player.position.x < self.position.x
			#get_node("AnimatedSprite2D").flip_h = true
			#print("left") 
			#velocity.x = -50
			
		#if direction < -1217:
		if direction < -1065:
			get_node("AnimatedSprite2D").flip_h = true
			velocity.x = -50
			
			
		#elif direction > -950:
		elif direction >= -833:
			get_node("AnimatedSprite2D").flip_h = false
			velocity.x = 50
		else:
			pass

		print(direction)
	
		#Plays spider idle animation when player is out of area radius
	else:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0
	move_and_slide()
	
	#Plays chase function if Player is inside of Spider area radius
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		
		#Stops chase function when Player exits Spider area radius
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		body.health -= 3
		

func death():
	chase = false
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
		
