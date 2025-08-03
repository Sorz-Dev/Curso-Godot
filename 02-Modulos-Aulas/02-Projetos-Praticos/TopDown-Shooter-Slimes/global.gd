extends Node #Esse é o codigo do meu global, ele esta configurado como singleton

var player_vivo = false

var pausado = true
var save_valido = false
var jogo_gerado = false

var level_altura = 156 + 2862
var level_largura = 208 + 3816

var level = 1
var level_max = 30

var vida = 40
var vida_max = 40

var armas = ["pistola", "espingarda", "metralhadora"]
var arma = armas[0]

var pistola_municao = 8
var pistola_municao_max = 8
var pistola_dano = 5

var espingarda_municao = 12
var espingarda_municao_max = 12
var espingarda_dano = 8

var metralhadora_municao = 30
var metralhadora_municao_max = 30
var metralhadora_dano = 4

var difculdade = 1 + (level * .8)
var vel_tiro = 22

var slimes_p_vivos : int = 0
var slimes_g_vivos : int = 0
var slimes_mortos : int = 0
