# Manual de Sistemas Globais (Autoloads)

Este documento detalha a arquitetura dos scripts singletons (Autoloads) que gerenciam o estado e os sistemas globais do jogo. Eles são acessíveis de qualquer lugar do projeto.

## 1. Configuração (Project > Project Settings > Autoload)

1.  **Global**: `res://scripts/core/globals.gd`
2.  **SceneManager**: `res://scripts/core/scene_manager.gd`
3.  **SettingsManager**: `res://scripts/core/settings_manager.gd`
4.  **SaveManager**: `res://scripts/core/save_manager.gd`
5.  **AudioManager**: `res://scripts/core/audio_manager.gd`

---

## 2. Global.gd

Um script para armazenar variáveis e dados globais que não se encaixam em outros gerenciadores.

- **Propósito:** Conter dados de estado do jogo que precisam ser acessados ou modificados por múltiplas cenas.
- **Exemplo de Variáveis:**
  - `player_data`: Um dicionário ou recurso customizado contendo informações que persistem entre as cenas (ex: vida atual, itens chave, etc.).
  - `game_time`: Tempo total de jogo, para saves e estatísticas.
- **Funções:**
  - `reset_game_state()`: Reseta todas as variáveis para um novo jogo.

---

## 3. SceneManager.gd

Gerencia a transição entre as cenas do jogo.

- **Nó Raiz:** `SceneManager` (Node)
- **Propósito:** Centralizar a lógica de carregamento e descarregamento de cenas para evitar código duplicado e gerenciar transições.
- **Variáveis:**
  - `current_scene`: Referência à cena atualmente ativa.
- **Funções:**
  - `change_scene(scene_path: String)`:
    1.  Pega a árvore de cenas: `get_tree()`.
    2.  (Opcional) Inicia uma animação de fade-out (ex: usando um `ColorRect` e `AnimationPlayer` dentro do `SceneManager`).
    3.  Aguarda a animação terminar.
    4.  Libera a cena atual: `current_scene.queue_free()`.
    5.  Carrega a nova cena: `var next_scene_res = load(scene_path)`.
    6.  Instancia a nova cena: `current_scene = next_scene_res.instantiate()`.
    7.  Adiciona a nova cena à árvore: `get_tree().root.add_child(current_scene)`.
    8.  (Opcional) Inicia uma animação de fade-in.
  - `get_current_scene_path() -> String`: Retorna o caminho da cena atual. Útil para o `SaveManager`.

---

## 4. SettingsManager.gd

Gerencia todas as configurações do jogador (gráficos, áudio, controles).

- **Nó Raiz:** `SettingsManager` (Node)
- **Propósito:** Carregar, aplicar e salvar as preferências do jogador.
- **Constantes:**
  - `SETTINGS_FILE_PATH = "user://settings.json"`
- **Variáveis:**
  - `settings`: Um dicionário contendo todas as configurações.
- **Sinais:**
  - `settings_changed()`: Emitido sempre que uma configuração é alterada, para que a UI ou outros sistemas possam reagir.
- **Funções:**
  - `_ready()`: Chama `load_settings()`.
  - `load_settings()`:
    - Verifica se `SETTINGS_FILE_PATH` existe.
    - Se sim, carrega o JSON, o converte para um dicionário e o armazena em `settings`.
    - Se não, cria um dicionário `settings` com valores padrão.
    - Chama `apply_all_settings()`.
  - `save_settings()`:
    - Converte o dicionário `settings` para uma string JSON.
    - Salva a string no `SETTINGS_FILE_PATH`.
  - `apply_all_settings()`:
    - Itera sobre o dicionário `settings` e chama as funções `set_*` apropriadas para aplicar cada configuração.
  - `set_setting(key: String, value)`:
    - Altera um valor no dicionário `settings`.
    - Chama a função de aplicação específica (ex: `apply_volume()`).
    - Emite o sinal `settings_changed`.
    - Chama `save_settings()`.
  - `get_setting(key: String, default_value)`: Retorna um valor do dicionário.
  - **Funções de Aplicação Específicas:**
    - `apply_volume(bus_name, value)`: `AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))`.
    - `apply_resolution(resolution: Vector2i)`: `DisplayServer.window_set_size(resolution)`.
    - `apply_vsync(mode: int)`: `DisplayServer.window_set_vsync_mode(mode)`.
    - `apply_language(lang_code: String)`: `TranslationServer.set_locale(lang_code)`.
    - `apply_remap_action(action: String, event: InputEvent)`: `InputMap.action_erase_events(action)` e `InputMap.action_add_event(action, event)`.

---

## 5. AudioManager.gd

Controla a reprodução de músicas e efeitos sonoros de forma centralizada.

- **Nó Raiz:** `AudioManager` (Node)
- **Estrutura de Nós Filhos:**
  - `MusicPlayer` (AudioStreamPlayer): Para tocar músicas.
  - `SFXPlayer` (AudioStreamPlayer): Para tocar efeitos sonoros.
- **Propósito:** Desacoplar a lógica de áudio das cenas do jogo e responder às configurações de volume do `SettingsManager`.
- **Funções:**
  - `_ready()`: Conecta-se ao sinal `settings_changed` do `SettingsManager` para ajustar os volumes quando eles mudarem.
  - `play_music(stream: AudioStream, loop: bool = true)`:
    - Define o stream do `MusicPlayer`.
    - Configura se deve ser em loop.
    - Toca a música.
  - `play_sfx(stream: AudioStream)`:
    - Toca um som no `SFXPlayer` usando `play()`. Isso permite que vários SFX toquem sobrepostos.
  - `update_volumes()`:
    - Pega os volumes do `SettingsManager`.
    - Aplica os volumes aos buses "Music" and "SFX" (configurados na aba Áudio do Godot).

---
## 6. SaveManager.gd

Responsável por toda a lógica de salvar e carregar o progresso do jogo.

- **Ver:** `manual_save_load.md` para a documentação completa.
