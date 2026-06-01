extends Node2D

@export var barra_timer: ProgressBar

var nomes_bots = ["ChurrascoMaster", "Surfista", "BaianoGaucho", "Polem"]
var fluxo_popup: float = 0.0
var timeline_consequencia: String = "timeoutEnd"
var tempo_limite: float = 10.0
var tempo_atual: float = 0.0
var contando: bool = false
var no_fluxo_de_timeout: bool = false

func _ready() -> void:
	if barra_timer:
		barra_timer.hide()
		barra_timer.process_mode = PROCESS_MODE_ALWAYS
	
	Dialogic.Choices.question_shown.connect(_on_choices_shown)
	Dialogic.Choices.choice_selected.connect(_parar_timer)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_parar_timer.bind({}))
	# 2. Verificar se devemos ir para o menu
	Dialogic.timeline_ended.connect(_ao_terminar_timeline)
	# Inicia o diálogo
	
	Dialogic.start("cap1_teste")

func _process(delta: float) -> void:
	if contando and barra_timer:
		barra_timer.value -= delta
		_atualizar_cor_barra()
		if barra_timer.value <= 0:
			_executar_timeout()

func _on_choices_shown(_info: Dictionary) -> void:
	if barra_timer:
		barra_timer.max_value = tempo_limite
		barra_timer.value = tempo_limite
		barra_timer.show()
		contando = true

func _parar_timer(_info: Dictionary = {}) -> void:
	contando = false
	if barra_timer:
		barra_timer.hide()

func _executar_timeout() -> void:
	_parar_timer()
	
	# Limpeza do Dialogic para evitar sobreposição
	if Dialogic.has_subsystem("Choices"):
		Dialogic.Choices.hide_all_choices()
	
	Dialogic.end_timeline()
	
	# Delay para a UI resetar antes da próxima timeline
	await get_tree().create_timer(2).timeout
	
	no_fluxo_de_timeout = true
	
	# Inicia a nova timeline
	if timeline_consequencia != "":
		Dialogic.start(timeline_consequencia)
	else:
		Dialogic.start("timeoutEnd")

func _atualizar_cor_barra() -> void:
	var perc = barra_timer.value / barra_timer.max_value
	if perc > 0.5:
		barra_timer.modulate = Color.GREEN
	elif perc > 0.25:
		barra_timer.modulate = Color.YELLOW
	else:
		barra_timer.modulate = Color.RED

func _ao_terminar_timeline() -> void:
	# Só executa a transição de cena se a flag de timeout estiver verdadeira
	if no_fluxo_de_timeout:
		ir_para_menu_principal()

func ir_para_menu_principal() -> void:
	# Garante que não sobrou nenhum resíduo de UI
	Dialogic.end_timeline() 
	
	# Troca para a sua cena de menu
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")

func ir_para_creditos() -> void:
	# Inicia a timeline de créditos
	#Dialogic.start("timeline_creditos")
	print("Teste de Creditos")

func _on_dialogic_signal(argumento: String) -> void:
	_processar_comando(argumento)

func _processar_comando(argumento: String) -> void:
	match argumento:
		"abrir_creditos":
			#get_tree().change_scene_to_file("res://cenas/creditos.tscn")
			print("Teste de Creditos")
		"menu_inicial":
			#get_tree().change_scene_to_file("res://cenas/creditos.tscn")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
