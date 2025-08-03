# Manual de UI (Interface do Usuário)

Este documento detalha a estrutura e funcionalidade de todas as cenas de UI do template.

## 1. Estrutura Geral

Toda cena de UI principal (menus, HUD) deve ser um `CanvasLayer` para garantir que seja renderizada sobre o jogo e não seja afetada pela câmera do mundo. Menus de confirmação ou pop-ups podem ser nós `Control` dentro de outras cenas de UI.

---

## 2. Menu Principal (`main_menu.tscn`)

A porta de entrada do jogo.

- **Nó Raiz:** `MainMenu` (CanvasLayer)
- **Estrutura:**
  - `MarginContainer`
    - `VBoxContainer`
      - `TitleLabel` (Label)
      - `NewGameButton` (Button)
      - `LoadGameButton` (Button)
      - `OptionsButton` (Button)
      - `QuitButton` (Button)
- **Script (`main_menu.gd`):**
  - `_on_new_game_button_pressed()`: Chama `SceneManager.change_scene("res://scenes/levels/level_01.tscn")`. Antes disso, pode chamar `Global.reset_game_state()`.
  - `_on_load_game_button_pressed()`: Mostra a cena `save_load_menu.tscn` no modo "carregar". Pode ser uma cena separada ou um pop-up.
  - `_on_options_button_pressed()`: Mostra a cena `options_menu.tscn`.
  - `_on_quit_button_pressed()`: Chama `get_tree().quit()`.

---

## 3. Tela de Opções (`options_menu.tscn`)

Um menu complexo com múltiplas abas para todas as configurações do jogo.

- **Nó Raiz:** `OptionsMenu` (CanvasLayer)
- **Estrutura:**
  - `TabContainer`: Para separar as diferentes categorias de opções.
    - **Tab 1: Gráficos** (`Control`)
      - `ResolutionOptionButton`: Lista resoluções de tela.
      - `VSyncCheckBox`: Ativa/desativa VSync.
      - `UpscalingOptionButton`: Lista opções (DLSS, FSR, RSR, Nenhum).
    - **Tab 2: Áudio** (`Control`)
      - `MasterVolumeSlider` (HSlider)
      - `MusicVolumeSlider` (HSlider)
      - `SFXVolumeSlider` (HSlider)
    - **Tab 3: Controles** (`Control`)
      - `ScrollContainer`
        - `VBoxContainer`
          - `HBoxContainer` (para cada ação remapeável)
            - `ActionLabel` (Label): "Pular", "Atacar", etc.
            - `KeyboardRemapButton` (Button)
            - `MouseRemapButton` (Button)
            - `GamepadRemapButton` (Button)
    - **Tab 4: Jogo** (`Control`)
      - `LanguageOptionButton`: Lista os idiomas (`.po`) disponíveis.
      - `SpeedrunModeCheckBox`: Ativa/desativa o timer de speedrun.
  - `BackButton` (Button): Para voltar ao menu anterior.
- **Script (`options_menu.gd`):**
  - `_ready()`:
    - Carrega os valores atuais do `SettingsManager` e popula todos os controles (sliders, checkboxes, etc.).
    - Popula `ResolutionOptionButton` com as resoluções disponíveis.
    - Popula `LanguageOptionButton` com os locales do `TranslationServer`.
    - Popula a lista de remapeamento de controles.
  - **Funções de Sinal:**
    - Conecta o sinal de cada controle (ex: `value_changed` para sliders, `toggled` para checkboxes) a uma função.
    - Cada função chama `SettingsManager.set_setting("chave_da_config", novo_valor)`.
  - **Lógica de Remapeamento:**
    - Ao clicar em um botão de remapeamento (ex: `KeyboardRemapButton`):
      1.  Muda o texto do botão para "Pressione uma tecla...".
      2.  Pausa o processamento de outros inputs.
      3.  No `_input(event)`, captura o próximo evento de teclado/mouse/gamepad.
      4.  Chama `SettingsManager.set_setting("remap_pular_teclado", event)`.
      5.  Atualiza o texto do botão com o novo mapeamento.
      6.  Retoma o processamento normal.

---

## 4. Menu de Pause (`pause_menu.tscn`)

Aparece sobre a tela do jogo quando pausado.

- **Nó Raiz:** `PauseMenu` (CanvasLayer)
  - `process_mode` deve ser `PROCESS_MODE_ALWAYS` para funcionar quando o jogo está pausado.
- **Estrutura:**
  - `ColorRect` (com cor semi-transparente para escurecer o fundo)
  - `VBoxContainer`
    - `ResumeButton` (Button)
    - `OptionsButton` (Button)
    - `MainMenuButton` (Button)
- **Script (`pause_menu.gd`):**
  - `_input(event)`: Detecta a ação "pause" para se mostrar/esconder.
  - `show()`:
    - `get_tree().paused = true`
    - `visible = true`
  - `hide()`:
    - `get_tree().paused = false`
    - `visible = false`
  - `_on_resume_button_pressed()`: Chama `hide()`.
  - `_on_options_button_pressed()`: Mostra a cena `options_menu.tscn`.
  - `_on_main_menu_button_pressed()`: Despausa o jogo (`get_tree().paused = false`) e chama `SceneManager.change_scene("res://scenes/ui/main_menu.tscn")`.

---

## 5. HUD do Jogo (`game_hud.tscn`)

Interface exibida durante o gameplay.

- **Nó Raiz:** `GameHUD` (CanvasLayer)
- **Estrutura:**
  - `MarginContainer`
    - `HealthBar` (TextureProgressBar)
    - `SpeedrunTimerLabel` (Label)
- **Script (`game_hud.gd`):**
  - `_ready()`:
    - Conecta-se aos sinais relevantes do jogador (ex: `player.health_changed`).
    - Verifica `SettingsManager.get_setting("speedrun_mode", false)` para decidir se mostra o timer.
  - `_process(delta)`:
    - Se o modo speedrun estiver ativo, atualiza o `SpeedrunTimerLabel` com o tempo de jogo (`Global.game_time`).
  - `_on_player_health_changed(current, max)`:
    - `health_bar.max_value = max`
    - `health_bar.value = current`

---

## 6. Menu de Save/Load (`save_load_menu.tscn`)

Interface para gerenciar múltiplos slots de save.

- **Ver:** `manual_save_load.md` para a documentação completa.
