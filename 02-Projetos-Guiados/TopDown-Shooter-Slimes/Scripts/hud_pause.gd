extends CanvasLayer
# Esse é meu Hud_Pause

@onready var hud: CanvasLayer = $"../Hud"
@onready var start: Button = $Start
@onready var exit: Button = $Exit

var jogo : Node2D

var camera : Camera2D

var selecionado = 3
var confirmado = false

func _process(_delta: float) -> void:
	if global.jogo_gerado:
		jogo = $"/root/Controlador/Jogo"
		global.jogo_gerado = false
	
	if Input.is_action_just_pressed("up"):
		selecionado += 1
		if selecionado > 2:
			selecionado = 1
	
	if Input.is_action_just_pressed("down"):
		selecionado -= 1
		if selecionado < 1:
			selecionado = 2
	
	if Input.is_action_just_pressed("confirmar"):
		confirmado = true
	
	if selecionado == 1:
		start.self_modulate.r = 1
		start.self_modulate.g = 0.9
		start.self_modulate.b = 0
		
		exit.self_modulate.r = 1
		exit.self_modulate.g = 1
		exit.self_modulate.b = 1
		
		if confirmado:
			visible = false
			global.pausado = false
			jogo.process_mode = PROCESS_MODE_INHERIT
			hud.process_mode = PROCESS_MODE_INHERIT
	
	if selecionado == 2:
		start.self_modulate.r = 1
		start.self_modulate.g = 1
		start.self_modulate.b = 1
		
		exit.self_modulate.r = 1
		exit.self_modulate.g = 0.9
		exit.self_modulate.b = 0
		
		if confirmado:
			get_tree().quit()
	
	if selecionado == 3:
		start.self_modulate.r = 1
		start.self_modulate.g = 1
		start.self_modulate.b = 1
		
		exit.self_modulate.r = 1
		exit.self_modulate.g = 1
		exit.self_modulate.b = 1
		
		confirmado = false

func _on_start_pressed() -> void:
	confirmado = true

func _on_start_mouse_entered() -> void:
	selecionado = 1

func _on_start_mouse_exited() -> void:
	selecionado = 3

func _on_exit_pressed() -> void:
	confirmado = true

func _on_exit_mouse_entered() -> void:
	selecionado = 2

func _on_exit_mouse_exited() -> void:
	selecionado = 3
