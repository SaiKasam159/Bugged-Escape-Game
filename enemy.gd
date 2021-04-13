extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20

var speed = 100
var motion = Vector2()
var facing_right = true
var turn_left = false

var is_dead = false
var second_shot = false
var count = 0

var direction = 1

func dead():
	is_dead = true
	$AnimationPlayer.play("dead")
	motion = Vector2(0, 0)


func _physics_process(delta):
	motion.y += GRAVITY
	
	if direction == 1:
		$Sprite.flip_h = false
	else: 
		$Sprite.flip_h = true

	motion = move_and_slide(motion, UP)
	if is_dead == false:
		motion.x = speed * direction
		$AnimationPlayer.play('run')
		if is_on_wall():
			direction = direction * -1
			$RayCast2D.position.x *= -1
			yield(get_tree().create_timer(1), "timeout")
			print('is_on_wall')
			
		if $RayCast2D.is_colliding() == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1
			print('is on ledge')
			
	if is_dead == true && count == 2:
		second_shot = true
	
	if second_shot == true:
		queue_free()

func _on_Area2D_area_entered(area):
	
	if area.is_in_group('Bullet'):
		area.get_parent().queue_free()
		dead()
		count += 1
		#queue_free()
	
