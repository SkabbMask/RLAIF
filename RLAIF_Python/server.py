import socket
import protocol
import device
import models.manager as manager

PORT = 42666
HOST = "127.0.0.1"

handlers = {
	"get_device_name": lambda message: device.get_device_name(),
	"train_model": lambda message: manager.train_model(message),
	"get_prompt_data": lambda message: manager.get_prompt_data(),
}

def main():
	print(f"Starting up server at host {HOST}...")
	server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	server_socket.bind((HOST, PORT))
	server_socket.listen(1)
	print(f"Listening at port {PORT}")
	connection_socket, connecting_with = server_socket.accept()
	print(f"Client connected from {connecting_with}")

	buffer = b""
	while(True):
		data = connection_socket.recv(4096)
		print(f"Received data: {data}")
		
		if not data:
			print(f"Disconnecting...")
			break

		buffer += data
		end_message_index = buffer.find(b'\n')
		while(end_message_index != -1):
			full_message = protocol.decode_message(buffer[:end_message_index])
			print(f"Got full message: {full_message}")
			response = _handle_message(full_message)
			encoded_message = protocol.encode_message(response)
			connection_socket.send(encoded_message)
			buffer = buffer[end_message_index+1:]
			end_message_index = buffer.find(b'\n')

	print(f"End")

def _handle_message(message: dict):
	type = message["type"]
	result = handlers[type](message)
	response = { "type": type, "result": result }
	return response

if __name__ == '__main__':
	main()