# Apostila 00: Fundamentos - A Filosofia Godot

**Nível de Dificuldade:** Essencial / Ponto de Partida

**Pré-requisitos:** Nenhum. Este é o começo de tudo.

---

## 1. A Mentalidade Godot

Antes de arrastar seu primeiro nó, é crucial entender a "alma" da Godot. Diferente de outras engines, a Godot tem uma filosofia de design muito específica, baseada em blocos de construção pequenos e reutilizáveis. Pense em um conjunto de LEGOs.

Existem quatro conceitos que, uma vez compreendidos, farão todo o resto do seu aprendizado ser mais fácil:

1.  **Nós (Nodes):** As pecinhas de LEGO.
2.  **Cenas (Scenes):** O que você constrói com as peças.
3.  **A Árvore de Cenas (Scene Tree):** Como você organiza suas construções.
4.  **Sinais (Signals):** Como suas construções conversam entre si.

---

## 2. Nós (Nodes): Os Blocos de Construção

-   **O que é?** Um Nó é a menor unidade de construção em Godot. Cada nó tem um propósito muito específico.
    -   Um nó `Sprite2D` serve para **mostrar uma imagem**.
    -   Um nó `AudioStreamPlayer` serve para **tocar um som**.
    -   Um nó `CharacterBody2D` serve para **criar um corpo físico que pode ser controlado**.
-   **A Especialização:** Os nós herdam funcionalidades uns dos outros. Um `CharacterBody2D` tem todas as propriedades de um `Node2D` (posição, rotação), mas adiciona a capacidade de colidir e se mover. Você sempre escolherá o nó mais simples que faz o trabalho que você precisa.

---

## 3. Cenas (Scenes): As Criações com os Blocos

-   **O que é?** Uma Cena é um **agrupamento de nós** que, juntos, formam um objeto completo e funcional.
-   **Exemplo Prático: Criando um Jogador**
    1.  Você começa com um `CharacterBody2D` (para a física).
    2.  Você adiciona um `Sprite2D` **como filho** dele (para a aparência visual).
    3.  Você adiciona um `CollisionShape2D` **como filho** (para definir sua forma de colisão).
    -   Pronto! Este conjunto de três nós, salvos juntos, se torna a sua **Cena do Jogador** (`player.tscn`).
-   **O Poder da Reutilização:** Uma cena é um template. Você pode criar uma cena `moeda.tscn` e depois instanciá-la (criar cópias) 100 vezes no seu nível. Se você decidir que a moeda deve brilhar, você edita a cena `moeda.tscn` uma vez, e todas as 100 moedas no seu jogo serão atualizadas automaticamente.

---

## 4. A Árvore de Cenas (Scene Tree): Organizando Tudo

-   **O que é?** É a estrutura hierárquica que organiza os nós e as cenas. Ela define as relações de **pai e filho**.
-   **Herança de Transformação:** A propriedade mais importante dessa relação é que os filhos herdam as transformações (posição, rotação, escala) do pai. Se você mover o nó `Player`, seu `Sprite2D` e `CollisionShape2D` filhos se moverão junto com ele, mantendo suas posições relativas.
-   **O Jogo Inteiro é uma Árvore:** Seu jogo final é, na verdade, uma grande árvore de cenas. Você terá uma cena `Level01`, que contém instâncias das cenas `Player`, `Enemy`, `Moeda` e `TileMap` (o cenário).

---

## 5. Sinais (Signals): A Comunicação Desacoplada

-   **O Problema:** Como a `Moeda` avisa a `UI` que a pontuação deve aumentar? A Moeda não deve ter uma referência direta à UI, pois isso cria um acoplamento forte (se você mudar a UI, pode quebrar o script da Moeda).
-   **A Solução:** Sinais. É um sistema de "gritar e ouvir".
    -   **Emissão (Gritar):** Um nó pode **emitir um sinal** quando algo importante acontece. O nó `Button` emite o sinal `pressed` quando é clicado. Uma `Area2D` (como a da nossa moeda) emite o sinal `body_entered` quando um corpo físico entra nela.
    -   **Conexão (Ouvir):** Outros nós podem se **conectar** a esses sinais. A `UI` pode se conectar ao sinal `coin_collected` do jogador. Quando o jogador emitir esse sinal, a função conectada na UI será executada, e ela atualizará o placar.
-   **Vantagem:** A Moeda não precisa saber quem está ouvindo. Ela só precisa gritar "Fui coletada!". Qualquer sistema interessado (UI, Áudio, Sistema de Partículas) pode ouvir e reagir de forma independente. Isso mantém seu código limpo, modular e fácil de manter.

---

## 6. Bônus: Recursos (Resources)

-   **O que são?** São objetos que contêm apenas **dados**. Pense neles como arquivos de configuração ou planilhas. Eles não fazem nada sozinhos, apenas guardam informações.
-   **Exemplos:** Um `Texture` é um recurso que guarda os dados de uma imagem. Um `AudioStream` é um recurso que guarda os dados de um som. Um `SpriteFrames` é um recurso que guarda os dados de uma animação.
-   **O Poder:** Você pode criar seus próprios Recursos customizados para guardar os stats de um personagem, os dados de um item, ou o conteúdo de um diálogo. Esta é a base da arquitetura orientada a dados que veremos na apostila de nível intermediário.
