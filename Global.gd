extends Node

var node_creation_parent = null
var player = null
var score = 0

var highscore = 0

var camera = null

func _process(delta):
	
	if score >= highscore:
		highscore = score
	


func instance_node(node, location, parent):
	
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location 
	return node_instance
