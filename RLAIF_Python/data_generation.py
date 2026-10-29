import random

MIN_AMOUNT_OF_SQUARES = 5
MAX_AMOUNT_OF_SQUARES = 10
MIN_AMOUNT_OF_CONNECTIONS = 2
MAX_AMOUNT_OF_CONNECTIONS = 10
MIN_CONNECTION_THICKNESS = 1.0
MAX_CONNECTION_THICKNESS = 6.0
MIN_SQUARE_POSITION = (0, 0)
MAX_SQUARE_POSITION = (800, 600)
MIN_SQUARE_RADIUS = 15.0
MAX_SQUARE_RADIUS = 60.0
MIN_SQUARE_HUE = 0.0
MAX_SQUARE_HUE = 1.0
MIN_SQUARE_OPACITY = 0.1
MAX_SQUARE_OPACITY = 1.0

def generate_data(set_size: int) -> list[dict]:
	data_set: list[dict] = []
	for _ in range(set_size):
		amount_of_squares = random.randint(MIN_AMOUNT_OF_SQUARES, MAX_AMOUNT_OF_SQUARES)
		amount_of_connections = random.randint(MIN_AMOUNT_OF_CONNECTIONS, MAX_AMOUNT_OF_CONNECTIONS)

		set_squares: list[dict] = []
		position_collision_check: dict = {}
		for _ in range(amount_of_squares):
			pos_x = random.randint(MIN_SQUARE_POSITION[0], MAX_SQUARE_POSITION[0])
			pos_y = random.randint(MIN_SQUARE_POSITION[1], MAX_SQUARE_POSITION[1])
			pos_key = f"{pos_x}, {pos_y}"
			while pos_key in position_collision_check:
				pos_x = random.randint(MIN_SQUARE_POSITION[0], MAX_SQUARE_POSITION[0])
				pos_y = random.randint(MIN_SQUARE_POSITION[1], MAX_SQUARE_POSITION[1])
				pos_key = f"{pos_x}, {pos_y}"
			position_collision_check[pos_key] = True
			square = {
				"position": (pos_x, pos_y),
				"radius": random.uniform(MIN_SQUARE_RADIUS, MAX_SQUARE_RADIUS),
				"hue": random.uniform(MIN_SQUARE_HUE, MAX_SQUARE_HUE),
				"opacity": random.uniform(MIN_SQUARE_OPACITY, MAX_SQUARE_OPACITY),
			}
			set_squares.append(square)

		set_connections: list[dict] = []
		connection_overlap_check: dict = {}
		for _ in range(amount_of_connections):
			square_a_index = random.randint(0, len(set_squares) -1)
			square_b_index = random.randint(0, len(set_squares) -1)
			key = f"{min(square_a_index, square_b_index)}_{max(square_a_index, square_b_index)}"
			while square_a_index == square_b_index or key in connection_overlap_check:
				square_a_index = random.randint(0, len(set_squares) -1)
				square_b_index = random.randint(0, len(set_squares) -1)
				key = f"{min(square_a_index, square_b_index)}_{max(square_a_index, square_b_index)}"
			connection_overlap_check[key] = True

			connection = {
				"a": square_a_index,
				"b": square_b_index,
				"thickness": random.uniform(MIN_CONNECTION_THICKNESS, MAX_CONNECTION_THICKNESS)
			}
			set_connections.append(connection)

		single_set = {
			"squares": set_squares,
			"connections": set_connections,
		}
		data_set.append(single_set)
	return data_set