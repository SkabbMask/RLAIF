extends Node2D
class_name Response

const AMOUNT = 10

var circles: Array[CircleData] = []
var connections: Array[ConnectionData] = []
@export var attributePanel: PanelContainer

var selectedCircleIndex = -1
var draggingCircleIndex = -1
var rightClickOn = -1

func _ready() -> void:
	attributePanel.radiusSlider.value_changed.connect(_on_radius_slider)
	attributePanel.hueSlider.value_changed.connect(_on_hue_slider)
	attributePanel.opacitySlider.value_changed.connect(_on_opacity_slider)
	for i in range(AMOUNT):
		var circle = CircleData.new()
		circle.position = Vector2(randi_range(0, 800), randi_range(0, 600))
		circle.radius = randf_range(15.0, 60.0)
		circle.hue = randf_range(0.0, 1.0)
		circle.opacity = randf_range(0.0, 1.0)
		circles.append(circle)
	
	var connectionOverlapCheck = {}
	for i in range(circles.size()):
		if randi_range(0,2) == 0:
			var connection = ConnectionData.new()
			var b = randi_range(0, circles.size() -1)
			if b == i:
				continue
			var key = "%d_%d" % [min(i, b), max(i, b)]
			if connectionOverlapCheck.has(key):
				continue
			connectionOverlapCheck[key] = true
			connection.objectAIndex = i
			connection.objectBIndex = b
			connection.thickness = randf_range(1.0, 6.0)
			connections.append(connection)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			var inputData = _generate_input()
			print("Send data: " + inputData)
			NetworkManager.Send_Data(inputData)
	if event is InputEventMouseButton:
		var mouse_click_pos = to_local(event.position)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_unselect_circle()
				draggingCircleIndex = -1
				for i in range(circles.size() -1, -1, -1):
					if _is_point_in_circle(mouse_click_pos, circles[i]):
						rightClickOn = i
						return
			else:
				if rightClickOn > -1:
					for i in range(circles.size() -1, -1, -1):
						if _is_point_in_circle(mouse_click_pos, circles[i]):
							if rightClickOn != i:
								#Remember to implement check for reversed overlap too
								var connection = ConnectionData.new()
								connection.objectAIndex = rightClickOn
								connection.objectBIndex = i
								connection.thickness = randf_range(1.0, 6.0)
								connections.append(connection)
								queue_redraw()
								rightClickOn = -1
								return
							else:
								var removeAt = []
								for j in range(connections.size()):
									if connections[j].objectAIndex == i or connections[j].objectBIndex == i:
										removeAt.append(j)
								removeAt.sort()
								removeAt.reverse()
								for r in removeAt:
									connections.remove_at(r)
								queue_redraw()
								rightClickOn = -1
								return
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				for i in range(circles.size() - 1, -1, -1):
					if _is_point_in_circle(mouse_click_pos, circles[i]):
						_select_circle(i)
						attributePanel.radiusSlider.set_value_no_signal(circles[i].radius)
						attributePanel.hueSlider.set_value_no_signal(circles[i].hue)
						attributePanel.opacitySlider.set_value_no_signal(circles[i].opacity)
						draggingCircleIndex = i
						return
			else:
				draggingCircleIndex = -1
				if selectedCircleIndex > -1:
					for i in range(circles.size() - 1, -1, -1):
						if _is_point_in_circle(mouse_click_pos, circles[i]):
							return
				_unselect_circle()
				return
	if event is InputEventMouseMotion:
		if draggingCircleIndex > -1:
			var mouse_click_pos = to_local(event.position)
			circles[draggingCircleIndex].position = mouse_click_pos
		queue_redraw()

func _select_circle(index: int) -> void:
	selectedCircleIndex = index
	attributePanel.position = circles[index].position
	attributePanel.visible = true

func _unselect_circle() -> void:
	selectedCircleIndex = -1
	attributePanel.visible = false

func _on_radius_slider(value: float) -> void:
	if selectedCircleIndex < 0:
		return
	circles[selectedCircleIndex].radius = value
	queue_redraw()

func _on_hue_slider(value: float) -> void:
	if selectedCircleIndex < 0:
		return
	circles[selectedCircleIndex].hue = value
	queue_redraw()

func _on_opacity_slider(value: float) -> void:
	if selectedCircleIndex < 0:
		return
	circles[selectedCircleIndex].opacity = value
	queue_redraw()

func _is_point_in_circle(point: Vector2, circle: CircleData) -> bool:
	return point.distance_to(circle.position) <= circle.radius

func _generate_input() -> String:
	var _circles = []
	for i in range(circles.size()):
		_circles.append({
			"position": circles[i].position,
			"radius": circles[i].radius,
			"hue": circles[i].hue,
			"opacity": circles[i].opacity
			})
	var _connections = []
	for i in range(connections.size()):
		_connections.append({
			"a": connections[i].objectAIndex,
			"b": connections[i].objectBIndex,
			"thickness": connections[i].thickness,
		})
	var input := {
		"circles": _circles,
		"connections": _connections,
	}
	return JSON.stringify(input)

func _draw() -> void:
	for i in range(circles.size()):
		draw_circle(circles[i].position, circles[i].radius, Color.from_hsv(circles[i].hue, 1.0, 1.0, circles[i].opacity))
	for i in range(connections.size()):
		var a = circles[connections[i].objectAIndex].position
		var b = circles[connections[i].objectBIndex].position
		var dir = (a - b).normalized()
		var a_pos = a + (-dir * circles[connections[i].objectAIndex].radius)
		var b_pos = b + (dir * circles[connections[i].objectBIndex].radius)
		draw_line(a_pos, b_pos, Color.WHITE, connections[i].thickness)
