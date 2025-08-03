# Apostila 01: Arquitetura Orientada a Dados com Resources

**Nível de Dificuldade:** Intermediário a Avançado

**Pré-requisitos:** Conhecimento básico de GDScript e da interface do Godot.

---

## 1. A Filosofia: Por que "Orientado a Dados"?

No desenvolvimento de jogos, é comum misturar os **dados** de um objeto (sua vida, velocidade, dano) com sua **lógica** (como ele se move, como ataca). Isso funciona para projetos pequenos, mas rapidamente se torna um problema.

**O Problema:** Imagine que você tem um inimigo "Goblin". O script `goblin.gd` tem `var health = 20`, `var speed = 50`. Se você quiser criar um "Goblin Arqueiro" que é um pouco mais rápido mas tem menos vida, você teria que:
1.  Criar uma nova cena `goblin_archer.tscn`.
2.  Criar um novo script `goblin_archer.gd` que herda de `goblin.gd`.
3.  Sobrescrever as variáveis no `_ready()`.

Agora imagine fazer isso para 50 tipos de inimigos. Fica insustentável.

**A Solução (Arquitetura Orientada a Dados):** Nós separamos completamente os **DADOS** da **LÓGICA**.
-   A **Lógica** vive em cenas e scripts genéricos (ex: `enemy_base.tscn` com `enemy.gd`).
-   Os **Dados** vivem em arquivos de `Resource` (arquivos `.tres`), que são como "planilhas de dados" que o Godot entende nativamente.

**Vantagens:**
-   **Flexibilidade Total:** Crie um novo inimigo, item ou arma apenas criando um novo arquivo `.tres` e ajustando seus valores no Inspector. **Zero código novo é necessário.**
-   **Balanceamento Facilitado:** Um game designer pode abrir os arquivos `.tres` e ajustar a vida, dano e velocidade de todos os inimigos sem nunca tocar em uma linha de código.
-   **Colaboração Eficiente:** Programadores criam os "motores" (os scripts de lógica), e designers criam o "combustível" (os arquivos de dados).

---

## 2. Níveis de Implementação de Stats

Vamos ver como essa ideia evolui.

### Nível 1: Básico (Valores no Script)

A abordagem mais simples, boa para protótipos rápidos.

-   **Implementação:** Variáveis são declaradas diretamente no script do personagem.
-   **Exemplo (`player.gd`):**
    ```gdscript
    extends CharacterBody2D

    var max_health: int = 100
    var current_health: int
    var move_speed: float = 200.0
    var damage: int = 10

    func _ready():
        current_health = max_health
    
    func _physics_process(delta):
        velocity.x = Input.get_axis("move_left", "move_right") * move_speed
        move_and_slide()
    ```
-   **Prós:** Rápido de escrever.
-   **Contras:** Difícil de gerenciar e balancear. Qualquer mudança exige editar o código.

### Nível 2: Intermediário (Variáveis Exportadas)

Uma melhoria significativa, expondo os dados no Inspector.

-   **Implementação:** Use a anotação `@export` para que as variáveis apareçam no Inspector do Godot.
-   **Exemplo (`player.gd`):**
    ```gdscript
    extends CharacterBody2D

    @export var max_health: int = 100
    @export var move_speed: float = 200.0
    @export var damage: int = 10
    
    # ... o resto do código é igual ...
    ```
-   **Prós:** Permite que designers ajustem os valores sem tocar no código. Você pode criar variações da cena do jogador e salvar com valores diferentes.
-   **Contras:** Os dados ainda estão "presos" à cena. Se você tiver 100 inimigos na fase, terá 100 cópias desses dados. Se quiser mudar a velocidade de todos os "Goblins", terá que selecionar todos eles e mudar o valor.

### Nível 3: Avançado (Arquitetura com `Resource`)

A abordagem profissional e escalável.

-   **Implementação:** Criamos um script customizado que herda de `Resource` para servir como nosso "molde" de dados.

---

## 3. Guia de Implementação: Criando `CharacterStats.gd`

Este será o nosso recurso base para qualquer entidade que tenha atributos.

1.  **Crie o Script de Recurso:**
    -   No `Sistema de Arquivos`, crie uma pasta `scripts/resources`.
    -   Dentro dela, crie um novo script chamado `character_stats.gd`.

2.  **Escreva o Código do Recurso:**
    ```gdscript
    # character_stats.gd
    class_name CharacterStats
    extends Resource

    # A anotação @export_group organiza os campos no Inspector.
    @export_group("Atributos Primários")
    @export var max_health: int = 100
    @export var move_speed: float = 200.0

    @export_group("Atributos de Combate")
    @export var base_damage: int = 10
    @export var defense: int = 5
    @export var attack_speed: float = 1.0 # Ataques por segundo

    @export_group("Informações")
    @export var character_name: String = "Personagem"
    ```
    **Observação:** Este script **não será anexado a nenhum nó**. Ele é apenas um molde.

3.  **Crie um Recurso de Dados Real:**
    -   No `Sistema de Arquivos`, crie uma pasta `data/stats`.
    -   Clique com o botão direito na pasta `stats` -> `Criar Novo...` -> `Recurso`.
    -   Na janela que abrir, procure e selecione `CharacterStats`.
    -   Salve o arquivo como `player_stats.tres`.
    -   **Mágica:** Selecione o arquivo `player_stats.tres`. O Inspector agora mostra todos os campos que você exportou, prontos para serem editados! Preencha os stats do seu jogador.

4.  **Use o Recurso no Script do Jogador:**
    -   Abra o script `player.gd` e refatore-o:
    ```gdscript
    # player.gd
    extends CharacterBody2D

    # Em vez de exportar cada variável, exportamos UM campo para o nosso recurso.
    @export var stats: CharacterStats

    var current_health: int

    func _ready():
        if not stats:
            print("ERRO: Stats do jogador não definidos!")
            return
        current_health = stats.max_health
    
    func _physics_process(delta):
        if not stats: return
        velocity.x = Input.get_axis("move_left", "move_right") * stats.move_speed
        move_and_slide()

    func take_damage(damage_amount: int):
        if not stats: return
        var final_damage = max(1, damage_amount - stats.defense)
        current_health -= final_damage
        # ...
    ```

5.  **Conecte Tudo no Editor:**
    -   Selecione a cena do seu jogador (`player.tscn`).
    -   No Inspector, você verá o campo "Stats".
    -   Arraste o arquivo `player_stats.tres` da sua pasta `data/stats` para este campo.

**Pronto!** Agora, os dados do seu jogador estão completamente separados da sua lógica. Para mudar a vida máxima do jogador, você edita o arquivo `player_stats.tres`, e a mudança se reflete automaticamente no jogo.

---

## 4. Próximos Passos: Herança de Recursos

Assim como scripts podem herdar de outros scripts, Recursos também podem!

-   Você pode criar um `EnemyData.gd` que herda de `CharacterStats.gd`.
-   `EnemyData` teria todos os stats de `CharacterStats`, mais campos adicionais como `@export var loot_table: LootTable` ou `@export var experience_points: int`.

Esta abordagem é a espinha dorsal de quase todos os sistemas modulares que construiremos neste curso, de inventários a sistemas de loot e IA. Dominá-la é o primeiro grande passo para pensar como um desenvolvedor de jogos profissional.
