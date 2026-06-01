extends Node2D

# Referências aos containers (caminhos relativos aos nós que criamos)
@onready var slots_container = $Posicoes
@onready var characters_container = $NoPersonagens
@onready var pasta_personagens = $NoPersonagens

func _ready():
	alinhar_marcadores()
	alinhar_personagens()

func alinhar_marcadores():
	var slots = slots_container.get_children()
	var valor = 1150 / (slots.size()+1)
	for i in range(slots.size()):
		slots[i].global_position = Vector2(valor * (i+1), 480)
	print(slots.size())

func alinhar_personagens():
	var slots = slots_container.get_children()
	var personagens = characters_container.get_children()
	for i in range(personagens.size()):
		if i < slots.size():
			var target_pos = slots[i].global_position
			personagens[i].global_position = target_pos
		else:
			personagens[i].visible = false
			push_warning("Aviso: Mais personagens do que slots disponíveis!")

func destacar_personagem(index: int):
	var personagens = characters_container.get_children()
	for i in range(personagens.size()):
		if i == index:
			# Efeito de destaque (ex: brilho ou escala maior)
			personagens[i].scale = Vector2(1.1, 1.1)
			personagens[i].modulate = Color(1, 1, 1) # Cor normal
		else:
			# Efeito de "apagado" para os outros
			personagens[i].scale = Vector2(0.9, 0.9)
			personagens[i].modulate = Color(0.5, 0.5, 0.5) # Escurecido

func atualizar_selecao(nome_personagem: String):
	# Percorre todos os Node2D dentro do grupo de personagens
	for p in pasta_personagens.get_children():
		if p.name.to_lower() == nome_personagem.to_lower():
			p.set_selected(true)
			p.z_index = 10 # Fica na frente
		else:
			p.set_selected(false)
			p.z_index = 0
