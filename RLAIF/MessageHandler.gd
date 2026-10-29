extends Node

signal on_get_device_name(device_name: String)
signal on_get_prompt_data(data: Dictionary)

func on_message_received(message: Dictionary) -> void:
	match message.type:
		"get_device_name":
			on_get_device_name.emit(message["result"])
		"get_prompt_data":
			on_get_prompt_data.emit(message["result"])
