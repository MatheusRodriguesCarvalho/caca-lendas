extends PanelContainer

# Referências aos nós (Ajuste os caminhos conforme sua hierarquia exata)
@onready var chat_history = $VBoxContainer/ChatContent/ChatHistory
@onready var line_edit = $VBoxContainer/ChatContent/InputArea/Message
@onready var send_btn = $VBoxContainer/ChatContent/InputArea/SendMessage

# Dados para simular os outros jogadores
var nomes_bots = ["ChurrascoMaster", "Surfista", "BaianoGaucho", "Polem"]
var mensagens_bots = [
	"Alguém pretende ir para o Norte?",
	"Alguém mais ouviu um grito de pano rasgando no Norte? O que era pra ser isso? Morri antes de descobrir",
	"Espero encontrar figuras politicas no Centro-Oeste, e ter opções de dialogos democraticos",
	"Os moradores do Centro-Oeste dizem que o conhecimento é a chave. Eu busquei e encontrei...",
	"Já foram para o Sul? Ahh, parecia a mais cabulosa...",
	"O Sul tá tão frio, mas por que havia sinais de queimada?",
	"Seria bom criaturas mais desafiadoras no Sudeste, imagina só, um MC Lobo da Hilux?",
	"Tentei tankar o Sudeste, mas a neblina foi pegado",
	"Eu perdi no Nordeste por desidratação... Sequer existe essa mecanica... COMO EU PERDI?",
	"Nordeste é porrada, teve uma run que eu perdi logo no primeiro dialogo",
	"Teve ourta run que eu tomei uma sova dos NPCs",
	"Pessoalzinho dificl de agradar, poucas opções funcionam",
	"Fui resenhado, Guys",
	"Não sobrou nada, a cidade foi DESTRUIDA",
	"Não tanko essas animações dos NPCs, parecem pedra",
	"Impressão minha ou a imagem ali no canto está desalinhada?",
	"Imagina se tivesse sistema de fome? Ou inventario?",
	"Guys, o mapa abriu aqui mas a imagem ficou esticada, é normal?",
	"Noob demasiado, o ChurrascoMaster perdeu no tutorial, como?",
	"Polem falou que ia ter boss gigante na Amazônia. Cadê? Só vi mato e arrependimento",
	"Mano, não tem tutorial?",
	"Seria que Surfista tentou surfar na neblina e morreu? kkkk mano",
	"Ceis não cansa, né? Ceis viaja demais nas teorias",
	"Polem tinha razão, Polem sempre acerta os palpites",
]

var timer_simulacao: Timer

func _ready():
	line_edit.text_submitted.connect(_on_mensagem_enviada)
	send_btn.pressed.connect(_on_btn_enviar_pressed)
	
	chat_history.bbcode_enabled = true
	
	timer_simulacao = Timer.new()
	timer_simulacao.timeout.connect(_gerar_mensagem_bot)
	add_child(timer_simulacao)
	
	# Inicia o fluxo de mensagens
	adicionar_mensagem("Sistema", "Bem-vindo ao servidor global!", "ffcc00")
	_iniciar_proximo_bot()

# --- LÓGICA DO JOGADOR ---
func _on_btn_enviar_pressed():
	_on_mensagem_enviada(line_edit.text)

func _on_mensagem_enviada(texto: String):
	var msg = texto.strip_edges()
	
	if msg == "":
		return
	
	adicionar_mensagem("Você", msg, "00ffff")
	
	line_edit.text = ""
	line_edit.grab_focus()

# --- LÓGICA DOS BOTS (SIMULAÇÃO) ---
func _gerar_mensagem_bot():
	var autor = nomes_bots.pick_random()
	var msg = mensagens_bots.pick_random()
	adicionar_mensagem(autor, msg, "ff9955")
	_iniciar_proximo_bot()

func _iniciar_proximo_bot():
	timer_simulacao.wait_time = randf_range(2.0, 7.0)
	timer_simulacao.start()

# --- FUNÇÃO CENTRAL DE TEXTO ---
func adicionar_mensagem(autor: String, texto: String, cor_hex: String):
	# Formata a string usando BBCode. Ex: [color=#00ffff][b]Você:[/b][/color] Oi!
	var linha = "[color=#" + cor_hex + "][b]" + autor + ":[/b][/color] " + texto + "\n"
	#print(texto)
	chat_history.append_text(linha)
