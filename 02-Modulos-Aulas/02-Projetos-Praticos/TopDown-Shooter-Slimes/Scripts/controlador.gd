extends Node2D 
# Esse é o meu Controlador
# Em resumo, ele é o SceneTree principal do meu jogo, todo o jogo esta dentro dele

@onready var hud_pause: CanvasLayer = $Hud_Pause
@onready var hud: CanvasLayer = $Hud
@onready var jogo: Node2D = $Jogo
@onready var reiniciar: Timer = $Reiniciar
@onready var camera: Camera2D = $Camera
@onready var fundo: TextureRect = $Jogo/Fundo
@onready var limite: Area2D = $Jogo/Limite
@onready var tamanho_limite: CollisionShape2D = $Jogo/Limite/Tamanho_Limite

@onready var projeteis: Node2D = $Jogo/Projeteis
@onready var coletaveis: Node2D = $Jogo/Coletaveis
@onready var inimigos: Node2D = $Jogo/Inimigos

@onready var jogo_cena = preload("res://Cenas/jogo.tscn")
@onready var player_cena = preload("res://Cenas/player.tscn")
@onready var slime_cena = preload("res://Cenas/slime.tscn")
@onready var zumbi_cena = preload("res://Cenas/zumbie.tscn")
@onready var pacote_vida = preload("res://Cenas/pacote_vida.tscn")
@onready var espingarda_coletavel = preload("res://Cenas/espingarda_coletavel.tscn")
@onready var metralhadora_coletavel = preload("res://Cenas/metralhadora_coletavel.tscn")

@export var apagar_save : bool

const DISTANCIA_MINIMA = 100  

var player_instance = null

func _ready() -> void:
	randomize()
	
	var config = ConfigFile.new()
	var err = config.load("res://save.cfg")
	
	if err == OK:
		global.save_valido = config.get_value("Save", "save_valido", false)
	
	if apagar_save:
		global.save_valido = false
	
	if global.save_valido:
		jogo.process_mode = PROCESS_MODE_WHEN_PAUSED
		hud.process_mode = PROCESS_MODE_WHEN_PAUSED
	
	else:
		global.level = 1
		jogo.process_mode = PROCESS_MODE_WHEN_PAUSED
		hud.process_mode = PROCESS_MODE_WHEN_PAUSED
	
	global.jogo_gerado = true
	global.save_valido = true
	salvar()
	
	gerar_fase()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if global.pausado:
			global.pausado = false
			hud_pause.process_mode = PROCESS_MODE_WHEN_PAUSED
			hud_pause.visible = false
			jogo.process_mode = PROCESS_MODE_INHERIT
			hud.process_mode = PROCESS_MODE_INHERIT
			return
		
		else:
			global.pausado = true
			hud_pause.process_mode = PROCESS_MODE_INHERIT
			hud_pause.visible = true
			jogo.process_mode = PROCESS_MODE_WHEN_PAUSED
			hud.process_mode = PROCESS_MODE_WHEN_PAUSED
			#salvar()
	
	if global.vida <= 0 and global.player_vivo:
		global.player_vivo = false
		reiniciar.start()
		global.level = 1
		player_instance.queue_free()

func salvar() -> void:
	var config = ConfigFile.new()
	config.set_value("Save", "save_valido", global.save_valido)

	config.save("res://save.cfg")

func _on_reiniciar_timeout() -> void:
	for slime in inimigos.get_children():
		slime.queue_free()
	
	randomize()
	gerar_fase()

func gerar_fase() -> void:
	# Ajustar o tamanho do fundo com base no nível
	fundo.size = Vector2(global.level_largura, global.level_altura)
	camera.limit_right = global.level_largura
	camera.limit_bottom = global.level_altura
	tamanho_limite.scale = fundo.size / 10
	tamanho_limite.position = fundo.size / 2

	# Gerar o player se ele não estiver vivo
	if not global.player_vivo:
		global.vida = global.vida_max
		player_instance = player_cena.instantiate()
		jogo.add_child(player_instance, true)
		player_instance.position = Vector2(randi_range(0, global.level_largura), randi_range(0, global.level_altura))
		camera.position = player_instance.position
		camera.cmx = player_instance.position.x
		camera.cmy = player_instance.position.y
		global.player_vivo = true
		hud.player = player_instance
	
	else:
		player_instance = $Jogo/Player
	
	# Gerar inimigos pequenos aleatoriamente
	for i in range(round(global.difculdade * 12)):
		var slime_instance = slime_cena.instantiate()
		var pos = Vector2(randi_range(0, global.level_largura), randi_range(0, global.level_altura))

		# Garantir que os inimigos não apareçam muito perto do player
		while pos.distance_to(player_instance.position) < DISTANCIA_MINIMA:
			pos = Vector2(randi_range(0, global.level_largura), randi_range(0, global.level_altura))

		slime_instance.position = pos
		slime_instance.estagio = "pequeno"
		inimigos.add_child(slime_instance, true)
		slime_instance.ajustar_estagio()
		global.slimes_p_vivos += 1
	
	# Gerar inimigos grande aleatoriamente
	for i in range(round(global.difculdade * 4)):
		var slime_instance = slime_cena.instantiate()
		var pos = Vector2(randi_range(0, global.level_largura), randi_range(0, global.level_altura))

		# Garantir que os inimigos não apareçam muito perto do player
		while pos.distance_to(player_instance.position) < DISTANCIA_MINIMA:
			pos = Vector2(randi_range(0, global.level_largura), randi_range(0, global.level_altura))

		slime_instance.position = pos
		slime_instance.estagio = "grande"
		inimigos.add_child(slime_instance, true)
		slime_instance.ajustar_estagio()
		global.slimes_g_vivos += 1
