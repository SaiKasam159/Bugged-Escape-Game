extends KinematicBody2D

func _on_Area2D_body_entered(body):
	
	if body.get('TYPE') == 'player':
		body.damage(10)
	#pass # Replace with function body.
