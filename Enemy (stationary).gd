extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20

var speed = 100
var motion = Vector2()
var facing_right = true
var turn_left = false


func _physics_process(delta):
	motion.y += GRAVITY
	
	motion.y = move_and_slide(motion, UP).y

func _on_Area2D_area_entered(area):
	
	if area.is_in_group('Bullet'):
		area.get_parent().queue_free()
		queue_free()
	
	
	#pass # Replace with function body.
