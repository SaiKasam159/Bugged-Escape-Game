extends KinematicBody2D

signal health_updated(health)
signal killed()

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAXFALLSPEED = 500
const MAXSPEED = 500
const JUMPFORCE = 1000
const ACCEL = 50
const CHAIN_PULL = 105
const TYPE = 'player'

export var max_health = 100

onready var current_sprite = get_node("idle")
onready var health = max_health setget _set_health
onready var invulnerability_timer = $"Invulnerability Timer"

var old_sprite = 0
var facing_right = true
var isJumping = false
var isShooting = false
var isRunning = false
var isDead = false
var takingDamage = false
var can_shoot = true
var motion = Vector2()
var bullet = preload("res://Bullet.tscn")

var chain_velocity := Vector2(0,0)

func _physics_process(delta):
	
	#print(isRunning)
	motion.y += GRAVITY
	
	if !isDead:
		motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
		
		if(facing_right==true):
			current_sprite.scale.x = 0.2
		else:
			current_sprite.scale.x = -0.2
		
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED
		
		if(Input.is_action_pressed("right")):
			isRunning = true
			#print(isRunning)
			motion.x += ACCEL
			facing_right = true
			#print(facing_right)
			if !isJumping:
				old_sprite = current_sprite
				old_sprite.visible = false
				current_sprite = get_node("run")
				current_sprite.visible = true
				$AnimationPlayer.play("run")
		
		elif(Input.is_action_pressed("left")):
			isRunning = true
			motion.x -= ACCEL
			facing_right = false
			#print(facing_right)
			if !isJumping:
				old_sprite = current_sprite
				old_sprite.visible = false
				current_sprite = get_node("run")
				current_sprite.visible = true
				$AnimationPlayer.play("run")
		
		else: 
			isRunning = false
		
		
		if isJumping == false and isShooting == false and isRunning == false:
			motion.x = lerp(motion.x, 0, 0.2)
			#print(motion.x)
			old_sprite = current_sprite
			old_sprite.visible = false
			current_sprite = get_node("idle")
			current_sprite.visible = true
			$AnimationPlayer.play("idle")

		if(Input.is_action_pressed("jump") && !isDead):
			if is_on_floor():
				motion.y = -JUMPFORCE

		if !is_on_floor():
			if motion.y < 0:
				isJumping = true
				isRunning = false
				old_sprite = current_sprite
				old_sprite.visible = false
				current_sprite = get_node("jump")
				current_sprite.visible = true
				#print(motion.y)
				$AnimationPlayer.play("jump")
		else:
			isJumping = false
			
		
		if(Input.is_action_pressed("fire") and can_shoot and isJumping == false):
			fire()
			can_shoot = false
		
		
	motion = move_and_slide(motion, UP)

func fire():
	
	isShooting = true
	old_sprite = current_sprite
	old_sprite.visible = false
	current_sprite = get_node("gun")
	current_sprite.visible = true
	$AnimationPlayer.play("shoot")
	$Timer.start()
	$Bullet_timer.start()
	var bullet_instance = Global.instance_node(bullet, global_position, get_parent())
	
	#bullet_instance.velocity.y = motion.y
	if(!facing_right):
		bullet_instance.velocity = -bullet_instance.velocity
	else:
		bullet_instance.velocity = bullet_instance.velocity


func _on_Timer_timeout():

	isShooting = false
	
func _on_Bullet_timer_timeout():

	can_shoot = true

func damage(amount):
	old_sprite = current_sprite
	old_sprite.visible = false
	current_sprite = get_node("damage")
	current_sprite.visible = true
	$AnimationPlayer.play("damage")
	takingDamage = true
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)

func kill():
	old_sprite = current_sprite
	old_sprite.visible = false
	current_sprite = get_node("die")
	current_sprite.visible = true
	$AnimationPlayer.play("die")
	isDead = true
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal('killed')

func _on_Area2D_area_entered(area):
	if area.is_in_group('Enemy'):
		damage(20)
	
func _on_Invulnerability_Timer_timeout():
	takingDamage = false
	#pass # Replace with function body.
