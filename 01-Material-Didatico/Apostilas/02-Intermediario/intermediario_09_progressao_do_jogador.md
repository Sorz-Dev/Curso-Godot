# Apostila 09: Progressão do Jogador

**Nível de Dificuldade:** Intermediário

**Pré-requisitos:** Arquitetura de Dados (Apostila 01), Sistemas Globais (Apostila 06).

---

## 1. A Filosofia: O Ciclo de Recompensa

A progressão é o que mantém o jogador engajado a longo prazo. É o sentimento de que seu tempo e esforço estão sendo recompensados com um poder cada vez maior. Nossa arquitetura de progressão é um ciclo virtuoso que conecta vários sistemas:

**Combate/Quests -> Ganho de XP/Moeda -> Subir de Nível/Compras -> Aumento de Poder -> Combate/Quests Mais Difíceis**

Este ciclo é gerenciado por vários sistemas globais que trabalham em conjunto.

---

## 2. Sistema de Níveis e Experiência (XP)

Este sistema gerencia o fortalecimento fundamental do personagem.

-   **Gerenciador:** `ExperienceManager.gd` (Autoload)
-   **Dados Principais:**
    -   `current_level: int`
    -   `current_xp: int`
    -   `xp_for_next_level: int`
-   **Lógica Chave:**
    -   **Curva de XP:** O XP necessário para o próximo nível não deve ser linear. Uma curva exponencial é o padrão da indústria para que os níveis iniciais sejam rápidos e os níveis finais exijam mais dedicação.
        ```gdscript
        # Dentro de ExperienceManager.gd
        const XP_BASE: float = 100.0
        const XP_GROWTH_FACTOR: float = 1.5

        func calculate_xp_for_next_level():
            xp_for_next_level = int(XP_BASE * pow(current_level, XP_GROWTH_FACTOR))
        ```
    -   **`add_xp(amount: int)`:**
        1.  Adiciona `amount` ao `current_xp`.
        2.  Emite um sinal `experience_gained(amount)` para a HUD reagir (ex: animar a barra de XP).
        3.  Usa um loop `while current_xp >= xp_for_next_level:` para permitir múltiplos level-ups de uma vez.
        4.  Dentro do loop, chama `level_up_procedure()`.
    -   **`level_up_procedure()`:**
        1.  Subtrai `xp_for_next_level` do `current_xp`.
        2.  Incrementa `current_level`.
        3.  Chama `calculate_xp_for_next_level()` para definir a nova meta.
        4.  **Recompensa:** Aumenta os stats base do jogador, concede pontos de habilidade, etc.
        5.  Emite o sinal `level_up(new_level)` para a HUD e outros sistemas mostrarem um efeito de "Level Up!".
-   **Integração:**
    -   **Inimigos:** O `EnemyData.tres` de cada inimigo contém `var experience_points: int`. Ao morrer, o inimigo chama `ExperienceManager.add_xp(data.experience_points)`.
    -   **Quests:** Ao completar uma quest, o `QuestManager` chama `ExperienceManager.add_xp(quest.xp_reward)`.

---

## 3. Sistema de Equipamentos

Este sistema permite a customização e o fortalecimento através de itens.

-   **Gerenciador:** `EquipmentManager.gd` (Autoload)
-   **Dados:**
    -   O `ItemResource.gd` é expandido com `enum EquipmentSlot` e `@export var stats_bonus: CharacterStats`.
-   **Lógica Chave: `recalculate_player_stats()`**
    -   Esta função é o coração do sistema. Ela é chamada sempre que um item é equipado ou desequipado.
    1.  Pega uma referência ao nó do jogador.
    2.  Cria uma cópia dos stats base do jogador: `var total_stats = player.base_stats.duplicate()`. É crucial usar `duplicate()` para não modificar o recurso original de stats base.
    3.  Itera sobre o dicionário de itens equipados.
    4.  Para cada item, soma seus `stats_bonus` aos `total_stats`.
        ```gdscript
        if item and item.stats_bonus:
            total_stats.max_health += item.stats_bonus.max_health
            total_stats.defense += item.stats_bonus.defense
            # ... etc. para todos os stats
        ```
    5.  No final, aplica os stats calculados ao jogador: `player.stats = total_stats`.
    6.  (Opcional, mas recomendado) Chama uma função no jogador para atualizar seu estado, como `player.update_health_after_stats_change()`, que garante que a vida atual não ultrapasse a nova vida máxima.
-   **Integração:**
    -   O script do jogador (`player.gd`) agora tem duas variáveis de stats: `@export var base_stats: CharacterStats` e `var stats: CharacterStats`. Toda a lógica de combate usa `stats`, enquanto `base_stats` é o que é aprimorado pelo `ExperienceManager`.
    -   A UI de Inventário é expandida com slots de equipamento que chamam `EquipmentManager.equip_item()` e `unequip_item()`.

---

## 4. Sistema de Lojas e Moeda

Este sistema dá um propósito para a moeda do jogo e oferece um caminho de progressão alternativo.

-   **Gerenciador de Moeda:** `WalletManager.gd` (Autoload)
    -   Simples, gerencia `var current_money: int`.
    -   Funções `add_money` e `remove_money`.
    -   Emite `money_changed(new_total)` para a HUD.
-   **Dados da Loja (`ShopInventory.gd` - Resource):**
    -   Define o inventário de um vendedor.
    -   `@export var items_for_sale: Array[ItemResource]`
    -   `@export var price_modifier: float = 1.0` (para criar lojas mais caras ou mais baratas).
-   **Lógica da UI da Loja (`ShopUI.gd`):**
    -   **`open_shop(shop_data: ShopInventory)`:** Chamado por um NPC. Popula as listas de compra e venda.
    -   **Comprar:**
        1.  Calcula o preço: `item.base_value * shop_data.price_modifier`.
        2.  Verifica se o jogador tem dinheiro: `if WalletManager.remove_money(price):`.
        3.  Se sim, adiciona o item: `InventoryManager.add_item(item)`.
    -   **Vender:**
        1.  Calcula o preço de venda (geralmente uma fração do valor base, ex: `item.base_value * 0.5`).
        2.  Remove o item do inventário: `InventoryManager.remove_item(slot_index)`.
        3.  Adiciona o dinheiro: `WalletManager.add_money(sell_price)`.
-   **Integração:**
    -   O `ItemResource.gd` precisa de `@export var base_value: int`.
    -   NPCs vendedores têm um componente `Interactable` e uma variável `@export var shop_inventory: ShopInventory`. A interação chama `ShopUI.open_shop()`.

Juntos, estes três sistemas criam uma rede de progressão robusta, onde o jogador é constantemente recompensado e tem múltiplos caminhos para se fortalecer, seja através do combate (XP), da exploração (equipamentos) ou do comércio (moeda).
