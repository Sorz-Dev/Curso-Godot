# Manual de Níveis e Experiência (XP)

Este documento descreve um sistema para gerenciar a progressão do jogador através de níveis, ganhando pontos de experiência (XP) ao derrotar inimigos e completar quests.

## 1. A Filosofia: Progressão Tangível

O objetivo é dar ao jogador um sentimento claro de fortalecimento e progresso. Cada inimigo derrotado e cada missão completa contribuem para um objetivo maior: subir de nível e se tornar mais poderoso.

## 2. O Gerenciador: `ExperienceManager.gd` (Autoload)

Este singleton será o cérebro do sistema, responsável por rastrear o XP e gerenciar a lógica de subida de nível.

- **Criação:** Crie um script `ExperienceManager.gd` e adicione-o como um Autoload.
- **Sinais:**
  - `experience_gained(amount)`: Emitido sempre que o jogador ganha XP. A HUD pode usar isso para mostrar um feedback visual.
  - `level_up(new_level, attribute_points_gained)`: Emitido quando o jogador sobe de nível.
- **Script (`ExperienceManager.gd`):**
  ```gdscript
  extends Node

  signal experience_gained(amount)
  signal level_up(new_level, attribute_points_gained)

  var current_level: int = 1
  var current_xp: int = 0
  var xp_for_next_level: int = 100

  # Constantes para o balanceamento
  const XP_BASE: float = 100.0
  const XP_GROWTH_FACTOR: float = 1.5
  const ATTRIBUTE_POINTS_PER_LEVEL: int = 3

  func _ready():
      # Carregar dados do SaveManager se existir
      # ...
      calculate_xp_for_next_level()

  # A função principal para adicionar XP
  func add_xp(amount: int):
      current_xp += amount
      emit_signal("experience_gained", amount)
      
      # Verifica se o jogador subiu de nível (pode subir múltiplos níveis de uma vez)
      while current_xp >= xp_for_next_level:
          level_up_procedure()

  func level_up_procedure():
      current_xp -= xp_for_next_level
      current_level += 1
      calculate_xp_for_next_level()
      
      # Lógica de recompensa
      # Ex: Aumentar stats base, dar pontos de atributo para a Skill Tree, etc.
      
      emit_signal("level_up", current_level, ATTRIBUTE_POINTS_PER_LEVEL)
      print("LEVEL UP! Você está no nível ", current_level)

  # Calcula o XP necessário para o próximo nível usando uma curva exponencial
  func calculate_xp_for_next_level():
      xp_for_next_level = int(XP_BASE * pow(current_level, XP_GROWTH_FACTOR))

  # Funções para salvar e carregar o estado
  func get_save_data() -> Dictionary:
      return {
          "level": current_level,
          "xp": current_xp
      }

  func load_save_data(data: Dictionary):
      current_level = data.get("level", 1)
      current_xp = data.get("xp", 0)
      calculate_xp_for_next_level()
  ```

## 3. Integração com Outros Sistemas

### 3.1. Inimigos (`EnemyData.gd`)
O `Resource` que define cada inimigo deve ter um campo para o XP que ele concede.

- **No `EnemyData.gd`:**
  ```gdscript
  # ... outras variáveis ...
  @export_group("Loot & Recompensas")
  @export var experience_points: int = 10
  ```

- **No script do inimigo (`enemy.gd`):**
  - Na função `die()`, antes de se autodestruir, o inimigo informa ao `ExperienceManager` que o jogador ganhou XP.
    ```gdscript
    func die():
        # ...
        ExperienceManager.add_xp(data.experience_points)
        # ...
        queue_free()
    ```

### 3.2. Sistema de Quests
Quando uma quest é concluída, ela também pode conceder uma grande quantidade de XP.

- **No `QuestManager.gd`:**
  ```gdscript
  func complete_quest(quest_id):
      var quest_data = get_quest_data(quest_id)
      # ... dar recompensas de itens ...
      ExperienceManager.add_xp(quest_data.xp_reward)
  ```

### 3.3. Interface (HUD)
A HUD do jogo deve se conectar aos sinais do `ExperienceManager` para fornecer feedback ao jogador.

- **Cena `GameHUD.tscn`:**
  - Adicione uma `TextureProgressBar` para a barra de XP.
  - Adicione um `Label` para o nível atual.
- **Script `game_hud.gd`:**
  ```gdscript
  func _ready():
      ExperienceManager.experience_gained.connect(_on_xp_gained)
      ExperienceManager.level_up.connect(_on_level_up)
      # ... inicializar a UI com os valores atuais ...

  func _on_xp_gained(amount):
      # Atualiza o valor da barra de XP
      xp_bar.value = ExperienceManager.current_xp
      # (Opcional) Mostra um "+10 XP" na tela

  func _on_level_up(new_level, points):
      # Atualiza o label do nível
      level_label.text = "Nível " + str(new_level)
      # Atualiza o máximo da barra de XP
      xp_bar.max_value = ExperienceManager.xp_for_next_level
      xp_bar.value = ExperienceManager.current_xp
      # (Opcional) Mostra um efeito visual de "LEVEL UP!"
  ```

Este sistema cria um ciclo de progressão claro e satisfatório, incentivando o jogador a engajar com os sistemas de combate e quests.