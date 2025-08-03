# Apostila 02: Fundamentos - Arquitetura de Dados com Resources

**Nível de Dificuldade:** Essencial / Ponto de Partida

**Pré-requisitos:** Apostila 01 - A Filosofia Godot.

---

## 1. A Filosofia: Separando "O Quê" de "Como"

Nos seus primeiros passos, é tentador colocar tudo dentro de um único script. A velocidade do jogador, sua vida máxima, o dano que ele causa... tudo vira uma variável no topo do arquivo `player.gd`.

**O Problema:** Imagine que você quer criar um inimigo "Goblin Rápido", que é igual ao "Goblin" normal, mas com mais velocidade. Você teria que criar um novo script, talvez herdando do primeiro, só para mudar um número. Agora imagine 50 inimigos. Isso se torna um pesadelo para gerenciar e balancear.

**A Solução (Arquitetura Orientada a Dados):** Em vez de misturar os **DADOS** (vida, velocidade, nome) com a **LÓGICA** (como se mover, como atacar), nós os separamos.
-   A **Lógica** vive em scripts genéricos (ex: `personagem.gd`).
-   Os **Dados** vivem em arquivos de **`Resource`** (arquivos `.tres`), que são como "planilhas de dados" que o Godot entende nativamente.

**Vantagens para o Iniciante:**
-   **Organização desde o Dia 1:** Você aprende a forma "certa" de estruturar um projeto escalável.
-   **Flexibilidade Total:** Crie um novo item ou inimigo apenas criando um novo arquivo `.tres` e ajustando seus valores no Inspector. **Zero código novo é necessário.**
-   **Experimentação Rápida:** Quer testar se o jogador fica mais divertido com o dobro da velocidade? Altere um número no arquivo `.tres` e dê play. Sem precisar caçar a variável no código.

---

## 2. Guia Prático: Criando seu Primeiro `Resource`

Vamos criar um `Resource` para guardar os dados de qualquer personagem do nosso jogo.

1.  **Crie o Script de Recurso (O Molde):**
    -   No `Sistema de Arquivos`, crie uma pasta `scripts/resources`.
    -   Dentro dela, crie um novo script chamado `character_stats.gd`.
    -   **Importante:** Este script **não será anexado a nenhum nó**. Ele é apenas um molde.

2.  **Escreva o Código do Recurso:**
    ```gdscript
    # character_stats.gd
    class_name CharacterStats
    extends Resource

    # A anotação @export faz a variável aparecer no Inspector do Godot.
    @export var max_health: int = 100
    @export var move_speed: float = 200.0
    @export var base_damage: int = 10
    ```

3.  **Crie um Recurso de Dados Real (O Arquivo `.tres`):**
    -   No `Sistema de Arquivos`, crie uma pasta `data/stats`.
    -   Clique com o botão direito na pasta `stats` -> `Criar Novo...` -> `Recurso`.
    -   Na janela que abrir, procure e selecione `CharacterStats` (o `class_name` que definimos).
    -   Salve o arquivo como `player_stats.tres`.

4.  **Edite os Dados no Inspector:**
    -   Clique no arquivo `player_stats.tres`.
    -   **Mágica:** O Inspector agora mostra os campos que você exportou (`Max Health`, `Move Speed`, `Base Damage`). Você pode preencher os stats do seu jogador aqui, como se fosse um formulário!

5.  **Use o Recurso no Script do Jogador:**
    -   Abra o script `player.gd` e refatore-o:
    ```gdscript
    # player.gd
    extends CharacterBody2D

    # Em vez de ter várias variáveis, temos UMA para os nossos dados.
    # Arraste o arquivo player_stats.tres para este campo no Inspector.
    @export var stats: CharacterStats

    var current_health: int

    func _ready():
        # Verificação de segurança: o jogo quebra se os stats não forem definidos.
        if not stats:
            print("ERRO: Stats do jogador não definidos no Inspector!")
            queue_free() # Impede que o jogo continue com erro.
            return
        current_health = stats.max_health
    
    func _physics_process(delta):
        if not stats: return
        
        var direction = Input.get_axis("move_left", "move_right")
        velocity.x = direction * stats.move_speed # Usando o dado do Resource!
        move_and_slide()

    func take_damage(damage_amount: int):
        if not stats: return
        
        current_health -= damage_amount
        if current_health <= 0:
            print("O personagem com os stats '", stats.resource_name, "' morreu.")
            queue_free()
    ```

---

## 3. Conclusão: Sua Nova Ferramenta Fundamental

Você acabou de aprender um dos conceitos mais poderosos para a organização de projetos em Godot. De agora em diante, sempre que pensar em um "objeto" no seu jogo (um inimigo, uma arma, um item, uma poção), pergunte-se:
-   **Como ele se comporta?** (Isso vai para um script `.gd`)
-   **Quais são seus dados?** (Isso vai para um `Resource` e um arquivo `.tres`)

Adotar essa mentalidade desde o início fará com que seus projetos sejam mais limpos, fáceis de gerenciar e prontos para crescer. No nosso primeiro jogo, "Pong Moderno", já vamos aplicar isso para os stats da bola e das paletas.
