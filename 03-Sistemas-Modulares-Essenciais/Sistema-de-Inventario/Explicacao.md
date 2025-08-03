# Manual do Sistema de Inventário

Este documento descreve uma arquitetura genérica e flexível para um sistema de inventário, baseado em `Resource` para os itens e um singleton para gerenciar os dados.

## 1. A Base: Recurso de Item (`ItemResource.gd`)

Criar um `Resource` customizado é a chave para um sistema de inventário robusto. Isso permite que você defina os dados de um item no Editor e os salve como arquivos `.tres`.

- **Criação:** Crie um novo script `ItemResource.gd` que herda de `Resource`.
- **Script (`ItemResource.gd`):**
  ```gdscript
  class_name ItemResource
  extends Resource

  @export var id: StringName
  @export var name: String
  @export_multiline var description: String
  @export var stackable: bool = false
  @export var texture: Texture2D
  # Adicione outras propriedades conforme necessário
  # @export var type: Enum (CONSUMABLE, WEAPON, ARMOR)
  # @export var value: int
  ```
- **Uso:** No FileSystem, clique com o botão direito -> Create New -> Resource... e escolha `ItemResource`. Agora você pode criar arquivos de item como `potion.tres`, `sword.tres`, etc., e preencher suas propriedades no Inspector.

## 2. O Gerenciador: `InventoryManager.gd`

Este pode ser um Autoload ou um nó na sua cena de jogador, dependendo se o inventário é global ou específico do jogador. Para um RPG, um Autoload é geralmente melhor.

- **Nó Raiz:** `InventoryManager` (Node)
- **Sinais:**
  - `inventory_changed()`: Emitido sempre que o inventário é modificado (item adicionado, removido, quantidade alterada). A UI do inventário se conectará a este sinal.
- **Variáveis:**
  - `items`: Um array de dicionários, onde cada dicionário representa um slot no inventário.
    - Exemplo de Slot: `{"item": ItemResource, "quantity": int}`
  - `max_slots`: O número máximo de slots no inventário.
- **Funções Principais:**
  - `add_item(item_resource: ItemResource, quantity: int = 1)`:
    1.  Verifica se o item é empilhável (`item_resource.stackable`).
    2.  Se sim, procura por um slot que já contenha esse item e tenha espaço na pilha. Se encontrar, adiciona a quantidade.
    3.  Se não encontrar um slot existente (ou se o item não for empilhável), procura por um slot vazio.
    4.  Se encontrar um slot vazio, cria uma nova entrada `{"item": item_resource, "quantity": quantity}`.
    5.  Se o inventário estiver cheio, retorna `false` (falha).
    6.  Se teve sucesso, emite `inventory_changed()` e retorna `true`.
  - `remove_item(slot_index: int, quantity: int = 1)`:
    1.  Verifica se o slot é válido.
    2.  Reduz a quantidade do item no slot.
    3.  Se a quantidade chegar a zero, limpa o slot (ex: `items[slot_index] = null`).
    4.  Emite `inventory_changed()`.
  - `get_item(slot_index: int) -> Dictionary`: Retorna o dicionário do slot.
  - `get_all_items() -> Array`: Retorna o array `items` completo.
  - `has_item(item_resource: ItemResource) -> bool`: Verifica se o inventário contém pelo menos um do item especificado.

## 3. A Interface: `InventoryUI.tscn`

A cena que visualmente representa o inventário.

- **Nó Raiz:** `InventoryUI` (CanvasLayer ou Control)
- **Estrutura:**
  - `PanelContainer` (o fundo do inventário)
    - `MarginContainer`
      - `GridContainer`: Para organizar os slots do inventário.
        - **Nós Filhos:** Instâncias da cena `InventorySlotUI.tscn`.
      - `ItemInfoPanel` (PanelContainer): Um painel para mostrar os detalhes do item selecionado.
        - `ItemNameLabel` (Label)
        - `ItemDescriptionLabel` (Label)
        - `ItemTextureRect` (TextureRect)
- **Script (`InventoryUI.gd`):**
  - `_ready()`:
    - Conecta-se ao sinal `inventory_changed` do `InventoryManager`.
    - Chama `update_ui()` para popular a UI pela primeira vez.
  - `update_ui()`:
    1.  Pega todos os slots da UI no `GridContainer`.
    2.  Pega todos os itens do `InventoryManager.get_all_items()`.
    3.  Itera sobre os slots da UI. Para cada um, chama uma função `update_slot(items[i])`, passando os dados do item correspondente.
  - `_on_slot_selected(slot_data)`:
    - Chamado por um sinal do `InventorySlotUI`.
    - Atualiza o `ItemInfoPanel` com os dados do slot selecionado.

### 3.1. Cena do Slot de Inventário (`InventorySlotUI.tscn`)

Um componente de UI reutilizável para cada slot.

- **Nó Raiz:** `InventorySlotUI` (PanelContainer ou Button)
  - Usar um `Button` facilita a detecção de cliques e foco.
- **Sinais:**
  - `slot_selected(slot_data)`: Emitido quando o slot é clicado, enviando seus próprios dados.
- **Estrutura:**
  - `ItemTextureRect` (TextureRect): Mostra a imagem do item.
  - `QuantityLabel` (Label): Mostra a quantidade (visível apenas se a quantidade > 1).
- **Script (`InventorySlotUI.gd`):**
  - `slot_data`: Um dicionário `{"item": ItemResource, "quantity": int}`.
  - `update_slot(new_slot_data)`:
    - Armazena `new_slot_data`.
    - Se `new_slot_data` não for nulo:
      - `ItemTextureRect.texture = new_slot_data.item.texture`
      - `QuantityLabel.text = str(new_slot_data.quantity)`
      - `QuantityLabel.visible = new_slot_data.quantity > 1`
    - Se for nulo, limpa a textura e esconde o label.
  - `_on_button_pressed()`:
    - Emite o sinal `slot_selected(slot_data)`.

## 4. Integração

- **Coletar Itens:** Quando o jogador colide com um item no mundo, o nó do item chama `InventoryManager.add_item(item_resource)` e, se retornar `true`, o nó do item se autodestrói (`queue_free()`).
- **Salvar/Carregar:** O `SaveManager` precisa coletar os dados do `InventoryManager` (`get_all_items()`) e restaurá-los. Como os itens são `Resource`, salvar seus paths (`item_resource.resource_path`) é suficiente. Ao carregar, use `load(path)` para obter o recurso de volta.
