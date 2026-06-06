extends CanvasLayer

var nomes_bots = ["ChurrascoMaster", "Surfista", "BaianoGaucho", "Polem"]

@onready var timer_popup = $"../Timer"
@onready var popup_entrada = $PainelAviso
@onready var painel_final = $PainelFinal

func _ready():
	painel_final.visible = false
	timer_popup.timeout.connect(_on_timer_popup_timeout)
	iniciar_espera_aleatoria()

func iniciar_espera_aleatoria():
	var tempo_espera = randf_range(15.0, 60.0)
	timer_popup.start(tempo_espera)

func _on_timer_popup_timeout():
	exibir_notificacao_jogador()
	iniciar_espera_aleatoria()

func exibir_notificacao_jogador():
	var autor = nomes_bots.pick_random()
	popup_entrada.get_node("Aviso").text = "O jogador " + autor + " tentou entrar na missão."
	
	popup_entrada.modulate.a = 0
	popup_entrada.visible = true
	
	var tween = create_tween()
	tween.tween_property(popup_entrada, "modulate:a", 1.0, 0.5)
	tween.tween_interval(3.0)
	tween.tween_property(popup_entrada, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): popup_entrada.visible = false)
