extends Node2D
class_name Prompt

var squares: Array[SquareData] = []
var connections: Array[ConnectionData] = []

func create_set_from_data():
	

func _draw() -> void:
	for i in range(squares.size()):
		draw_circle(squares[i].position, squares[i].radius, Color.from_hsv(squares[i].hue, 1.0, 1.0, squares[i].opacity))
	for i in range(connections.size()):
		var a = squares[connections[i].objectAIndex].position
		var b = squares[connections[i].objectBIndex].position
		var dir = (a - b).normalized()
		var a_pos = a + (-dir * squares[connections[i].objectAIndex].radius)
		var b_pos = b + (dir * squares[connections[i].objectBIndex].radius)
		draw_line(a_pos, b_pos, Color.WHITE, connections[i].thickness)
