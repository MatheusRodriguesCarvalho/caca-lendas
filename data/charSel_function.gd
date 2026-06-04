extends Node2D

@onready var sprite = $Sprite2D
@onready var label = $Label

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = sprite.to_local(get_global_mouse_position())
		var no_sprite = sprite.get_rect().has_point(local_pos)
		if no_sprite:
			_on_clicked()
			get_viewport().set_input_as_handled()

func _on_clicked() -> void:
	print("clicado: ", name)
	get_parent().get_parent().selecionar_personagem(self)

func _on_sprite_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_clicked()

func set_selected(value: bool) -> void:
	aplicar_efeito_selecao(value)

func aplicar_efeito_selecao(ativo: bool):
	var tween = create_tween().set_parallel(true)
	if ativo:
		z_index = 10
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_BACK)
		tween.tween_property(sprite, "modulate", Color(1.8, 1.8, 1.8), 0.2)
		label.modulate = Color(1, 1, 0)
	else:
		z_index = 0
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)
		label.modulate = Color(1, 1, 1)
