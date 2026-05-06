extends Control


func _on_jogar_pressed() -> void:
	# Mude "res://main.tscn" para o caminho da sua cena de jogo
	get_tree().change_scene_to_file("res://main.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit() # No Android, isso fecha o app
