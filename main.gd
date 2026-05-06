extends Node

# --- REFERÊNCIAS ---
@onready var mao_cartas = $EstacaoCompleta/AreaBase/ScrollContainer/MaoCartas
@onready var pilha_visual = $EstacaoCompleta/AreaBase/DeckContainer/PilhaVisual
@onready var botao_deck = $EstacaoCompleta/AreaBase/DeckContainer/DeckCartas
@onready var label_deck = $EstacaoCompleta/AreaBase/DeckContainer/DeckCartas/Label

@onready var label_pontos = $PanelContainer/BoxPontuacao/LabelPontos
@onready var label_erros = $PanelContainer/BoxPontuacao/LabelErros
@onready var label_acertos = $PanelContainer/BoxPontuacao/LabelAcertos

# --- RECURSOS ---
var cena_carta = preload("res://Carta.tscn")

# --- VARIÁVEIS ---
var pontos = 0
var total_acertos = 0
var total_erros = 0
var combo_atual = 0

var stats = {
	"valor": {"acertos": 0, "erros": 0},
	"necessário": {"acertos": 0, "erros": 0},
	"lixo": {"acertos": 0, "erros": 0}
}

var banco_de_dados = [
	# CATEGORIA: VALOR (10)
	{"nome": "Código sistema elétrico", "categoria": "valor"},
	{"nome": "Nova Feature API", "categoria": "valor"},
	{"nome": "Teste Feature API", "categoria": "valor"},
	{"nome": "Teste Hardware e software", "categoria": "valor"},
	{"nome": "Documentação Técnica", "categoria": "valor"},
	{"nome": "Fix de Bug Crítico", "categoria": "valor"},
	{"nome": "Melhoria de Hardware e software", "categoria": "valor"},
	{"nome": "Review de Código", "categoria": "valor"},
	{"nome": "Fabricação cerveja", "categoria": "valor"}, 
	{"nome": "Análise de Dados", "categoria": "valor"},

	# CATEGORIA: NECESSARIO (10)
	{"nome": "Reunião semanal", "categoria": "necessário"},
	{"nome": "Responder Slack", "categoria": "necessário"},
	{"nome": "Planejamento Semanal", "categoria": "necessário"},
	{"nome": "Aulas de projeto", "categoria": "necessário"},
	{"nome": "Otimizar Software", "categoria": "necessário"},
	{"nome": "Atualizar etapas", "categoria": "necessário"},
	{"nome": "Preencher Specs", "categoria": "necessário"},
	{"nome": "Manutenção do Hardware", "categoria": "necessário"}, 
	{"nome": "Melhoria de UI", "categoria": "necessário"},
	{"nome": "Backup de Firmware", "categoria": "necessário"}, 

	# CATEGORIA: LIXO (10)
	{"nome": "Corrente de E-mail", "categoria": "lixo"},
	{"nome": "Reunião sem Pauta", "categoria": "lixo"},
	{"nome": "Spam no Inbox", "categoria": "lixo"},
	{"nome": "Meme no Canal Geral", "categoria": "lixo"},
	{"nome": "Discussão de sem pautas", "categoria": "lixo"},
	{"nome": "Notificações de Social Media", "categoria": "lixo"},
	{"nome": "Tarefa Duplicada", "categoria": "lixo"},
	{"nome": "Burocracia Inútil", "categoria": "lixo"},
	{"nome": "Navegação Aleatória", "categoria": "lixo"},
	{"nome": "Ideias sem utilidades praticas", "categoria": "lixo"}
]
var baralho = [] 

func _ready():
	randomize()
	baralho = banco_de_dados.duplicate()
	baralho.shuffle()
	_atualizar_estado_do_deck()

# --- LOGICA DO DECK ---
func _atualizar_estado_do_deck():
	if label_deck: 
		label_deck.text = str(baralho.size())
	
	if baralho.is_empty():
		botao_deck.hide()
	else:
		botao_deck.show()
	
	pilha_visual.atualizar_pilha(baralho.size())

func puxar_carta_do_deck():
	if mao_cartas.get_child_count() >= 5 or baralho.is_empty():
		return
		
	var item = baralho.pop_front()
	var nova_carta = cena_carta.instantiate()
	nova_carta.texto_da_tarefa = item["nome"]
	nova_carta.categoria_correta = item["categoria"]
	
	mao_cartas.add_child(nova_carta)
	animar_entrada(nova_carta)
	_atualizar_estado_do_deck()

func animar_entrada(carta):
	carta.modulate.a = 0
	var pos_final = carta.position
	carta.position.y += 150
	var tween = create_tween().set_parallel(true)
	tween.tween_property(carta, "position:y", pos_final.y, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(carta, "modulate:a", 1.0, 0.3)

func _on_deck_cartas_pressed():
	puxar_carta_do_deck()

# --- PONTOS E REGRAS ---
func adicionar_ponto_detalhado(categoria: String):
	total_acertos += 1
	combo_atual += 1
	stats[categoria]["acertos"] += 1
	var bonus = 5 if combo_atual >= 3 else 0
	pontos += (10 + bonus)
	_atualizar_ui()
	_animar_label(label_pontos, Color.GREEN)

func adicionar_erro_detalhado(categoria_da_carta: String):
	total_erros += 1
	combo_atual = 0
	stats[categoria_da_carta]["erros"] += 1
	_atualizar_ui()
	_animar_label(label_erros, Color.RED)

func _atualizar_ui():
	if label_pontos: label_pontos.text = "Pontos: " + str(pontos)
	if label_acertos: label_acertos.text = "Acertos: " + str(total_acertos)
	if label_erros: label_erros.text = "Erros: " + str(total_erros)

func verificar_fim_do_jogo():
	await get_tree().create_timer(0.1).timeout
	if baralho.is_empty() and mao_cartas.get_child_count() == 0:
		exibir_relatorio()

func exibir_relatorio():
	var msg = "RELATÓRIO DE PRODUÇÃO\n\n"
	msg += "PONTOS: %d | ACERTOS: %d | ERROS: %d\n" % [pontos, total_acertos, total_erros]
	msg += "--------------------------\n"
	for cat in stats.keys():
		msg += "%s: %d Ac | %d Er\n" % [cat.capitalize(), stats[cat]["acertos"], stats[cat]["erros"]]
	OS.alert(msg, "Fim da Partida")
	jogo_terminou()
func jogo_terminou():
	# Espera um tempinho para o jogador ver o resultado (opcional)
	await get_tree().create_timer(5.0).timeout
	
	# Volta para a cena do menu
	get_tree().change_scene_to_file("res://menu_inicial.tscn")
func _animar_label(label: Label, cor: Color):
	if not label: return
	label.pivot_offset = label.size / 2 
	var tween = create_tween()
	label.modulate = cor
	label.scale = Vector2(1.3, 1.3) 
	tween.tween_property(label, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(label, "modulate", Color.WHITE, 0.3)
