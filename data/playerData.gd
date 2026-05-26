extends Node

var conhecimento = []

func adicionar_conhecimento(id: String):
	if not id in conhecimento:
		conhecimento.append(id)
		print("Conhecimento adquirido")
