extends Node2D

@export var pipe_scene: PackedScene
@export var score_zone_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_x: float = 400 # Hors écran à droite
@export var gap_center_y: float = 300 # Centre de l'écart entre les pipes
@export var gap_variation: float = 150 # Variation aléatoire du centre
@export var gap_size: float = 150 # Taille de l'écart entre les pipes
@export var pipe_speed: float = 150

var timer: Timer
var pipes_container: Node2D

func _ready() -> void:
	# Container pour les pipes
	pipes_container = Node2D.new()
	add_child(pipes_container)
	
	# Timer de spawn
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(_spawn_pipe)
	timer.start()
	
	_spawn_pipe()

func _spawn_pipe() -> void:
	if pipe_scene == null:
		print_debug("⚠️ Pipe scene non assignée!")
		return
	
	# Position Y aléatoire du centre de l'écart
	var center_y = gap_center_y + randf_range(-gap_variation, gap_variation)
	
	# Instancier les pipes
	var pipe_pair = pipe_scene.instantiate()
	pipes_container.add_child(pipe_pair)
	pipe_pair.position = Vector2(spawn_x, center_y)
	
	# Ajouter la zone de score entre les pipes
	if score_zone_scene != null:
		var score_zone = score_zone_scene.instantiate()
		pipe_pair.add_child(score_zone)
		score_zone.position = Vector2.ZERO # Centre entre les pipes
		
		# Étirer la zone de score si elle a une CollisionShape2D
		var collision = score_zone.get_node_or_null("CollisionShape2D")
		if collision and collision.shape is RectangleShape2D:
			collision.shape.size.y = gap_size

func _process(delta: float) -> void:
	# Faire défiler tous les pipes vers la gauche
	for pipe_pair in pipes_container.get_children():
		pipe_pair.position.x -= pipe_speed * delta
		
		# Supprimer si hors écran
		if pipe_pair.position.x < -100:
			pipe_pair.queue_free()

func stop_spawning() -> void:
	timer.stop()
	# Arrêter aussi le mouvement
	set_process(false)

func start_spawning() -> void:
	timer.start()
	set_process(true)
