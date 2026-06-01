extends Node2D

@onready var sprite = $Sprite2D
@onready var label = $Label

# Precisamos que o nó tenha um modo de foco para ser selecionável pelo teclado
func _ready():
	# Se você não tiver um botão invisível, podemos usar o input_pickable
	# Mas para facilitar foco de teclado, recomendo colocar um Button invisível como filho.
	# Aqui vamos supor que existe um nó 'FocusHandler' (um Button com opacity 0)
	$Sprite2D/Button.focus_entered.connect(_on_focus_entered)
	$Sprite2D/Button.focus_exited.connect(_on_focus_exited)
	$Sprite2D/Button.mouse_entered.connect(func(): $Sprite2D/Button.grab_focus())

func _on_focus_entered():
	aplicar_efeito_selecao(true)

func _on_focus_exited():
	aplicar_efeito_selecao(false)

func aplicar_efeito_selecao(ativo: bool):
	var tween = create_tween().set_parallel(true)
	if ativo:
		z_index = 10
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "modulate", Color(1.8, 1.8, 1.8), 0.2) # Brilho Bloom
		label.modulate = Color(1, 1, 0) # Nome amarelo
	else:
		z_index = 0
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)
		label.modulate = Color(1, 1, 1)

func _on_button_pressed() -> void:
	aplicar_efeito_selecao(true)
	print("Personagem selecionado: ", name)
