extends Node2D


func _on_criar_sessao_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/selecao_personagens.tscn")

func _on_entrar_sessao_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mapa.tscn")
