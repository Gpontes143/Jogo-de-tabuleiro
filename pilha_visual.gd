extends Control

@export var textura_verso: Texture2D = preload("res://sprites/verso_carta.png")

func atualizar_pilha(quantidade: int):
	# Limpa as cartas visuais antigas
	for child in get_children():
		child.queue_free()
	
	if quantidade <= 0:
		return
		
	# Mostra um maço de no máximo 5 cartas para efeito visual
	var cartas_para_mostrar = min(quantidade, 15) 
	
	for i in range(cartas_para_mostrar):
		var face_falsa = TextureRect.new()
		face_falsa.texture = textura_verso
		face_falsa.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		face_falsa.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# Tamanho compacto para não ocupar espaço lateral no mousepad
		face_falsa.size = Vector2(140, 220)
		
		# O SEGREDO: Posição negativa para empilhar "para trás"
		face_falsa.position = Vector2(-i * 2, -i * 2)
		
		add_child(face_falsa)
