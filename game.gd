extends Node

func get_stage():
	return _get_stage_in(get_tree().get_root())

func _get_stage_in(node: Node):
	for child in node.get_children():
		if child.name == "Stage":
			return child
			
	for child in node.get_children():
		var stage = _get_stage_in(child)
		if stage: 
			return stage
	
	return null
