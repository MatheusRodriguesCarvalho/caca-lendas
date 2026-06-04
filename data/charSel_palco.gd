extends Node2D

# Referências aos containers (caminhos relativos aos nós que criamos)
@onready var slots_container = $Posicoes
@onready var characters_container = $NoPersonagens
@onready var pasta_personagens = $NoPersonagens

var personagem_selecionado: Node2D = null  # <-- rastreia quem está selecionado

func _ready():
	alinhar_marcadores()
	alinhar_personagens()

func alinhar_marcadores():
	var slots = slots_container.get_children()
	var valor = 1150 / (slots.size() + 1)
	for i in range(slots.size()):
		slots[i].global_position = Vector2(valor * (i + 1), 480)

func alinhar_personagens():
	var slots = slots_container.get_children()
	var personagens = characters_container.get_children()
	for i in range(personagens.size()):
		if i < slots.size():
			personagens[i].global_position = slots[i].global_position
		else:
			personagens[i].visible = false
			push_warning("Aviso: Mais personagens do que slots disponíveis!")

func selecionar_personagem(char_node: Node2D) -> void:
	# Deseleciona o anterior (se for diferente)
	if personagem_selecionado != null and personagem_selecionado != char_node:
		personagem_selecionado.set_selected(false)

	# Toggle: clicar no mesmo deseleciona
	if personagem_selecionado == char_node:
		char_node.set_selected(false)
		personagem_selecionado = null
	else:
		char_node.set_selected(true)
		personagem_selecionado = char_node
	print("Selecionado: ", personagem_selecionado.name if personagem_selecionado else "nenhum")

# Mantidos caso ainda sejam usados em outro lugar
func destacar_personagem(index: int):
	var personagens = characters_container.get_children()
	for i in range(personagens.size()):
		personagens[i].scale = Vector2(1.1, 1.1) if i == index else Vector2(0.9, 0.9)
		personagens[i].modulate = Color(1, 1, 1) if i == index else Color(0.5, 0.5, 0.5)

func atualizar_selecao(nome_personagem: String):
	for p in pasta_personagens.get_children():
		if p.name.to_lower() == nome_personagem.to_lower():
			p.set_selected(true)
			p.z_index = 10
		else:
			p.set_selected(false)
			p.z_index = 0
