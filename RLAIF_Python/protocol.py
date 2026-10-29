import json

def encode_message(data: dict) -> bytes:
	dump = json.dumps(data) + "\n"
	encoded_message = dump.encode()
	return encoded_message

def decode_message(data: bytes) -> dict:
	decoded_message = data.decode()
	message = json.loads(decoded_message)
	return message