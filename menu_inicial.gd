extends Control


func _on_jogar_pressed() -> void:
	
	
	$clickSound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://main.tscn")


func _on_sair_pressed() -> void:
	$clickSound.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit() # No Android, isso fecha o app
	
