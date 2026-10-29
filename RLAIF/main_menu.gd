extends Control
class_name MainMenu

func _on_quit_pressed() -> void:
	NetworkManager.close_connection()
	get_tree().quit()


func _on_train_new_model_pressed() -> void:
	get_tree().change_scene_to_file("res://train_new_model_menu.tscn")
