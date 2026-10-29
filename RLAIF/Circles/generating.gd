extends Node
class_name Generating

const MIN_AMOUNT_OF_CIRCLES = 5
const MAX_AMOUNT_OF_CIRCLES = 10

const MIN_AMOUNT_OF_CONNECTIONS = 2
const MAX_AMOUNT_OF_CONNECTIONS = 10

const MIN_CONNECTION_THICKNESS = 1.0
const MAX_CONNECTION_THICKNESS = 6.0

const MIN_CIRCLE_POSITION = Vector2(0, 0)
const MAX_CIRCLE_POSITION = Vector2(800, 600)

const MIN_CIRCLE_RADIUS = 15.0
const MAX_CIRCLE_RADIUS = 60.0

const MIN_CIRCLE_HUE = 0.0
const MAX_CIRCLE_HUE = 1.0

const MIN_CIRCLE_OPACITY = 0.1
const MAX_CIRCLE_OPACITY = 1.0

func generate_set(set_size: int, circles: Array[CircleData], connections: Array[ConnectionData]) -> String:
	var _set: Array[Dictionary]= []
	_set.append(generate_input(circles, connections))
	for i in range(set_size - 1):
		var blend = float(i) / (set_size - 1)
		var rand_amount_of_circles_in_full_range = randi_range(MIN_AMOUNT_OF_CIRCLES, MAX_AMOUNT_OF_CIRCLES)
		var rand_amount_of_connections_in_full_range = randi_range(MIN_AMOUNT_OF_CONNECTIONS, MAX_AMOUNT_OF_CONNECTIONS)
		var amount_of_circles = int(lerp(rand_amount_of_circles_in_full_range, circles.size(), blend))
		var amount_of_connections = int(lerp(rand_amount_of_connections_in_full_range, connections.size(), blend))
		
		var set_circles: Array[CircleData] = []
		var position_collision_check = {}
		for c_i in range(amount_of_circles):
			var circle = CircleData.new()
			var pos_x = randi_range(MIN_CIRCLE_POSITION.x, MAX_CIRCLE_POSITION.x)
			var pos_y = randi_range(MIN_CIRCLE_POSITION.y, MAX_CIRCLE_POSITION.y)
			var pos_key = "%d_%d" % [pos_x, pos_y]
			while position_collision_check.has(pos_key):
				pos_x = randi_range(MIN_CIRCLE_POSITION.x, MAX_CIRCLE_POSITION.x)
				pos_y = randi_range(MIN_CIRCLE_POSITION.y, MAX_CIRCLE_POSITION.y)
				pos_key = "%d_%d" % [pos_x, pos_y]
			position_collision_check[pos_key] = true
			var rand_circle_position = Vector2(pos_x, pos_y)
			var rand_circle_radius = randf_range(MIN_CIRCLE_RADIUS, MAX_CIRCLE_RADIUS)
			var rand_circle_hue = randf_range(MIN_CIRCLE_HUE, MAX_CIRCLE_HUE)
			var rand_circle_opacity = randf_range(MIN_CIRCLE_OPACITY, MAX_CIRCLE_OPACITY)
			if c_i < circles.size():
				circle.position = lerp(rand_circle_position, circles[c_i].position, blend)
				circle.radius = lerp(rand_circle_radius, circles[c_i].radius, blend)
				circle.hue = lerp(rand_circle_hue, circles[c_i].hue, blend)
				circle.opacity = lerp(rand_circle_opacity, circles[c_i].opacity, blend)
			else:
				circle.position = rand_circle_position
				circle.radius = rand_circle_radius
				circle.hue = rand_circle_hue
				circle.opacity = rand_circle_opacity
			set_circles.append(circle)
		
		var set_connections: Array[ConnectionData] = []
		var connectionOverlapCheck = {}
		for c_i in range(amount_of_connections):
			var cirlceA_index = randi_range(0, set_circles.size() - 1)
			var circleB_index = randi_range(0, set_circles.size() - 1)
			var key = "%d_%d" % [min(cirlceA_index, circleB_index), max(cirlceA_index, circleB_index)]
			while circleB_index == cirlceA_index or connectionOverlapCheck.has(key):
				cirlceA_index = randi_range(0, set_circles.size() - 1)
				circleB_index = randi_range(0, set_circles.size() - 1)
				key = "%d_%d" % [min(cirlceA_index, circleB_index), max(cirlceA_index, circleB_index)]
			connectionOverlapCheck[key] = true
			var connection = ConnectionData.new()
			connection.circleAIndex = cirlceA_index
			connection.circleBIndex = circleB_index
			var rand_connection_thickness = randf_range(MIN_CONNECTION_THICKNESS, MAX_CONNECTION_THICKNESS)
			if c_i < connections.size():
				connection.thickness = lerp(rand_connection_thickness, connections[c_i].thickness, blend)
			else:
				connection.thickness = rand_connection_thickness
			set_connections.append(connection)
		_set.append(generate_input(set_circles, set_connections))
	return JSON.stringify(_set)

func generate_input(circles: Array[CircleData], connections: Array[ConnectionData]) -> Dictionary:
	var _circles = []
	for i in range(circles.size()):
		_circles.append({
			"position": circles[i].position,
			"radius": circles[i].radius,
			"hue": circles[i].hue,
			"opacity": circles[i].opacity,
			})
	var _connections = []
	for i in range(connections.size()):
		_connections.append({
			"a": connections[i].circleAIndex,
			"b": connections[i].circleBIndex,
			"thickness": connections[i].thickness,
		})
	return {
		"circles": _circles,
		"connections": _connections,
	}
