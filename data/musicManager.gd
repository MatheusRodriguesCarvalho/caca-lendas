extends Node

var player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var sons_clique: Array[AudioStream] = [
	preload("res://assets/audio/soundEffects/click1.ogg"),
	preload("res://assets/audio/soundEffects/click5.ogg"),
	preload("res://assets/audio/soundEffects/click7.ogg")
]

var sons_hover: Array[AudioStream] = [
	preload("res://assets/audio/soundEffects/hover1.ogg"),
	preload("res://assets/audio/soundEffects/hover2.ogg"),
	preload("res://assets/audio/soundEffects/hover3.ogg"),
]

func _ready():
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	
	get_tree().node_added.connect(_on_node_added)

func tocar(stream: AudioStream, loop: bool = true) -> void:
	if player.stream == stream and player.playing:
		return  # já tocando essa música, não reinicia
	
	player.stream = stream
	
	# Ativa loop no recurso em tempo de execução
	if stream is AudioStreamMP3:
		stream.loop = loop
	elif stream is AudioStreamOggVorbis:
		stream.loop = loop
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED
	
	player.play()

func tocar_sfx(stream: AudioStream) -> void:
	sfx_player.stream = stream
	sfx_player.play()

func _on_node_added(node: Node) -> void:
	if node is Button:
		node.pressed.connect(tocar_sfx_aleatorio)

func tocar_sfx_aleatorio() -> void:
	if sons_clique.is_empty():
		return
	var stream = sons_clique[randi() % sons_clique.size()]
	sfx_player.stream = stream
	sfx_player.play()

func tocar_sfx_hover() -> void:
	if sons_hover.is_empty():
		return
	var stream = sons_hover[randi() % sons_hover.size()]
	sfx_player.stream = stream
	sfx_player.play()

func set_volume(db: float) -> void:
	player.volume_db = db

func parar() -> void:
	player.stop()

func set_volume_musica(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func set_volume_sfx(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
