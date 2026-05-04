extends PanelContainer

@export_enum("valor", "necessario", "lixo") var tipo_aceito: String = "valor"

func _can_drop_data(_at_position, data):
	return data is Control and "categoria_correta" in data

func _drop_data(_at_position, data):
	var main = get_tree().root.get_node("Main")
	if data.categoria_correta == tipo_aceito:
		main.adicionar_ponto()
	else:
		main.adicionar_erro()
	
	data.queue_free()
	await get_tree().process_frame
	main.verificar_fim_do_jogo()
