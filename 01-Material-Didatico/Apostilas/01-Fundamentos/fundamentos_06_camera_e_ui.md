# Apostila 02: Fundamentos - Câmera e UI Básica

**Nível de Dificuldade:** Fundamental

**Pré-requisitos:** Apostila 01 - Movimento e Input.

---

## 1. A Filosofia: Enquadrando a Ação

O que o jogador vê é tão importante quanto o que ele faz. A câmera é o olho do jogador no mundo do jogo, e a Interface do Usuário (UI) é como o jogo se comunica de volta com o jogador. Aprender a controlar ambos é fundamental.

---

## 2. A Câmera 2D (`Camera2D`)

Este nó define a "janela" de visualização do jogador no mundo 2D.

-   **Implementação Mais Simples: Seguir o Jogador**
    1.  Na cena do seu `Player` (`CharacterBody2D`), adicione um nó `Camera2D` como **filho direto**.
    2.  No Inspector da `Camera2D`, ative a propriedade `Enabled` (ou `Current` em versões mais antigas). Isso a torna a câmera ativa da cena.
    -   **É isso!** Como a câmera é filha do jogador, ela herdará a posição dele automaticamente. Onde o jogador for, a câmera irá junto.

-   **Polimento: Suavização e Limites**
    -   **Suavização (`Smoothing`):** Em vez de estar travada no jogador, a câmera pode segui-lo de forma mais suave, com um leve "atraso".
        -   **Propriedade:** Ative `Smoothing -> Enabled` no Inspector da `Camera2D`.
        -   **`Speed`:** Ajuste a velocidade com que a câmera alcança o jogador. Valores menores criam um efeito mais suave e "flutuante".
    -   **Limites da Câmera:** Para impedir que a câmera mostre áreas fora do seu nível (o "vazio preto").
        1.  Selecione o nó `Camera2D`.
        2.  No Inspector, vá para a seção `Limit`.
        3.  Defina os valores `Limit Left`, `Limit Top`, `Limit Right` e `Limit Bottom`. Estes são os limites em coordenadas do mundo que a câmera não ultrapassará.
        -   **Dica:** Você pode obter esses valores posicionando a câmera nos cantos do seu nível e anotando as coordenadas de sua posição.

---

## 3. A Interface do Usuário (UI) - O Básico

Como mencionado na Apostila 07 (Intermediário), a UI vive em uma camada separada. Vamos criar a UI mais essencial: um contador de pontos.

### 3.1. O `CanvasLayer`: A Camada da UI

-   **O Problema:** Se você adicionar um `Label` (texto) diretamente na sua cena de nível, ele se moverá junto com o mundo quando a câmera seguir o jogador.
-   **A Solução:** O nó `CanvasLayer`.
    -   Pense nele como uma folha de vidro transparente colocada na frente da tela. Tudo que for filho de um `CanvasLayer` será desenhado em relação à tela, e não ao mundo do jogo. Ele ignora completamente a `Camera2D`.

### 3.2. Criando um Placar (HUD)

1.  **Crie uma Nova Cena para a HUD:**
    -   Nó Raiz: `GameHUD` (do tipo `CanvasLayer`).
    -   Filho: `ScoreLabel` (do tipo `Label`).
    -   Posicione o `ScoreLabel` no canto da tela onde você quer que o placar apareça (ex: canto superior esquerdo).
    -   No Inspector do `Label`, na propriedade `Text`, digite `Pontos: 0`.
    -   Salve a cena como `game_hud.tscn`.

2.  **Adicione a HUD ao seu Nível:**
    -   Abra a cena do seu nível principal.
    -   Instancie a cena `game_hud.tscn` como filha do nó raiz do nível.

3.  **Atualizando o Placar via Código:**
    -   No script do seu jogador (`player.gd`), adicione uma variável de pontuação e um sinal:
        ```gdscript
        # player.gd
        signal score_updated(new_score)
        var score = 0

        func add_point():
            score += 1
            emit_signal("score_updated", score)
        ```
    -   No script da sua HUD (`game_hud.gd`):
        ```gdscript
        # game_hud.gd
        extends CanvasLayer

        @onready var score_label = $ScoreLabel

        # Esta função será conectada via editor
        func _on_player_score_updated(new_score):
            score_label.text = "Pontos: " + str(new_score)
        ```
    -   **Conectando Tudo no Editor:**
        1.  Selecione o nó do `Player` na cena do seu nível.
        2.  Vá para o painel `Nó` -> `Sinais`.
        3.  Encontre o sinal `score_updated`, dê um duplo clique.
        4.  Na janela que abrir, selecione o nó `GameHUD` e clique em `Conectar`. O Godot criará automaticamente a função `_on_player_score_updated` no script da HUD.

**Fluxo Final:**
1.  O jogador faz algo que concede um ponto (ex: coleta uma moeda).
2.  A função `add_point()` no jogador é chamada.
3.  O jogador emite o sinal `score_updated` com a nova pontuação.
4.  A HUD, que está ouvindo esse sinal, recebe a nova pontuação e atualiza o texto do seu `Label`.

Este padrão de **Sinais e Slots** (emissão de sinal e conexão de função) é a forma mais poderosa e desacoplada de fazer diferentes partes do seu jogo se comunicarem.
