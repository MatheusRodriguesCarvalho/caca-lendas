class_name Regiao
extends Area2D

@export
var collision : CollisionPolygon2D
@export
var polygon : Polygon2D
@export
var line : Line2D

var color

func _ready() -> void:
	polygon.polygon = collision.polygon
	line.points = collision.polygon


func _on_mouse_entered() -> void:
	color = polygon.color
	polygon.color = Color("8080804f")


func _on_mouse_exited() -> void:
	polygon.color = Color(color)
