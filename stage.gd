class_name Stage
extends Node2D

var spawn_points: Array[Node2D]

const Rivet: PackedScene = preload("res://Scenes/Rivet/rivet.tscn")

@onready var actors: Node2D = $"Actors"

func _register_spawn_point(flag: Node2D):
	spawn_points.append(flag)
	
func _ready():
	spawn_rivet()
	
func spawn_rivet():
	var where: Vector2 = Vector2.ZERO
	if len(spawn_points):
		var which = randi_range(0, len(spawn_points) - 1)
		where = spawn_points[which].global_position
		
	var rivet = Rivet.instantiate()
	rivet.global_position = where
	actors.add_child(rivet)
