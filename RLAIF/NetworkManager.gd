extends Node

enum ConnectionStatus {
	NONE = 0,
	CONNECTING = 1,
	CONNECTED = 2,
	ERROR = 3,
	NOT_STATUS,
}

var client: StreamPeerTCP

const HOST = "127.0.0.1"
const PORT = 42666

var connectionStatus: ConnectionStatus
var buffer: PackedByteArray

func _ready() -> void:
	print("Connecting to " + HOST + " on port " + str(PORT) + "...")
	client = StreamPeerTCP.new()
	client.connect_to_host(HOST, PORT)

func _process(delta: float) -> void:
	client.poll()
	var connectionStatusInt = client.get_status()
	var newConnectionStatus = _match_connection_status(connectionStatusInt)
	if connectionStatus != newConnectionStatus:
		print("Connection changed from " + str(connectionStatus) + " to " + str(newConnectionStatus))
		connectionStatus = newConnectionStatus
	
	if connectionStatus == ConnectionStatus.CONNECTED:
		buffer.append_array(_receive_data(client))
		var index = buffer.find("\n".to_utf8_buffer()[0])
		while index != -1:
			var fullMessage = buffer.slice(0, index)
			var decodedMessage = _decode_message(fullMessage)
			MessageHandler.on_message_received(decodedMessage)
			var rest = buffer.slice(index + 1)
			buffer = rest
			index = rest.find("\n".to_utf8_buffer()[0])

func _receive_data(client: StreamPeerTCP) -> PackedByteArray:
	var availableBytes = client.get_available_bytes()
	if availableBytes > 0:
		var data = client.get_data(availableBytes)
		if data[0] != 0:
			push_error("Error in receiving data: " + str(data[0]))
			return []
		return data[1]
	return []

func _match_connection_status(status: int) -> ConnectionStatus:
	var _conStat = ConnectionStatus.find_key(status)
	if _conStat == null:
		return ConnectionStatus.NOT_STATUS
	return status as ConnectionStatus

func Send_Data(data: String) -> void:
	var encodedMessage = _encode_message(data)
	if connectionStatus != ConnectionStatus.CONNECTED:
		print("Can't send data, because connection is " + str(connectionStatus))
		return
	print("Sending...")
	client.put_data(encodedMessage)

func Request_Data(type: String) -> void:
	var data = {
		"type": type
	}
	var message = JSON.stringify(data)
	Send_Data(message)

func close_connection() -> void:
	if connectionStatus != ConnectionStatus.CONNECTED:
		print("Can't close connection because it's " + str(connectionStatus))
		return
	print("Closing connection...")
	client.disconnect_from_host()

func _encode_message(message: String) -> PackedByteArray:
	return (message + "\n").to_utf8_buffer()

func _decode_message(message: PackedByteArray) -> Dictionary:
	var json = JSON.new()
	json.parse(message.get_string_from_utf8())
	return json.data
