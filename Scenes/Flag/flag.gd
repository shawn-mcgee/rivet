@tool
class_name rFlag
extends Area2D

enum Kind {
	SPAWN_POINT,
	CHECK_POINT
}

var _kind: Kind = Kind.CHECK_POINT
@export var kind: Kind:
	get=_get_kind,
	set=_set_kind
	
@onready var stage: Node2D = get_stage()
@onready var sprite: Sprite2D = $Sprite2D

func get_stage():
	return _parent_stage(get_parent())
	
func _parent_stage(of: Node):
	if of.name == "Stage":
		return of
	return _parent_stage(of.get_parent())

func is_spawn_point() -> bool:
	return _kind == Kind.SPAWN_POINT
	
func is_check_point() -> bool:
	return _kind == Kind.CHECK_POINT
	
func _get_kind() -> Kind:
	return _kind
	
func _set_kind(which: Kind):
	_kind = which
	_update_sprite()
			
func _update_sprite():
	if sprite:
		if is_spawn_point():
			sprite.frame = 0
		else:
			sprite.frame = 4

func _ready() -> void:
	_update_sprite()
	if is_spawn_point():
		stage._register_spawn_point(self)
