# Manual de Eventos Globais e Flags

Este documento descreve um sistema centralizado para rastrear o estado do mundo do jogo e o progresso do jogador na história. É a memória de longo prazo do seu jogo.

## 1. A Filosofia: O Mundo se Lembra

O mundo do jogo não deve ser estático. Se o jogador derrota um chefe, uma ponte deve ser consertada. Se ele fala com um guarda, uma porta deve ser destrancada. Este sistema permite que o mundo reaja às ações do jogador de forma persistente.

## 2. O Gerenciador: `WorldStateManager.gd` (Autoload)

Este singleton é um grande dicionário que armazena o estado de tudo que é importante no jogo.

- **Criação:** Crie um script `WorldStateManager.gd` e adicione-o como um Autoload.
- **Sinais:**
  - `flag_changed(flag_name, new_value)`: Emitido sempre que uma flag é alterada. Útil para sistemas que precisam reagir dinamicamente a mudanças de estado.
- **Script (`WorldStateManager.gd`):**
  ```gdscript
  extends Node

  signal flag_changed(flag_name, new_value)

  # O dicionário principal que armazena o estado do mundo.
  # Ex: {"chefe_floresta_derrotado": true, "npc_encontrado": "nenhum", "pontes_consertadas": 3}
  var world_state: Dictionary = {}

  # Define ou atualiza o valor de uma flag.
  func set_flag(flag_name: String, value):
      world_state[flag_name] = value
      emit_signal("flag_changed", flag_name, value)
      print("Flag '", flag_name, "' definida como: ", value)

  # Pega o valor de uma flag. Se não existir, retorna um valor padrão.
  func get_flag(flag_name: String, default_value = null):
      return world_state.get(flag_name, default_value)

  # Funções helper para tipos comuns
  func is_true(flag_name: String) -> bool:
      return get_flag(flag_name, false) == true

  func increment_flag(flag_name: String, amount: int = 1):
      var current_value = get_flag(flag_name, 0)
      if current_value is int:
          set_flag(flag_name, current_value + amount)

  # Integração com o sistema de save/load
  func get_save_data() -> Dictionary:
      return {"world_state": world_state}

  func load_save_data(data: Dictionary):
      world_state = data.get("world_state", {})
  ```

## 3. Exemplos de Uso e Integração

Este sistema é o "cimento" que une todos os outros. Quase todos os sistemas irão, em algum momento, ler ou escrever no `WorldStateManager`.

### 3.1. Diálogos Dinâmicos
Um NPC pode ter diálogos diferentes dependendo do progresso do jogador.

- **No script do NPC (`npc.gd`):**
  ```gdscript
  @export var dialogue_initial: DialogueResource
  @export var dialogue_after_quest: DialogueResource
  @export var dialogue_quest_complete: DialogueResource

  func on_interacted():
      var dialogue_to_play = dialogue_initial
      
      if WorldStateManager.is_true("quest_heroi_aceita"):
          dialogue_to_play = dialogue_after_quest
      
      if WorldStateManager.is_true("quest_heroi_concluida"):
          dialogue_to_play = dialogue_quest_complete
          
      DialogueManager.start_dialogue(dialogue_to_play)
  ```

### 3.2. Inimigos e Chefes
Ao derrotar um chefe, uma flag global é definida.

- **No script do chefe (`boss.gd`):**
  ```gdscript
  func die():
      # ...
      WorldStateManager.set_flag("chefe_da_dungeon_derrotado", true)
      # ...
      queue_free()
  ```

### 3.3. Objetos de Nível Dinâmicos
Uma ponte quebrada pode se consertar sozinha ao ouvir a flag do chefe.

- **No script da ponte (`bridge.gd`):**
  ```gdscript
  func _ready():
      # Se a flag já for verdadeira ao carregar a cena, aparece consertada
      if WorldStateManager.is_true("chefe_da_dungeon_derrotado"):
          get_node("SpriteConsertada").show()
          get_node("SpriteQuebrada").hide()
          get_node("CollisionShape").disabled = false
      else:
          # Se não, conecta-se ao sinal para ser notificada da mudança
          WorldStateManager.flag_changed.connect(_on_flag_changed)

  func _on_flag_changed(flag_name, new_value):
      if flag_name == "chefe_da_dungeon_derrotado" and new_value == true:
          # Toca uma animação de "consertando"
          # ...
          get_node("SpriteConsertada").show()
          get_node("SpriteQuebrada").hide()
          get_node("CollisionShape").disabled = false
          # Desconecta o sinal para não verificar mais
          WorldStateManager.flag_changed.disconnect(_on_flag_changed)
  ```

### 3.4. Sistema de Quests
O sistema de quests será o maior usuário deste gerenciador, definindo e verificando flags constantemente para rastrear os objetivos.

- **No `QuestManager.gd`:**
  ```gdscript
  func check_quest_completion(quest_id):
      var quest_data = get_quest_data(quest_id)
      # Exemplo de objetivo: "derrote 10 slimes"
      if quest_data.objective_type == "kill":
          var kill_count = WorldStateManager.get_flag("slimes_derrotados", 0)
          if kill_count >= quest_data.objective_quantity:
              complete_quest(quest_id)
  ```

Este sistema centralizado é a chave para criar um mundo que parece vivo e reativo às ações do jogador, permitindo a criação de narrativas e progressão complexas.