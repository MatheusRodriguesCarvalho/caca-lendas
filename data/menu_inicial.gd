extends Node2D

const SALAS_VALIDAS = ["chainsaw man", "contrato", "vazio", "SalamandraAzul"]

func _ready():
	MusicManager.set_volume_musica($UI/PainelOpcoes/VBox/SliderMusica.value)
	MusicManager.set_volume_sfx($UI/PainelOpcoes/VBox/SliderEfeitos.value)
	
	MusicManager.parar()
	var stream = preload("res://assets/audio/soundtracks/figth_1.mp3")
	MusicManager.tocar(stream)

func _on_criar_sessao_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/selecao_personagens.tscn")

func _on_acessar_sessao_pressed() -> void:
	$UI/PainelSala.visible = true
	$UI/PainelSala/VBox/Campo.grab_focus()

func _on_lista_de_amigos_pressed() -> void:
	MusicManager.tocar_sfx_aleatorio()
	#get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_entrar_pressed() -> void:
	var campo = $UI/PainelSala/VBox/Campo as LineEdit
	var nome = campo.text.strip_edges().to_lower()
	if nome in SALAS_VALIDAS:
		get_tree().change_scene_to_file("res://scenes/mapa.tscn")
	else:
		var erro = $UI/PainelSala/VBox/Erro as Label
		erro.text = "Sala \"%s\" não encontrada." % campo.text.strip_edges()
		erro.modulate = Color(1, 0.3, 0.3, 1)
		var tween = create_tween()
		tween.tween_property(erro, "modulate:a", 0.0, 1.5)
		tween.tween_callback(func(): erro.text = "")

func _on_cancelar_pressed() -> void:
	$UI/PainelSala.visible = false

func _on_opcoes_pressed() -> void:
	$UI/PainelOpcoes.visible = true
	
	$UI/PainelOpcoes/VBox/SliderMusica.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$UI/PainelOpcoes/VBox/SliderEfeitos.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_fechar_opcoes_pressed() -> void:
	$UI/PainelOpcoes.visible = false

func _on_slider_musica_value_changed(value: float) -> void:
	MusicManager.set_volume_musica(value)

func _on_slider_efeitos_value_changed(value: float) -> void:
	MusicManager.set_volume_sfx(value)
