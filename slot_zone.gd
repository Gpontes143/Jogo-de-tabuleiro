extends Control

# Esta variável vai aparecer no Inspetor do Godot para você configurar cada zona!
@export var categoria_esperada: String = ""

# --- SISTEMA DE DRAG AND DROP (RECEBE A CARTA) ---

# Função que o Godot roda quando algo passa por cima desta zona
func _can_drop_data(_at_position, data):
	# Só acende/aceita o drop se o objeto arrastado for uma carta válida 
	if typeof(data) == TYPE_OBJECT and "categoria_correta" in data:
		return true
	return false

# Função que o Godot roda quando o jogador SOLTA o clique do mouse aqui
func _drop_data(_at_position, data):
	var main_scene = get_tree().current_scene
	
	if data.categoria_correta == categoria_esperada:
		# Envia a categoria para contar o acerto nela
		main_scene.adicionar_ponto_detalhado(data.categoria_correta)
	else:
		# Envia a categoria da carta para contar o erro nela
		main_scene.adicionar_erro_detalhado(data.categoria_correta)
		
	data.queue_free()
	main_scene.verificar_fim_do_jogo()
