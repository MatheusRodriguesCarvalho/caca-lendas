extends Node

func _ready() -> void:
	var stream = preload("res://assets/audio/soundtracks/figth_1.mp3")
	MusicManager.tocar(stream)

func _on_confirmar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mapa.tscn")

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
