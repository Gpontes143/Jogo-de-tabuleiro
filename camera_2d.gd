extends Camera2D

var shake_intensity = 0.0
var shake_fade = 15.0 # Rapidez com que o tremor para

func _ready():
	# Garante que a câmera comece zerada
	offset = Vector2.ZERO

func _process(delta):
	if shake_intensity > 0:
		# Aplica um deslocamento aleatório baseado na intensidade
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		# Suaviza a intensidade ao longo do tempo
		shake_intensity = lerp(shake_intensity, 0.0, shake_fade * delta)
	else:
		offset = Vector2.ZERO

# Função que você chamará do seu script principal
func aplicar_shake(forca: float):
	shake_intensity = forca
