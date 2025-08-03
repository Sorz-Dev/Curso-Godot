# Manual de Arquitetura de Dados (Resources)

Este documento descreve a filosofia de usar `Resource` para criar uma arquitetura de jogo orientada a dados. Esta abordagem desacopla os dados (como stats de um inimigo) da sua lógica (como a IA se comporta), permitindo um desenvolvimento e balanceamento muito mais rápidos.

## 1. O Porquê da Abordagem Orientada a Dados

- **Flexibilidade:** Você pode criar dezenas de variações de inimigos, itens ou personagens apenas criando novos arquivos de recurso (`.tres`), sem escrever uma única linha de código.
- **Balanceamento Facilitado:** Todos os valores a serem ajustados (vida, dano, velocidade) ficam expostos no Inspector do Godot, em vez de estarem escondidos em scripts.
- **Colaboração:** Um game designer pode criar e ajustar o conteúdo do jogo (inimigos, itens) enquanto um programador trabalha na lógica do sistema, sem que um interfira no trabalho do outro.

---

## 2. Recurso Base: `CharacterStats.gd`

Este é um `Resource` que contém os atributos fundamentais de qualquer personagem no jogo, seja o jogador ou um inimigo.

- **Criação:** Crie um script `CharacterStats.gd` que herda de `Resource`.
- **Script (`CharacterStats.gd`):**
  ```gdscript
  class_name CharacterStats
  extends Resource

  @export_group("Atributos Primários")
  @export var max_health: int = 100
  @export var move_speed: float = 200.0
  
  @export_group("Combate")
  @export var base_damage: int = 10
  @export var defense: int = 5
  @export var attack_speed: float = 1.0 # Ataques por segundo
  
  @export_group("Visual")
  @export var character_name: String = "Personagem"
  ```
- **Uso:** O nó do jogador (`player.tscn`) e a cena base do inimigo (`enemy.tscn`) não terão mais variáveis como `@export var speed`. Em vez disso, terão:
  ```gdscript
  @export var stats: CharacterStats
  ```
  No `_physics_process`, em vez de usar `speed`, você usará `stats.move_speed`. Ao atacar, o dano será calculado com base em `stats.base_damage`.

---

## 3. Recurso de Inimigo: `EnemyData.gd`

Este `Resource` define um tipo específico de inimigo. Ele herda de `CharacterStats` para incluir todos os atributos base, e adiciona informações específicas do inimigo.

- **Criação:** Crie um script `EnemyData.gd` que herda de `CharacterStats`.
- **Script (`EnemyData.gd`):**
  ```gdscript
  class_name EnemyData
  extends CharacterStats

  @export_group("Comportamento e Aparência")
  # A cena do corpo do inimigo (com sprite, state machine, etc.)
  @export var scene: PackedScene 
  @export var ai_type: Enum("Patrulha", "Estacionário", "Voador") = "Patrulha"

  @export_group("Loot")
  # Recurso que define a tabela de loot deste inimigo
  @export var loot_table: Resource # (Será definido em manual_loot_system.md)
  @export var experience_points: int = 10
  ```
- **Uso:** Para criar um "Goblin", você cria um `goblin_data.tres` e arrasta a cena `goblin.tscn` para o campo `scene`, ajusta seus stats, define seu tipo de IA e sua tabela de loot. Um "Slime" seria outro arquivo `.tres` (`slime_data.tres`) que talvez use a mesma cena base de inimigo, mas com stats e loot diferentes.

---

## 4. (Opcional) Recurso de Arma: `WeaponData.gd`

Para jogos com muitas armas, você pode abstrair os dados da arma também.

- **Criação:** Crie um script `WeaponData.gd` que herda de `Resource`.
- **Script (`WeaponData.gd`):**
  ```gdscript
  class_name WeaponData
  extends Resource

  @export var weapon_name: String
  @export var damage_bonus: int = 5
  @export var attack_speed_modifier: float = 1.0
  
  # A cena da hitbox a ser usada por esta arma
  @export var hitbox_scene: PackedScene 
  ```
- **Uso:** O jogador teria um "slot" para a arma. Ao equipar uma arma, seus bônus são somados aos `CharacterStats` do jogador, e seu `hitbox_scene` é usado para os ataques.

Esta abordagem transforma seu projeto em um sistema modular e escalável, formando a base para todos os outros sistemas que construiremos.
