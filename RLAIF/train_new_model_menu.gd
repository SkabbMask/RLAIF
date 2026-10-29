extends Control

@export var device_name_label: Label
@export var set_size_input: SpinBox
@export var response_template: Response
@export var generating: Generating

func _ready() -> void:
	MessageHandler.on_get_device_name.connect(on_get_device_name)
	NetworkManager.Request_Data("get_device_name")

func on_get_device_name(device_name: String):
	device_name_label.text = "Device: " + device_name

func _on_start_pressed() -> void:
	var circles = response_template.circles
	var connections = response_template.connections
	var generated_set = generating.generate_set(set_size_input.value, circles, connections)
	var request = {"type": "train_model", "set": generated_set}
	#print("generates set: " + JSON.stringify(request))
	print("Sending set...")
	NetworkManager.Send_Data(JSON.stringify(request))
	print("Set sent")
