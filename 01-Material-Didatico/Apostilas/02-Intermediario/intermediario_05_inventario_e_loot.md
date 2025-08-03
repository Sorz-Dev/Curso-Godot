# Apostila 05: Inventário e Loot

**Nível de Dificuldade:** Intermediário a Avançado

**Pré-requisitos:** Arquitetura de Dados com `Resource` (Apostila 01).

---

## 1. A Filosofia: Dados, Lógica e Interface

Um bom sistema de inventário e loot é a base de qualquer RPG ou jogo de ação. Nossa arquitetura divide o problema em três partes claras e desacopladas:

1.  **Os Dados (O Quê?):** O que é um item? O que é uma tabela de loot? Usamos `Resource`s (`.tres` arquivos) para definir isso. Um designer pode criar centenas de itens e tabelas de loot sem escrever código.
2.  **A Lógica (Como?):** Como os itens são adicionados/removidos? Como o loot é calculado? Singletons (`Autoloads`) como `InventoryManager` e `LootSystem` cuidam disso.
3.  **A Interface (A Aparência):** Como o inventário é mostrado na tela? Uma cena de UI (`InventoryUI.tscn`) é responsável apenas por se desenhar com base nos dados da Lógica, reagindo a sinais.

Este desacoplamento é crucial. Você pode redesenhar completamente sua UI de inventário sem tocar uma linha da lógica de como os itens são gerenciados.

---

## 2. Os Recursos de Dados

### 2.1. `ItemResource.gd`

O "molde" para qualquer item no jogo.

-   **Caminho:** `scripts/resources/item_resource.gd`
-   **Código:**
    ```gdscript
    class_name ItemResource
    extends Resource

    enum ItemType { CONSUMABLE, EQUIPMENT, KEY_ITEM }
    enum EquipmentSlot { NONE, WEAPON, HEAD, CHEST, LEGS, FEET, ACCESSORY }

    @export_group("Informações Básicas")
    @export var item_name: String = "Novo Item"
    @export_multiline var description: String = "Descrição do item."
    @export var texture: Texture2D
    @export var stackable: bool = true
    @export var max_stack_size: int = 99

    @export_group("Tipo e Função")
    @export var type: ItemType = ItemType.CONSUMABLE
    @export var equipment_slot: EquipmentSlot = EquipmentSlot.NONE
    
    @export_group("Dados de Jogo")
    @export var base_value: int = 10 # Para venda em lojas
    # Para equipamentos, linkamos outro recurso!
    @export var equipment_stats: CharacterStats 
    ```

### 2.2. `LootItem.gd` e `LootTable.gd`

Recursos para definir o que um inimigo ou baú pode dropar.

-   **`LootItem.gd` (Resource):** Representa uma única entrada na tabela.
    ```gdscript
    class_name LootItem
    extends Resource
    @export var item_resource: ItemResource
    @export var weight: int = 10 # Peso. Maior = mais comum
    @export var min_quantity: int = 1
    @export var max_quantity: int = 1
    ```
-   **`LootTable.gd` (Resource):** Contém a lista de todos os `LootItem`s possíveis.
    ```gdscript
    class_name LootTable
    extends Resource
    @export var items: Array[LootItem]
    @export var number_of_drops: int = 1
    ```

---

## 3. A Lógica (Singletons)

### 3.1. `LootSystem.gd` (Autoload)

Calcula os drops com base em uma `LootTable`.

-   **Função Principal: `get_loot(loot_table: LootTable) -> Array[Dictionary]`**
    1.  Calcula o `total_weight` somando o `weight` de todos os `LootItem`s na tabela.
    2.  Entra em um loop `for i in range(loot_table.number_of_drops):`.
    3.  Sorteia um número: `var chosen_weight = randi_range(1, total_weight)`.
    4.  Itera pela lista de itens, subtraindo o peso de cada um do `chosen_weight` até que o valor seja <= 0. O item que zerou o contador é o escolhido.
    5.  Sorteia a quantidade: `var quantity = randi_range(item.min_quantity, item.max_quantity)`.
    6.  Adiciona um dicionário `{"item": item.item_resource, "quantity": quantity}` a um array de retorno.
    7.  Retorna o array de dicionários.

### 3.2. `InventoryManager.gd` (Autoload)

Gerencia o inventário do jogador.

-   **Sinais:** `inventory_updated()`
-   **Dados:** `var items: Array[Dictionary] = []`
    -   Cada slot é um dicionário: `{"item": ItemResource, "quantity": int}`.
    -   Um slot vazio é `null`.
-   **Funções:**
    -   **`add_item(item_res: ItemResource, quantity: int)`:**
        1.  Se o item for empilhável, primeiro procura por um slot que já tenha esse item e adiciona a quantidade.
        2.  Se não, ou se a pilha estiver cheia, procura por um slot vazio (`null`) e o preenche.
        3.  Se teve sucesso, emite `inventory_updated()`.
        4.  Retorna `true` se conseguiu adicionar, `false` se o inventário estava cheio.
    -   **`remove_item(slot_index: int, quantity: int)`:**
        1.  Acessa `items[slot_index]`.
        2.  Subtrai a `quantity`.
        3.  Se a quantidade do slot chegar a zero, define `items[slot_index] = null`.
        4.  Emite `inventory_updated()`.

---

## 4. A Interface (`InventoryUI.tscn`)

A UI é "burra". Ela não sabe como o inventário funciona, ela apenas reage a sinais e exibe dados.

-   **Nó Raiz:** `InventoryUI` (CanvasLayer)
-   **Estrutura:**
    -   `GridContainer`: Para os slots.
    -   `ItemDetailsPanel`: Para mostrar informações do item selecionado.
-   **Cena do Slot (`InventorySlot.tscn`):**
    -   Um `Button` ou `Panel` com um `TextureRect` e um `Label`.
    -   Tem uma função `update_display(slot_data: Dictionary)` que atualiza sua aparência. Se `slot_data` for `null`, ele fica vazio.
    -   Emite um sinal `slot_clicked(slot_data)` quando pressionado.
-   **Script Principal (`InventoryUI.gd`):**
    -   **`_ready()`:**
        1.  Conecta-se ao sinal `InventoryManager.inventory_updated`. A função conectada (`_on_inventory_updated`) será responsável por redesenhar toda a UI.
        2.  Cria as instâncias de `InventorySlot.tscn` e as adiciona ao `GridContainer`.
        3.  Chama `_on_inventory_updated()` uma vez para a exibição inicial.
    -   **`_on_inventory_updated()`:**
        1.  Pega a lista de itens: `var player_items = InventoryManager.items`.
        2.  Itera sobre os nós de slot da UI.
        3.  Chama `slot_node.update_display(player_items[i])` para cada um.
    -   **`_on_slot_clicked(slot_data)`:**
        -   Atualiza o `ItemDetailsPanel` com as informações de `slot_data.item`.

---

## 5. Integração do Fluxo Completo

1.  Um `Enemy` morre.
2.  Sua função `die()` chama `LootSystem.drop_loot_on_ground(data.loot_table, global_position)`.
3.  O `LootSystem` calcula o loot e instancia uma cena `ItemPickup.tscn` no chão.
4.  O `Player` colide com a `Area2D` do `ItemPickup`.
5.  O script do `ItemPickup` chama `InventoryManager.add_item(self.item_resource, self.quantity)`.
6.  Se o `InventoryManager` retornar `true`, o `ItemPickup` se autodestrói (`queue_free()`).
7.  O `InventoryManager` emite o sinal `inventory_updated()`.
8.  A `InventoryUI`, que está ouvindo, chama sua função `_on_inventory_updated()` e redesenha seus slots para refletir o novo item.
