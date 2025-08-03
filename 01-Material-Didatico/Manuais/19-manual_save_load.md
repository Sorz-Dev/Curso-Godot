# Manual do Sistema de Save/Load

Este documento detalha a arquitetura do `SaveManager` e da UI associada para um sistema de salvamento em JSON com múltiplos slots.

## 1. SaveManager.gd (Autoload)

O cérebro do sistema, responsável por manipular os arquivos de save.

- **Constantes:**
  - `SAVE_DIR = "user://saves/"`
  - `MAX_SLOTS = 5`
- **Sinais:**
  - `save_deleted(slot_index)`: Emitido quando um save é excluído.
  - `game_saved(slot_index)`: Emitido quando o jogo é salvo com sucesso.
- **Funções Principais:**
  - `_ready()`: Garante que o diretório `SAVE_DIR` exista usando `DirAccess`.
  - `save_game(slot_index: int)`:
    1.  Coleta todos os dados necessários para o save em um grande dicionário (`save_data`).
    2.  Chama `collect_game_data()`.
    3.  Converte o dicionário para uma string JSON: `Json.stringify(save_data)`.
    4.  Salva o arquivo em `SAVE_DIR + "slot_{0}.json".format([slot_index])`.
    5.  Emite o sinal `game_saved`.
  - `load_game(slot_index: int)`:
    1.  Verifica se o arquivo de save para o slot existe.
    2.  Carrega o conteúdo do arquivo JSON.
    3.  Converte a string JSON para um dicionário: `Json.parse_string(json_string)`.
    4.  Chama `apply_game_data(load_data)`.
    5.  Chama `SceneManager.change_scene(load_data.get("current_scene"))`.
  - `delete_save(slot_index: int)`:
    1.  Verifica se o arquivo existe.
    2.  Usa `DirAccess` para remover o arquivo.
    3.  Emite o sinal `save_deleted`.
  - `get_save_info(slot_index: int) -> Dictionary`:
    - Carrega o arquivo de save do slot (sem aplicar os dados).
    - Retorna um dicionário com metadados para a UI, como `{"timestamp": "...", "level_name": "...", "playtime": "..."}`.
    - Se o slot estiver vazio, retorna `null`.
  - `get_all_saves_info() -> Array[Dictionary]`:
    - Executa `get_save_info` para todos os slots e retorna um array com as informações.

### 1.1. Coleta e Aplicação de Dados

- `collect_game_data() -> Dictionary`:
  - Cria um dicionário `data`.
  - `data["player_data"] = Global.player_data`
  - `data["current_scene"] = SceneManager.get_current_scene_path()`
  - `data["game_time"] = Global.game_time`
  - **Importante:** Itera por todos os nós em um grupo "Persist" (objetos que precisam salvar seu estado, como NPCs, baús, etc.). Para cada nó, chama uma função `save()` nele e armazena o resultado.
    - `data["persisted_objects"] = {}`
    - `for node in get_tree().get_nodes_in_group("Persist"):`
    - `  data["persisted_objects"][node.get_path()] = node.save()`
  - Retorna `data`.
- `apply_game_data(data: Dictionary)`:
  - `Global.player_data = data.get("player_data")`
  - `Global.game_time = data.get("game_time")`
  - **Importante:** Após a nova cena ser carregada, itera sobre os dados de `persisted_objects`. Para cada entrada, encontra o nó pelo path e chama uma função `load(node_data)` nele. Isso deve ser feito após a transição de cena.

## 2. UI de Save/Load (`save_load_menu.tscn`)

Interface para o jogador interagir com os slots de save.

- **Nó Raiz:** `SaveLoadMenu` (CanvasLayer)
- **Variáveis:**
  - `mode`: Pode ser "save" ou "load". Determina o comportamento dos botões.
- **Estrutura:**
  - `VBoxContainer`
    - `TitleLabel` (Label): "Salvar Jogo" ou "Carregar Jogo".
    - `SaveSlotContainer` (VBoxContainer): Onde os slots são adicionados.
    - `BackButton` (Button)
- **Cena do Slot (`save_slot.tscn`):**
  - Um `PanelContainer` reutilizável para cada slot.
  - **Estrutura:**
    - `HBoxContainer`
      - `SlotInfoContainer` (VBoxContainer)
        - `SlotTitleLabel` (Label): "Slot 1"
        - `MetadataLabel` (Label): "Vazio" ou "Floresta - 00:15:30"
      - `ActionButton` (Button): "Salvar" ou "Carregar".
      - `DeleteButton` (Button): Visível apenas se o slot não estiver vazio.
  - **Script (`save_slot.gd`):**
    - `slot_index`: O número do slot que ele representa.
    - `populate(slot_info)`: Recebe o dicionário do `SaveManager.get_save_info()` e atualiza os labels. Se for `null`, mostra "Vazio".
    - `_on_action_button_pressed()`:
      - Se `mode == "save"`, chama `SaveManager.save_game(slot_index)`.
      - Se `mode == "load"`, chama `SaveManager.load_game(slot_index)`.
    - `_on_delete_button_pressed()`: Chama `SaveManager.delete_save(slot_index)`.

- **Script Principal (`save_load_menu.gd`):**
  - `_ready()`:
    - Chama `populate_slots()`.
    - Conecta-se aos sinais do `SaveManager` (`save_deleted`, `game_saved`) para chamar `populate_slots()` e manter a UI atualizada.
  - `populate_slots()`:
    - Limpa o `SaveSlotContainer`.
    - Chama `SaveManager.get_all_saves_info()`.
    - Para cada item no array retornado, instancia uma cena `save_slot.tscn`, a adiciona como filha e chama sua função `populate()`.

## 3. Objetos Persistentes

Qualquer nó que precise salvar seu estado (ex: um baú que pode ser aberto) deve:
1.  Estar no grupo "Persist".
2.  Ter um script com as seguintes funções:
    - `save() -> Dictionary`: Retorna um dicionário com os dados a serem salvos. Ex: `return {"is_open": true}`.
    - `load(data: Dictionary)`: Recebe o dicionário salvo e restaura seu estado. Ex: `is_open = data.get("is_open", false)`.
