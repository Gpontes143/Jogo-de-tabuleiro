extends Control

@onready var mao_cartas = $AreaBase/ScrollContainer/MaoCartas
#@onready var deck_visual_stack = $AreaBase/DeckContainer/PilhaVisual # Nó que conterá as "cartas falsas"
var cena_carta = preload("res://Carta.tscn")

var pontos = 0
var erros = 0

# Banco de dados com 30 cartas (10 por categoria)
var banco_de_dados = [
	# VALOR
	{"nome": "Otimizar Código", "categoria": "valor", "img": "res://sprites/valor.png"},
	{"nome": "Nova Feature", "categoria": "valor", "img": "res://sprites/valor.png"},
	# ... (adicione as outras 8 de valor)
	# NECESSARIO
	{"nome": "Daily Meeting", "categoria": "necessario", "img": "res://sprites/necessario.png"},
	# ... (adicione as outras 9 de necessario)
	# LIXO
	{"nome": "Meme de Gato", "categoria": "lixo", "img": "res://sprites/lixo.png"},
	# ... (adicione as outras 9 de lixo)
]

var estoque = {"valor": 10, "necessario": 10, "lixo": 10}

#func _ready():
	#atualizar_pilha_visual()

func puxar_carta_do_deck():
	var total_deck = estoque["valor"] + estoque["necessario"] + estoque["lixo"]
	if total_deck <= 0: return

	# Sorteio de categoria
	var cats_validas = []
	for c in estoque.keys():
		if estoque[c] > 0: cats_validas.append(c)
	
	var cat_escolhida = cats_validas.pick_random()
	var item = _buscar_item(cat_escolhida)
	
	# Criar a carta na mão
	var nova_carta = cena_carta.instantiate()
	nova_carta.texto_da_tarefa = item["nome"]
	nova_carta.categoria_correta = item["categoria"]
	nova_carta.caminho_sprite = item["img"]
	nova_carta.esta_virada = false
	
	estoque[cat_escolhida] -= 1
	mao_cartas.add_child(nova_carta)
	
	# ATUALIZA A PILHA VISUAL
	#atualizar_pilha_visual()

#func atualizar_pilha_visual():
	# Limpa a pilha visual atual
#for child in deck_visual_stack.get_children():
	#	child.queue_free()
	
#	var total_deck = estoque["valor"] + estoque["necessario"] + estoque["lixo"]
	
	# Criamos uma "sombra" de carta para cada 5 cartas no deck (para não pesar)
	# Ou 1 para cada carta se quiser precisão total (máx 30)
	var num_camadas = ceil(total_deck / 3.0) # 10 camadas visuais para 30 cartas
	
	for i in range(num_camadas):
		var camada = Panel.new()
		# Define o estilo da carta de costas
		var style = StyleBoxFlat.new()
		style.bg_color = Color("2c3e50")
		style.border_width_all = 2
		style.border_color = Color("ecf0f1")
		style.corner_radius_all = 5
		camada.add_theme_stylebox_override("panel", style)
		
		camada.custom_minimum_size = Vector2(160, 220)
		# O segredo da pilha: deslocar cada camada levemente
		camada.position = Vector2(-i * 2, -i * 2) 
		
	#	deck_visual_stack.add_child(camada)
		# Garante que a última camada (a de cima) seja o botão clicável
	#	deck_visual_stack.move_child(camada, 0)

func _buscar_item(c):
	var lista = []
	for i in banco_de_dados:
		if i["categoria"] == c: lista.append(i)
	return lista.pick_random()

# --- MÉTODOS DE PONTUAÇÃO ---
func adicionar_ponto():
	pontos += 10
	$VBoxContainer/LabelPontos.text = "Pontos: " + str(pontos)

func adicionar_erro():
	erros += 1
	$VBoxContainer/LabelErros.text = "Erros: " + str(erros)

func verificar_fim_do_jogo():
	var total_ativo = (estoque["valor"] + estoque["necessario"] + estoque["lixo"]) + mao_cartas.get_child_count()
	if total_ativo == 0:
		OS.alert("Fim de Jogo! Pontos: %d" % pontos)

func _on_deck_cartas_pressed():
	puxar_carta_do_deck()
