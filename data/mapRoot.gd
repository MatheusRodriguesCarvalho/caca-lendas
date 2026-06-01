extends Node

var dados_regioes = {
	"centro": {
		"nome": "CentroOeste",
		"descricao": "Cidade: Corguinho - MS\n\nRelatórios indicam um surto de amnésia coletiva na população local após um suposto avistamento luminoso. Testemunhas afirmam que figuras conhecidas da comunidade desapareceram, mas os moradores remanescentes evitam falar sobre o assunto, repetindo frases enigmáticas sobre uma tal 'busca'. Há uma estagnação inexplicável no comércio e na rotina urbana, como se o tempo tivesse parado.",
		"imagem": "res://assets/images/silhuetas/silhueta_sul_visual.png",
		"cena": ""
	},
	"nordeste": {
		"nome": "Nordeste",
		"descricao": "Cidade: Umburanas - BA\n\nA região enfrenta uma sequência de desaparecimentos na região. Moradores relatam que entre os desaparecidos estão pessoas que com muitos problemas familiares e com tendências ao isolamento. Muito se é comentado de que essas pessoas tenham migrado para outra cidade, e muito se é comentado de que essas pessoas nunca mais serão encontradas.",
		"imagem": "res://assets/images/silhuetas/silhueta_nordeste.png",
		"cena": "res://scenes/main.tscn"
	},
	"norte": {
		"nome": "Norte",
		"descricao": "Local: Floresta Amazônica - AM\n\nExpedições de mapeamento relataram surtos de doenças incomuns para existirem no mundo, doenças que causam apodrecimento dos musculos, expansão cerebral anomala ou fragilização óssea. Os enfermos começam a relatar que ourivam um grito viceral antes de adoecerem, e que toda noite são assolados por sons de tecido rasgando. Em sua totalidade, os enfermos morrem depois de poucos dias apos acometidos pelas doenças e seus corpo são cremados para efitar proliferação de um possível patógeno infeccioso.",
		"imagem": "res://assets/images/silhuetas/silhueta_sul_visual.png",
		"cena": ""
	},
	"sudeste": {
		"nome": "Sudeste",
		"descricao": "Cidade: Paranapiacaba - SP\n\nA neblina na vila ferroviária não se dissipa há semanas, e quando observado, as sombras de árvores parecem dançar como algas no mar. Moradores relatam a sensação constante de serem observados por vultos. Foi reportado um odor de decomposição vindo de áreas onde nada deveria crescer, pois a terra ao redor da vila parece ter perdido a capacidade de sustentar vida.",
		"imagem": "res://assets/images/silhuetas/silhueta_sudeste.png",
		"cena": ""
	},
	"sul": {
		"nome": "Sul",
		"descricao": "Local: Serra Gaúcha - RS\n\nGrandes incêndios vem assolando uma vila na serra gaucha, inpedindo que haja muita exploração dos recursos locais. As queimadas e restaurações atípicas da fauna e flora fizeram os moradores crer que há uma força maior por trás, a exploração e expansão começaram e ser percebidas como profano, e qualquer tentativa de empresas externas de utilizar da região, era fortemente repudiada pelo moradores.",
		"imagem": "res://assets/images/silhuetas/silhueta_sul.png",
		"cena": ""
	}
}

@onready var painel_missao = $UI/Control/MarginContainer/MainLayout/PainelDireito
@onready var info_texto = $UI/Control/MarginContainer/MainLayout/PainelDireito/MarginContainer/VBox/MolduraLore/Lore
@onready var info_imagem = $UI/Control/MarginContainer/MainLayout/PainelDireito/MarginContainer/VBox/ModuraSilhueta/Silhueta
@onready var nodes_mapa = $MapaBrasil
@onready var sprite_mapa = $MapaBrasil/Mapa
@onready var btn_confirmar = $UI/Control/MarginContainer/MainLayout/PainelDireito/MarginContainer/VBox/Botao/TextureButton
@onready var aviso_label = $UI/PainelAviso

var regiao_ativa: String = ""
var nomes_bots = ["ChurrascoMaster", "Surfista", "BaianoGaucho", "Polem"]

func _ready():
	resetar_mapa_e_botoes()
	
	for botao in get_tree().get_nodes_in_group("BotoesRegioes"):
		botao.pressed.connect(_on_regiao_selecionada.bind(botao.name.to_lower()))
	aviso_label.visible = false
	btn_confirmar.pressed.connect(_on_send_message_pressed)

func _on_regiao_selecionada(id_regiao: String):
	resetar_mapa_e_botoes()
	
	if not dados_regioes.has(id_regiao): return
	var data = dados_regioes[id_regiao]
	
	regiao_ativa = id_regiao
	
	var btn_path = "UI/Control/MarginContainer/MainLayout/PainelEsquerdo/BotoesRegiao/" + id_regiao.capitalize()
	if has_node(btn_path):
		get_node(btn_path).grab_focus()
	
	var regiao_node = nodes_mapa.get_node(id_regiao.capitalize())
	if regiao_node:
		regiao_node.visible = true
		if regiao_node.has_node("Sprite2D"):
			regiao_node.get_node("Sprite2D").visible = true
	
	info_texto.text = "[center][b]" + data.nome + "[/b][/center]\n" + data.descricao
	info_imagem.texture = load(data.imagem)
	
	painel_missao.visible = true

func resetar_mapa_e_botoes():
	for regiao in nodes_mapa.get_children():
		regiao.visible = false
	sprite_mapa.visible = true

func _on_send_message_pressed() -> void:
	if regiao_ativa == "":
		mostrar_aviso("Selecione uma região no mapa primeiro!")
		return
	
	var dados = dados_regioes[regiao_ativa]
	if not dados.has("cena") or dados["cena"] == "":
		var autor = nomes_bots.pick_random()
		mostrar_aviso("O(A) Jogador(a) [" + autor + "] está realizando essa Missão")
		return
	
	var erro = get_tree().change_scene_to_file(dados["cena"])
	if erro != OK:
		mostrar_aviso("Erro técnico ao carregar a fase.")

func mostrar_aviso(mensagem: String):
	var textLabel = aviso_label.get_node("Aviso")
	
	aviso_label.visible = true
	textLabel.text = mensagem
	aviso_label.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_property(aviso_label, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(func(): aviso_label.visible = false)
