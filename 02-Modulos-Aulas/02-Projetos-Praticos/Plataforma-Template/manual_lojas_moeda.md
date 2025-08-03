# Manual de Lojas e Moeda

Este documento descreve um sistema para criar lojas no jogo, permitindo que o jogador compre e venda itens usando uma moeda corrente.

## 1. A Filosofia: Economia e Acesso

Lojas servem a dois propósitos principais:
1.  **Dar um propósito à moeda:** O dinheiro dropado por inimigos ou encontrado em baús precisa ter uma utilidade.
2.  **Oferecer acesso garantido:** Em contraste com a aleatoriedade do loot, lojas permitem que o jogador compre um item específico que ele precise, dando-lhe mais controle sobre sua progressão.

## 2. Gerenciador de Moeda (`WalletManager.gd` - Autoload)

Antes de ter lojas, precisamos de uma carteira. Este singleton simples rastreia o dinheiro do jogador.

- **Criação:** Crie um script `WalletManager.gd` e adicione-o como um Autoload.
- **Sinais:**
  - `money_changed(new_total)`: Emitido sempre que a quantidade de dinheiro muda.
- **Script (`WalletManager.gd`):**
  ```gdscript
  extends Node

  signal money_changed(new_total)

  var current_money: int = 0

  func add_money(amount: int):
      current_money += amount
      emit_signal("money_changed", current_money)

  func remove_money(amount: int) -> bool:
      if current_money >= amount:
          current_money -= amount
          emit_signal("money_changed", current_money)
          return true
      else:
          # Dinheiro insuficiente
          return false

  # Funções para salvar e carregar
  func get_save_data(): return {"money": current_money}
  func load_save_data(data): current_money = data.get("money", 0)
  ```

## 3. O Recurso da Loja: `ShopInventory.tres`

Cada loja no jogo é definida por um `Resource`, que contém a lista de itens que ela vende. Isso permite criar múltiplos vendedores com inventários diferentes de forma fácil.

- **Criação:** Crie um script `ShopInventory.gd` que herda de `Resource`.
- **Script (`ShopInventory.gd`):**
  ```gdscript
  class_name ShopInventory
  extends Resource

  @export var shop_name: String = "Loja do Povo"
  
  # Array dos itens à venda.
  # Você pode simplesmente arrastar os .tres dos seus ItemResource para esta lista no Inspector.
  @export var items_for_sale: Array[ItemResource]
  
  # (Opcional) Modificador de preço. 1.0 = preço base, 1.2 = 20% mais caro.
  @export var price_modifier: float = 1.0
  ```

## 4. A Interface da Loja (`ShopUI.tscn`)

Esta é a cena da UI que aparece quando o jogador interage com um vendedor.

- **Nó Raiz:** `ShopUI` (CanvasLayer)
- **Estrutura:**
  - Um painel dividido em duas seções: "Comprar" e "Vender".
  - **Seção Comprar:** Um `ItemList` ou `GridContainer` que será populado com os itens do `ShopInventory`.
  - **Seção Vender:** Um `ItemList` ou `GridContainer` que será populado com os itens do `InventoryManager` do jogador.
  - Um painel de detalhes do item selecionado (nome, descrição, preço).
  - Um `Label` para mostrar o dinheiro atual do jogador (conectado ao `WalletManager`).
- **Script (`ShopUI.gd`):**
  ```gdscript
  extends CanvasLayer

  var current_shop_inventory: ShopInventory

  # Chamado quando o jogador interage com um vendedor
  func open_shop(shop_data: ShopInventory):
      current_shop_inventory = shop_data
      populate_buy_list()
      populate_sell_list()
      show()

  func populate_buy_list():
      # Limpa a lista
      # Itera sobre current_shop_inventory.items_for_sale
      # Para cada item, adiciona uma entrada na UI com nome e preço
      # O preço pode ser item.base_value * current_shop_inventory.price_modifier

  func populate_sell_list():
      # Limpa a lista
      # Pega os itens do InventoryManager.get_all_items()
      # Adiciona cada item na UI com seu preço de venda (ex: item.base_value * 0.5)

  func _on_buy_button_pressed(item_to_buy):
      var price = item_to_buy.base_value * current_shop_inventory.price_modifier
      if WalletManager.remove_money(price):
          InventoryManager.add_item(item_to_buy)
          # (Opcional: se a loja tiver estoque limitado, remova o item da lista)
      else:
          # Mostra uma mensagem de "dinheiro insuficiente"
          pass

  func _on_sell_button_pressed(item_to_sell, slot_index):
      var price = item_to_sell.base_value * 0.5 # Preço de venda
      InventoryManager.remove_item(slot_index) 
      WalletManager.add_money(price)
      
      # Atualiza ambas as listas após a transação
      populate_buy_list()
      populate_sell_list()
  ```

## 5. Integração

- **Vendedor (NPC):**
  - Crie um NPC com o componente `Interactable` (do `manual_interacao.md`).
  - Adicione uma variável ao script do NPC: `@export var shop_inventory: ShopInventory`.
  - Quando o jogador interage com ele, o NPC chama `ShopUI.open_shop(shop_inventory)`.

- **`ItemResource.gd`:**
  - Adicione uma variável `@export var base_value: int = 10` ao `ItemResource.gd` para que cada item tenha um preço base.

- **HUD:**
  - O `Label` de dinheiro na sua `GameHUD` principal deve se conectar ao sinal `money_changed` do `WalletManager` para estar sempre atualizado.

Este sistema cria uma economia funcional e desacoplada, onde você pode criar inúmeros vendedores e balancear a economia do seu jogo inteiramente através de recursos no editor.