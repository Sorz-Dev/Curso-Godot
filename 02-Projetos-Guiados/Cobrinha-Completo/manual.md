# Manual de Implementação Detalhada - Cobrinha Avançado

Este documento é a especificação técnica completa para a criação de um jogo da Cobrinha avançado e polido em Godot. Siga-o à risca para implementar a arquitetura projetada.

## 1. Estrutura de Arquivos Final

```
cobrinha_avancado/
|-- scenes/
|   |-- main/
|   |   |-- main_menu.tscn
|   |   |-- game.tscn
|   |   |-- options_menu.tscn
|   |   |-- skin_selection.tscn
|   |-- components/
|   |   |-- snake.tscn
|   |   |-- food.tscn
|   |-- ui/
|       |-- game_hud.tscn
|       |-- pause_menu.tscn
|       |-- game_over_screen.tscn
|-- scripts/
|   |-- main/
|   |   |-- main_menu.gd
|   |   |-- game.gd
|   |   |-- options_menu.gd
|   |   |-- skin_selection.gd
|   |-- components/
|   |   |-- snake.gd
|   |   |-- food.gd
|   |-- resources/
|   |   |-- FoodData.gd
|   |   |-- LevelData.gd
|   |   |-- SnakeSkin.gd
|   |-- ui/
|   |   |-- game_hud.gd
|   |   |-- pause_menu.gd
|   |   |-- game_over_screen.gd
|-- resources/
|   |-- food_data/
|   |   |-- apple.tres
|   |   |-- golden_cherry.tres
|   |   |-- ice_cube.tres
|   |-- level_data/
|   |   |-- classic_level.tres
|   |-- skin_data/
|       |-- default.tres
|       |-- fire.tres
|-- autoload/
|   |-- GameManager.gd
|   |-- SceneManager.gd
|   |-- SettingsManager.gd
|   |-- AudioManager.gd
|   |-- VFXManager.gd
|-- assets/
|   |-- fonts/
|   |-- sprites/
|   |-- audio/
|       |-- music/
|       |-- sfx/
```

## 2. Configuração do Projeto

### 2.1. Autoloads (Singletons)
Vá em `Projeto > Configurações do Projeto > Autoload` e adicione:
1.  `GameManager`: `res://autoload/GameManager.gd`
2.  `SceneManager`: `res://autoload/SceneManager.gd`
3.  `SettingsManager`: `res://autoload/SettingsManager.gd`
4.  `AudioManager`: `res://autoload/AudioManager.gd`
5.  `VFXManager`: `res://autoload/VFXManager.gd`

### 2.2. Input Map
Vá em `Projeto > Configurações do Projeto > Mapa de Input` e adicione as ações:
- `move_up`: W, Seta para Cima
- `move_down`: S, Seta para Baixo
- `move_left`: A, Seta para Esquerda
- `move_right`: D, Seta para Direita
- `pause`: Escape, P
- `ui_accept`: Enter, Espaço

### 2.3. Audio Buses
Vá na aba `Áudio` e crie dois novos buses: `Music` e `SFX`. Deixe ambos rotearem para o bus `Master`.

## 3. Scripts de Resources

Crie os seguintes scripts na pasta `scripts/resources/`.

### 3.1. `FoodData.gd`
```gdscript
# res://scripts/resources/FoodData.gd
class_name FoodData
extends Resource

enum Effect { NONE, SPEED_UP, SLOW_DOWN, SCORE_MULTIPLIER }

@export var sprite: Texture2D
@export var points: int = 10
@export var effect: Effect = Effect.NONE
@export var effect_duration: float = 5.0
@export var sfx_on_eat: AudioStream
```

### 3.2. `LevelData.gd`
```gdscript
# res://scripts/resources/LevelData.gd
class_name LevelData
extends Resource

@export var level_name: String
@export var background_texture: Texture2D
@export var music_track: AudioStream
@export var obstacle_tilemap_scene: PackedScene
@export var available_foods: Array[FoodData]
@export var grid_size: Vector2i = Vector2i(40, 22)
@export var cell_size: int = 32
```

### 3.3. `SnakeSkin.gd`
```gdscript
# res://scripts/resources/SnakeSkin.gd
class_name SnakeSkin
extends Resource

@export var skin_name: String
@export var head_texture: Texture2D
@export var body_texture: Texture2D
@export var body_colors: Array[Color]
@export var unlock_cost: int = 100
@export var is_unlocked_by_default: bool = false
```

## 4. Cenas e Scripts Detalhados

### 4.1. `game.tscn`
- **Nó Raiz:** `Game` (Node2D)
  - **Script:** `res://scripts/main/game.gd`
- **Estrutura de Nós:**
  - `Background` (TextureRect)
  - `Camera2D`
  - `GridContainer` (Node2D)
    - `ObstacleLayer` (Node2D)
    - `FoodContainer` (Node2D)
    - `Snake` (Instância de `snake.tscn`)
  - `MoveTimer` (Timer)
  - `GameTimer` (Timer)
  - `EffectTimer` (Timer)
  - `UI_Layer` (CanvasLayer)
    - `GameHUD` (Instância de `game_hud.tscn`)
    - `PauseMenu` (Instância de `pause_menu.tscn`, `visible = false`)
    - `GameOverScreen` (Instância de `game_over_screen.tscn`, `visible = false`)

- **Script `game.gd`:**
  - **Sinais:** `score_updated(score)`, `time_updated(time)`
  - **Variáveis:** `level_data`, `score`, `time`, `is_paused`, `is_game_over`.
  - **Funções:**
    - `_ready()`: Carrega `level_data` do `GameManager`. Configura o background e obstáculos. Conecta sinais. Chama `start_new_game()`.
    - `_input(event)`: Ouve `pause` para chamar `toggle_pause()`.
    - `start_new_game()`: Reseta variáveis, HUD, `Snake`, e timers. Chama `spawn_food()`.
    - `toggle_pause()`: Pausa/despausa `get_tree()`, mostra/esconde `PauseMenu`.
    - `spawn_food()`: Instancia `food.tscn`, escolhe um `FoodData` aleatório, e o posiciona.
    - `game_over()`: Para timers, mostra `GameOverScreen`, salva pontuação via `GameManager`.
    - `_on_snake_ate_food(food_data)`: Aumenta `score`, emite `score_updated`, chama `snake.grow()`, `spawn_food()`, e aplica efeitos se houver.
    - `_on_snake_died()`: Chama `game_over()`.
    - `_on_move_timer_timeout()`: Chama `snake.move()`.
    - `_on_game_timer_timeout()`: Incrementa `time`, emite `time_updated`.
    - `_on_effect_timer_timeout()`: Reverte o efeito de power-up (ex: normaliza a velocidade).
- **Conexões de Sinais (no Editor):**
  - `MoveTimer.timeout -> self._on_move_timer_timeout`
  - `GameTimer.timeout -> self._on_game_timer_timeout`
  - `EffectTimer.timeout -> self._on_effect_timer_timeout`
  - `Snake.ate_food -> self._on_snake_ate_food`
  - `Snake.died -> self._on_snake_died`
  - `PauseMenu.resume_pressed -> self.toggle_pause`
  - `GameOverScreen.restart_pressed -> self.start_new_game`

### 4.2. `snake.tscn`
- **Nó Raiz:** `Snake` (Node2D)
  - **Script:** `res://scripts/components/snake.gd`
- **Estrutura de Nós:**
  - `Head` (Sprite2D)
  - `BodyContainer` (Node2D)
- **Script `snake.gd`:**
  - **Sinais:** `ate_food(food_data: FoodData)`, `died`.
  - **Variáveis:** `direction`, `next_direction`, `body_parts: Array[Sprite2D]`, `cell_size`.
  - **Funções:**
    - `_input(event)`: Atualiza `next_direction` com base nas ações `move_*`.
    - `reset()`: Limpa o corpo e reseta a posição/direção.
    - `move()`: Atualiza a direção, move a cabeça e os segmentos do corpo.
    - `grow()`: Adiciona um novo segmento ao corpo.
    - `check_collision()`: Verifica colisão com obstáculos e com o próprio corpo. Retorna `true` se houver colisão.
    - `_physics_process(delta)`: Verifica colisão com `Area2D` de comida.
- **Conexões de Sinais:** Nenhuma no editor, todas via código.

### 4.3. `game_hud.tscn`
- **Nó Raiz:** `GameHUD` (Control)
  - **Script:** `res://scripts/ui/game_hud.gd`
- **Estrutura de Nós:**
  - `MarginContainer`
    - `HBoxContainer`
      - `ScoreLabel` (Label)
      - `TimeLabel` (Label)
- **Script `game_hud.gd`:**
  - **Funções:**
    - `set_score(value)`: Atualiza `ScoreLabel`.
    - `set_time(value)`: Atualiza `TimeLabel`.
- **Conexões de Sinais (no `game.tscn`):**
  - `Game.score_updated -> GameHUD.set_score`
  - `Game.time_updated -> GameHUD.set_time`

---
Este manual agora serve como uma planta baixa técnica e detalhada. A implementação de cada Autoload e das demais cenas de UI (menus, etc.) seguirá este mesmo nível de detalhe quando solicitado.
