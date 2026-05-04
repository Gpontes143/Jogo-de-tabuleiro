extends PanelContainer

@export var texto_da_tarefa: String = ""
@export var categoria_correta: String = ""
@export var caminho_sprite: String = ""
@export var esta_virada: bool = false # Se true, mostra o verso

@onready var label = $VBoxContainer/TextoTarefa
@onready var foto_rect = $VBoxContainer/IconeTarefa

func _ready():
	configurar_visual()

func configurar_visual():
	# Define o tamanho para todas as cartas serem iguais
	custom_minimum_size = Vector2(160, 220)
	
	if esta_virada:
		# Lógica para o verso da carta (no deck)
		label.hide()
		foto_rect.hide()
		var style = get_theme_stylebox("panel").duplicate()
		style.bg_color = Color("2c3e50") # Azul escuro/cinza profissional
		style.border_width_all = 4
		style.border_color = Color("ecf0f1") # Borda clara
		add_theme_stylebox_override("panel", style)
	else:
		# Lógica para a frente da carta (na mão)
		label.show()
		foto_rect.show()
		label.text = texto_da_tarefa
		if caminho_sprite != "":
			foto_rect.texture = load(caminho_sprite)

func _get_drag_data(_at_position):
	if esta_virada: return null # Não permite arrastar do deck
	
	var preview_container = Control.new()
	var copia = self.duplicate()
	copia.position = -custom_minimum_size / 2
	copia.modulate.a = 0.7
	preview_container.add_child(copia)
	set_drag_preview(preview_container)
	return self
