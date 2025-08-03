# Manual do Sistema de Loot

Este documento descreve um sistema flexível para gerenciar o "drop" de itens de inimigos e baús, baseado em `Resource` para criar tabelas de loot reutilizáveis e fáceis de balancear.

## 1. A Filosofia: Tabelas de Loot Ponderadas

Em vez de um inimigo sempre dropar o mesmo item, usamos um sistema de "tabela de loot". Cada item na tabela tem um "peso". Itens com peso maior são mais comuns, e itens com peso menor são mais raros.

**Exemplo:**
- Moedas (peso: 100)
- Poção (peso: 50)
- Espada Comum (peso: 10)
- Armadura Rara (peso: 1)

O sistema soma todos os pesos (100+50+10+1 = 161), sorteia um número entre 1 e 161, e então determina em qual "faixa" de peso o número caiu para decidir o drop.

## 2. Os Recursos do Sistema de Loot

### 2.1. `LootItem.gd` (O Item na Tabela)
Este `Resource` representa uma única entrada na tabela de loot.

- **Criação:** Crie um script `LootItem.gd` que herda de `Resource`.
- **Script (`LootItem.gd`):**
  ```gdscript
  class_name LootItem
  extends Resource

  # O item que pode ser dropado (usando nosso ItemResource do sistema de inventário)
  @export var item_resource: ItemResource
  
  # A chance deste item ser escolhido. Números maiores = mais comum.
  @export var weight: int = 10
  
  # Quantidade mínima e máxima a ser dropada
  @export var min_quantity: int = 1
  @export var max_quantity: int = 1
  ```

### 2.2. `LootTable.gd` (A Tabela de Loot)
Este `Resource` contém a lista de todos os itens que podem ser dropados por uma fonte (inimigo, baú).

- **Criação:** Crie um script `LootTable.gd` que herda de `Resource`.
- **Script (`LootTable.gd`):**
  ```gdscript
  class_name LootTable
  extends Resource

  # A lista de possíveis drops.
  @export var items: Array[LootItem]
  
  # (Opcional) Número de itens a serem dropados desta tabela (ex: um chefe pode dropar 3 itens)
  @export var number_of_drops: int = 1
  ```
- **Uso:** Agora você pode criar recursos `.tres` como `goblin_loot_table.tres`, `boss_loot_table.tres`, etc. e preenchê-los no Inspector, arrastando os `LootItem`s que você criou.

## 3. O Gerenciador: `LootSystem.gd` (Autoload)

Este singleton contém a lógica para processar uma `LootTable` e determinar o drop.

- **Criação:** Crie um script `LootSystem.gd` e adicione-o como um Autoload.
- **Script (`LootSystem.gd`):**
  ```gdscript
  extends Node

  # A função principal que recebe uma tabela de loot e retorna os itens dropados.
  func get_loot(loot_table: LootTable) -> Array[Dictionary]:
      if not loot_table:
          return []

      var dropped_items = []
      var total_weight = 0
      
      # Calcula o peso total de todos os itens na tabela
      for item in loot_table.items:
          total_weight += item.weight
          
      # Roda o sorteio para cada drop definido na tabela
      for i in range(loot_table.number_of_drops):
          var chosen_weight = randi_range(1, total_weight)
          var current_weight = 0
          
          # Determina qual item foi escolhido com base no peso sorteado
          for item in loot_table.items:
              current_weight += item.weight
              if chosen_weight <= current_weight:
                  var quantity = randi_range(item.min_quantity, item.max_quantity)
                  dropped_items.append({"item": item.item_resource, "quantity": quantity})
                  break # Sai do loop interno e vai para o próximo drop (se houver)
                  
      return dropped_items

  # (Opcional) Uma função helper para instanciar os drops no mundo
  func drop_loot_on_ground(loot_table: LootTable, position: Vector2):
      var items_to_drop = get_loot(loot_table)
      for drop_data in items_to_drop:
          # Aqui você instanciaria uma cena "item_pickup.tscn"
          # que conteria o item_resource e a quantidade.
          var pickup_scene = load("res://scenes/items/item_pickup.tscn").instantiate()
          pickup_scene.global_position = position
          pickup_scene.set_item(drop_data.item, drop_data.quantity)
          get_tree().current_scene.add_child(pickup_scene)
  ```

## 4. Integração

A integração é agora muito simples.

- **No `EnemyData.gd`:**
  - Adicione a linha: `@export var loot_table: LootTable`.
  - Agora, no `.tres` de cada inimigo, você pode arrastar a tabela de loot correspondente.

- **No script do inimigo (`enemy.gd`):**
  - Na função `die()`, chame o `LootSystem`:
    ```gdscript
    func die():
        # ...toca animação de morte...
        if data.loot_table:
            LootSystem.drop_loot_on_ground(data.loot_table, global_position)
        queue_free()
    ```

- **Para Baús:**
  - O script `chest.gd` também teria uma variável `@export var loot_table: LootTable`.
  - Ao ser aberto, ele chamaria `LootSystem.get_loot()` e adicionaria os itens diretamente ao inventário do jogador (`InventoryManager.add_item(...)`).

Este sistema cria um loop de gameplay robusto (Combate -> Loot -> Inventário) e torna o balanceamento de drops uma tarefa de design, não de programação.
