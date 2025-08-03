extends CanvasLayer 
# Essa é a minha Hud

@onready var vida_barra: TextureProgressBar = $Control/Vida_Barra
@onready var vida: Sprite2D = $Control/Vida
@onready var vida_texto: Label = $Control/Vida_Texto

@onready var muni_barra: TextureProgressBar = $Control/Muni_Barra
@onready var muni_texto: Label = $Control/Muni_Texto

@onready var slimes_g_vivos: Label = $Control/Slimes_G_Vivos
@onready var slimes_p_vivos: Label = $Control/Slimes_P_Vivos
@onready var slimes_mortos: Label = $Control/Slimes_Mortos

@onready var pistola: Sprite2D = $Control/Pistola
@onready var espingarda: Sprite2D = $Control/Espingarda
@onready var metralhadora: Sprite2D = $Control/Metralhadora

@onready var inimigos: Node2D = $".."/Jogo/Inimigos
@onready var player: CharacterBody2D
@onready var seta: Sprite2D = $Seta

const SUAVIZACAO_ROTACAO = 0.3

func _ready() -> void:
	vida_barra.value = 0
	vida_barra.max_value = global.vida_max * 10
	
	muni_barra.value = 0
	muni_barra.max_value = global.get(global.arma + "_municao_max") * 10
	
	global.vida = global.vida_max

func _process(_delta: float) -> void:
	mirar_seta()
	
	vida_barra.max_value = global.vida_max * 10
	muni_barra.max_value = global.get(global.arma + "_municao_max") * 10
	
	if not vida_barra.value == global.vida * 10:
		if vida_barra.value < global.vida * 10:
			vida_barra.value += 5
		elif vida_barra.value > global.vida * 10:
			vida_barra.value -= 5
	
	if not muni_barra.value == global.get(global.arma + "_municao") * 10:
		if muni_barra.value < (global.get(global.arma + "_municao") * 10):
			muni_barra.value += 2.5
		elif muni_barra.value > (global.get(global.arma + "_municao") * 10):
			muni_barra.value -= 2.5
	
	vida_texto.text = str(int(round(vida_barra.value / 10))) + "/" + str(global.vida_max)
	
	muni_texto.text = str(int(round(muni_barra.value / 10))) + "/" + str(global.get(global.arma + "_municao_max"))
	
	slimes_g_vivos.text = "Grandes: " + str(global.slimes_g_vivos)
	slimes_p_vivos.text = "Pequenos: " + str(global.slimes_p_vivos)
	slimes_mortos.text = "Mortos: " + str(global.slimes_mortos)
	
	if global.arma == "pistola":
		pistola.visible = true
		espingarda.visible = false
		metralhadora.visible = false
	
	elif global.arma == "espingarda":
		pistola.visible = false
		espingarda.visible = true
		metralhadora.visible = false
	
	elif global.arma == "metralhadora":
		pistola.visible = false
		espingarda.visible = false
		metralhadora.visible = true
	
	else:
		pistola.visible = true
		espingarda.visible = false
		metralhadora.visible = false
	

func mirar_seta() -> void:
	var distancia_menor : float
	var slime_mais_proximo : CharacterBody2D
	
	if not global.player_vivo or not player:
		seta.visible = false
		return
	
	for slime in inimigos.get_children():
		if slime.estagio == "grande":
			var distancia = player.global_position.distance_to(slime.global_position)
			if distancia < distancia_menor or distancia_menor == 0:
				distancia_menor = distancia
				slime_mais_proximo = slime
	
	if slime_mais_proximo:
		var direcao = atan2(slime_mais_proximo.global_position.y - player.global_position.y, slime_mais_proximo.global_position.x - player.global_position.x)
		seta.rotation = lerp_angle(seta.rotation, direcao, SUAVIZACAO_ROTACAO)
		seta.visible = true
	else:
		seta.visible = false  # Se não houver slimes grandes, a seta fica invisível
