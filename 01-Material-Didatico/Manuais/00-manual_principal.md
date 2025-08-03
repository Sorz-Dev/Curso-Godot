# Manual Principal - Template Top-Down

Este documento descreve a arquitetura central do template de jogo Top-Down 2D, focando no jogador, mundo do jogo e interações fundamentais.

## 1. Estrutura de Arquivos Sugerida

```
topdown_template/
|-- scenes/
|   |-- player/
|   |   |-- player.tscn
|   |-- levels/
|   |   |-- level_01.tscn
|   |-- ui/
|   |   |-- main_menu.tscn
|   |   |-- options_menu.tscn
|   |   |-- pause_menu.tscn
|   |   |-- game_hud.tscn
|   |   |-- save_load_menu.tscn
|-- scripts/
|   |-- player/
|   |   |-- player.gd
|   |   |-- player_state_machine.gd
|   |-- core/
|   |   |-- globals.gd (Autoload)
|   |   |-- scene_manager.gd (Autoload)
|   |   |-- save_manager.gd (Autoload)
|   |   |-- settings_manager.gd (Autoload)
|   |   |-- audio_manager.gd (Autoload)
|   |-- systems/
|   |   |-- inventory_system.gd
|   |   |-- dialogue_system.gd
|   |-- ui/
|   |   |-- ... (scripts para cada cena de UI)
|-- assets/
|   |-- sprites/
|   |   |-- player/ (spritesheets de animação)
|   |-- sfx/
|   |-- music/
|   |-- fonts/
|-- translations/
|   |-- en.po
|   |-- pt_BR.po
```

## 2. Cena do Jogador (`player.tscn`)

O jogador é um `CharacterBody2D` com uma estrutura de nós projetada para movimentação em 8 direções e interação.

- **Nó Raiz:** `Player` (CharacterBody2D)
  - **Script:** `player.gd`
  - **Propósito:** Controla a física, dados do jogador (vida, etc.) e delega o estado para a StateMachine.
- **Nós Filhos:**
  - `AnimatedSprite2D`: Gerencia as animações visuais (parado, andando para cada direção).
  - `CollisionShape2D`: Define a cápsula de colisão principal do jogador.
  - `Camera2D`: Câmera que segue o jogador. Pode ter limites (`limit_smoothed`) e suavização (`smoothing_enabled`) ativados.
  - `StateMachine`: Nó que gerencia os estados do jogador.
    - **Script:** `player_state_machine.gd`
    - **Nós Filhos (Estados):** `Idle`, `Move`, `Attack`, `Hurt`, etc. (cada um é um `Node` com seu próprio script de estado).
  - `Hurtbox` (Area2D): Área que detecta quando o jogador é atingido por um ataque inimigo.
    - `CollisionShape2D`
  - `Hitbox` (Area2D): Área que detecta quando o jogador atinge um inimigo (usado para ataques).
    - `CollisionShape2D` (geralmente desativado e ativado apenas durante a animação de ataque).

### 2.1. Script do Jogador (`player.gd`)

- **Variáveis Exportadas:**
  - `@export var stats: CharacterStats`: O Recurso contendo todos os dados base do jogador.
- **Variáveis:**
  - `current_health`: Vida atual. Inicializada com `stats.max_health` no `_ready`.
  - `input_direction`: Vetor normalizado da direção do input.
  - `state_machine`: Referência ao nó da máquina de estados.
- **Sinais:**
  - `health_changed(current_health, max_health)`: Emitido quando a vida muda, para a HUD atualizar.
  - `died()`: Emitido quando a vida chega a zero.
- **Funções Principais:**
  - `_ready()`:
    - `current_health = stats.max_health`
    - Obtém a referência da `state_machine`.
  - `_process(delta)`:
    - Chama `get_input()` para ler as teclas de movimento.
    - Chama `state_machine.process(delta)`.
  - `_physics_process(delta)`:
    - Define `velocity` com base no `input_direction` e `stats.move_speed`.
    - Executa o movimento: `move_and_slide()`.
  - `get_input()`:
    - Usa `Input.get_vector()` para obter a direção de movimento.
  - `take_damage(attack_data)`:
    - Calcula o dano final: `var final_damage = attack_data.get("damage", 0) - stats.defense`.
    - Reduz `current_health`.
    - Emite `health_changed`.
    - Muda o estado para `Hurt`.
    - Se a vida for <= 0, emite `died`.

### 2.2. Máquina de Estados (`player_state_machine.gd`)

- **Lógica:**
  - Mantém uma referência ao estado atual.
  - A cada frame, chama o método `process()` do estado ativo.
  - Fornece uma função `transition_to(state_name)` que:
    - Chama o método `exit()` do estado atual (se houver).
    - Encontra o novo nó de estado pelo nome.
    - Chama o método `enter()` do novo estado.
- **Scripts de Estado (ex: `move.gd`):**
  - Herdam de uma classe base `State.gd`.
  - `enter()`: Chamado ao entrar no estado.
  - `process(delta)`: Lógica do estado a cada frame (ex: atualizar animação com base no `input_direction`, verificar se o input parou para transicionar para `Idle`).
  - `exit()`: Chamado ao sair do estado.

## 3. Cena de Nível (`level_01.tscn`)

- **Nó Raiz:** `Level01` (Node2D)
- **Nós Filhos:**
  - `TileMap`: Para construção do cenário (chão, paredes, obstáculos).
    - Deve ter uma camada de física configurada para colisão.
    - Pode usar `YSort` para lidar com a ordem de renderização de objetos.
  - `Player`: Instância da cena `player.tscn`.
  - `Enemies` (Node2D): Contêiner para instâncias de inimigos.
  - `Collectibles` (Node2D): Contêiner para itens coletáveis.
  - `GameHUD`: Instância da cena `game_hud.tscn`.
  - `PauseMenu`: Instância da cena `pause_menu.tscn` (invisível por padrão).

## 4. HUD do Jogo (`game_hud.tscn`)

- **Nó Raiz:** `GameHUD` (CanvasLayer)
- **Estrutura:**
  - `MarginContainer`
    - `HBoxContainer` (ou `VBoxContainer`)
      - `HealthBar` (TextureProgressBar): Barra de vida.
        - **Script:** Conecta-se ao sinal `health_changed` do jogador para se atualizar.
      - `SpeedrunTimerLabel` (Label): Visível apenas se o modo Speedrun estiver ativo (`SettingsManager.is_speedrun_mode()`).
        - **Script:** Atualiza seu texto a cada frame com o tempo do jogo.

## 5. Câmera (`Camera2D`)

- **Funcionalidades:**
  - **Suavização:** `smoothing_enabled = true` para um movimento mais suave.
  - **Limites:** Use as propriedades `limit_left`, `limit_top`, `limit_right`, `limit_bottom` para restringir a câmera aos limites do nível. Isso impede que a câmera mostre áreas fora do mapa.
