extends Node2D

func _ready() -> void:
	Dialogic.start("cap1_teste")
	Dialogic.signal_event.connect(_on_signal)

func _on_signal(signal_passed_in):
	match signal_passed_in:
		"teste teste":
			print("tudo certo por aqui")
