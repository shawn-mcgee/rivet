class_name Stage
extends Node2D

@export_group("Background")
@export var background_scroll_scale: Vector2 = Vector2(0.35, 0.35)
@export var background_size: Vector2i = Vector2i(32, 32)
@export var background_source_id: int = 2
## Zero generates a new pattern each run; any other value repeats that pattern.
@export var background_seed: int = 0

var spawn_points: Array[Node2D]

const Rivet: PackedScene = preload("res://Scenes/Rivet/rivet.tscn")

@onready var actors: Node2D = $"Actors"
@onready var background_parallax: Parallax2D = $Background
@onready var background_tiles: TileMapLayer = $Background/Tiles

func _register_spawn_point(flag: Node2D):
	spawn_points.append(flag)
	
func _ready():
	generate_background()
	spawn_rivet()

func generate_background() -> void:
	var tiles: TileSet = background_tiles.tile_set
	if tiles == null or not tiles.has_source(background_source_id):
		push_warning("Stage background needs a valid tile atlas source.")
		return
	var atlas := tiles.get_source(background_source_id) as TileSetAtlasSource
	if atlas == null or atlas.get_tiles_count() == 0:
		push_warning("Stage background atlas has no tiles.")
		return

	var rng := RandomNumberGenerator.new()
	if background_seed == 0:
		rng.randomize()
	else:
		rng.seed = background_seed

	var size := Vector2i(maxi(background_size.x, 1), maxi(background_size.y, 1))
	background_tiles.clear()
	background_tiles.collision_enabled = false
	background_tiles.navigation_enabled = false
	for y in range(size.y):
		for x in range(size.x):
			var tile_index := rng.randi_range(0, atlas.get_tiles_count() - 1)
			background_tiles.set_cell(Vector2i(x, y), background_source_id, atlas.get_tile_id(tile_index))

	background_parallax.scroll_scale = background_scroll_scale
	background_parallax.repeat_size = Vector2(size * tiles.tile_size)
	_update_background_repeats()

func _process(_delta: float) -> void:
	_update_background_repeats()

func _update_background_repeats() -> void:
	if background_parallax.repeat_size.x <= 0 or background_parallax.repeat_size.y <= 0:
		return
	var view_size := get_viewport_rect().size
	var camera := get_viewport().get_camera_2d()
	if camera != null:
		view_size /= camera.zoom
	# Extra copies cover both edges, including when the camera zooms out.
	var copies := view_size / background_parallax.repeat_size
	var repeats := ceili(maxf(copies.x, copies.y)) + 2
	if background_parallax.repeat_times != repeats:
		background_parallax.repeat_times = repeats
	
func spawn_rivet():
	var where: Vector2 = Vector2.ZERO
	if len(spawn_points):
		var which = randi_range(0, len(spawn_points) - 1)
		where = spawn_points[which].global_position
		
	var rivet = Rivet.instantiate()
	rivet.global_position = where
	actors.add_child(rivet)
