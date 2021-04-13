extends Sprite

var velocity = Vector2(5, 0)
var speed = 250

func _process(delta):
	
	global_position += velocity.rotated(rotation)*speed*delta
	

	pass # Replace with function body.
