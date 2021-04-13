extends Node2D

const IDLE_DURATION = 1.0

onready var Platform = $KinematicBody2D
onready var tween = $Tween

var follow = Vector2.ZERO

export var move_to = Vector2.UP * 400
export var speed = 3.0

func _ready():
	
	_init_tween()
	
func _init_tween():
	
	var duration = move_to.length()/ float(speed * 192)
	tween.interpolate_property(self, 'follow', Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, 'follow', move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration+IDLE_DURATION*2)
	tween.start()

func _physics_process(delta):
	
	Platform.position = Platform.position.linear_interpolate(follow, 0.075)
	
