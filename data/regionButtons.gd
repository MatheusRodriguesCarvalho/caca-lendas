extends VBoxContainer
func _ready() -> void:
	grab_focus()

func _on_centro_oeste_mouse_entered() -> void:
	print("co hover")


func _on_centro_oeste_mouse_exited() -> void:
	print("co deshover")
