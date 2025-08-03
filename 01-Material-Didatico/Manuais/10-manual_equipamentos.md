# Manual do Sistema de Equipamentos

Este documento descreve um sistema que permite ao jogador equipar itens (armas, armaduras, acessórios) para modificar seus atributos e, potencialmente, sua aparência e habilidades.

## 1. A Filosofia: Customização e Impacto

Equipar um item deve ser uma decisão significativa. Deve alterar os stats do jogador de forma perceptível e, idealmente, oferecer novas possibilidades de gameplay (ex: uma arma que ataca mais rápido, uma bota que permite dar um dash).

## 2. Expansão dos Recursos

### 2.1. `ItemResource.gd`
Precisamos adicionar um tipo de item e um slot de equipamento ao nosso recurso de item base.

- **No `ItemResource.gd`:**
  ```gdscript
  class_name ItemResource
  extends Resource

  # ... (id, name, description, etc.) ...

  enum ItemType { CONSUMABLE, EQUIPMENT, KEY_ITEM }
  enum EquipmentSlot { WEAPON, HEAD, CHEST, LEGS, FEET, ACCESSORY }

  @export_group("Tipo de Item")
  @export var type: ItemType = ItemType.CONSUMABLE
  
  # Relevante apenas se o tipo for EQUIPMENT
  @export_group("Equipamento")
  @export var equipment_slot: EquipmentSlot = EquipmentSlot.WEAPON
  @export var stats_bonus: CharacterStats # Um recurso CharacterStats para os bônus!
  ```
- **Como funciona:** Agora, ao criar um item `.tres`, você pode defini-lo como `EQUIPMENT`, escolher o slot que ele ocupa (ex: `CHEST`), e o mais importante: você pode aninhar um *outro* recurso `CharacterStats` dentro dele para definir os bônus. Por exemplo, um `capacete_de_ferro.tres` pode ter um `CharacterStats` aninhado com `defense = 5` e `max_health = 10`.

## 3. O Gerenciador: `EquipmentManager.gd` (Autoload)

Este singleton gerencia os itens atualmente equipados e aplica seus modificadores de stats ao jogador.

- **Criação:** Crie um script `EquipmentManager.gd` e adicione-o como um Autoload.
- **Sinais:**
  - `equipment_changed(slot, new_item)`: Emitido sempre que um item é equipado ou desequipado.
- **Script (`EquipmentManager.gd`):**
  ```gdscript
  extends Node

  signal equipment_changed(slot, new_item)

  # Um dicionário para armazenar o item equipado em cada slot.
  # As chaves são os valores do enum EquipmentSlot.
  var equipped_items: Dictionary = {
      ItemResource.EquipmentSlot.WEAPON: null,
      ItemResource.EquipmentSlot.HEAD: null,
      ItemResource.EquipmentSlot.CHEST: null,
      ItemResource.EquipmentSlot.LEGS: null,
      ItemResource.EquipmentSlot.FEET: null,
      ItemResource.EquipmentSlot.ACCESSORY: null
  }

  # A função principal para equipar um item
  func equip_item(item_from_inventory: ItemResource):
      if item_from_inventory.type != ItemResource.ItemType.EQUIPMENT:
          return

      var slot = item_from_inventory.equipment_slot
      
      # Se já houver um item no slot, desequipa primeiro (devolve ao inventário)
      if equipped_items[slot] != null:
          unequip_item(slot)
      
      equipped_items[slot] = item_from_inventory
      # Lógica para remover o item do inventário do jogador aqui
      InventoryManager.remove_item(item_from_inventory)
      
      emit_signal("equipment_changed", slot, item_from_inventory)
      recalculate_player_stats()

  # Desequipa um item e o devolve ao inventário
  func unequip_item(slot: ItemResource.EquipmentSlot):
      var item_to_unequip = equipped_items[slot]
      if item_to_unequip:
          # Lógica para adicionar o item de volta ao inventário do jogador
          InventoryManager.add_item(item_to_unequip)
          equipped_items[slot] = null
          emit_signal("equipment_changed", slot, null)
          recalculate_player_stats()

  # Esta é a função mais importante. Ela recalcula os stats totais do jogador.
  func recalculate_player_stats():
      var player = get_tree().get_first_node_in_group("Player")
      if not player: return

      # Começa com os stats base do jogador
      var base_stats = player.base_stats # Supondo que o jogador tenha uma referência a seus stats sem bônus
      var total_stats = base_stats.duplicate() # Duplica para não modificar o original

      # Itera sobre todos os itens equipados
      for slot in equipped_items:
          var item = equipped_items[slot]
          if item and item.stats_bonus:
              # Soma os bônus do item aos stats totais
              total_stats.max_health += item.stats_bonus.max_health
              total_stats.defense += item.stats_bonus.defense
              total_stats.base_damage += item.stats_bonus.base_damage
              # ... etc para todos os stats

      # Aplica os stats calculados ao jogador
      player.stats = total_stats
      # (Opcional) Atualiza a vida do jogador para refletir a mudança na vida máxima
      # player.update_health_after_stats_change()
  ```

## 4. Integração

### 4.1. Script do Jogador (`player.gd`)
O jogador agora precisa de duas variáveis de stats: uma para seus stats base (que aumentam com o nível) e outra para os stats totais (com bônus de equipamento).

- **No `player.gd`:**
  ```gdscript
  # Stats base, que são salvos e aumentam com level up
  @export var base_stats: CharacterStats 
  
  # Stats efetivos, que são recalculados pelo EquipmentManager
  var stats: CharacterStats 
  ```
  O `EquipmentManager` irá modificar `player.stats`. Todo o código de combate e movimento deve usar `player.stats`.

### 4.2. Interface de Inventário/Equipamento
A UI do inventário precisa ser expandida para mostrar os slots de equipamento.

- **UI:**
  - Crie uma seção na sua UI de inventário com "slots" visuais para cada tipo de equipamento.
  - Clicar em um item equipável no inventário deve chamar `EquipmentManager.equip_item(item)`.
  - Clicar em um item já equipado nos slots deve chamar `EquipmentManager.unequip_item(slot)`.
- **Atualização da UI:**
  - A UI deve se conectar ao sinal `equipment_changed` para atualizar visualmente os slots sempre que um item for equipado ou desequipado.

Este sistema adiciona uma camada de customização profunda, permitindo que o jogador adapte seu estilo de jogo e se prepare para diferentes desafios trocando seus equipamentos.