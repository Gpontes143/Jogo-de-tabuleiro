extends Control

# Referências aos nós internos
@onready var label_texto = $FundoCarta/MarginContainer/TextoTarefa
@onready var fundo_visual = $FundoCarta # O TextureRect com a sua arte nova

var texto_da_tarefa: String = ""
var categoria_correta: String = ""

func _ready():
	# Aplica o texto da tarefa na frente da carta
	if label_texto:
		label_texto.text = texto_da_tarefa
		label_texto.autowrap_mode = TextServer.AUTOWRAP_WORD
		label_texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

# --- LÓGICA DE ARRASTAR ---
func _get_drag_data(_at_position):
	var preview = self.duplicate()
	preview.modulate.a = 0.7
	preview.scale = Vector2(1.1, 1.1)
	
	var c = Control.new()
	c.add_child(preview)
	preview.position = -self.size / 2
	set_drag_preview(c)
	
	self.visible = false 
	return self

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not is_queued_for_deletion():
			self.visible = true
