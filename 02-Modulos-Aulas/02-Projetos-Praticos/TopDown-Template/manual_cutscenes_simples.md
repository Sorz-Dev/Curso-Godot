# Manual de Sistema de Cutscenes Simples

Este documento descreve como usar o nó `AnimationPlayer` nativo do Godot para criar cutscenes e eventos de script no jogo, oferecendo uma maneira poderosa e integrada de contar histórias.

## 1. A Filosofia: Contando Histórias com Animação

O propósito de uma cutscene é direcionar a atenção do jogador, desenvolver a narrativa e criar momentos cinematográficos. Em vez de usar ferramentas externas complexas, podemos usar o `AnimationPlayer` como um "diretor" de cena. Ele pode animar quase qualquer propriedade de qualquer nó, desde a posição de uma câmera até a cor de uma luz, e o mais importante: pode chamar funções em momentos precisos.

## 2. A Arquitetura: O `AnimationPlayer` como Diretor

A forma mais eficaz de organizar uma cutscene é ter um `AnimationPlayer` dedicado na cena do seu nível. Este nó irá orquestrar os outros nós (jogador, NPCs, câmera, etc.).

- **Estrutura de Nós Sugerida (na cena do nível):**
  ```
  - Level (Node2D)
    - Player (CharacterBody2D)
    - Boss (CharacterBody2D)
    - WorldCamera (Camera2D)
    - CutsceneTrigger (Area2D)
    - CutscenePlayer (AnimationPlayer) 
  ```
- **`CutsceneTrigger`:** Uma `Area2D` que detecta quando o jogador entra. Seu sinal `body_entered` será conectado para iniciar a cutscene.
- **`CutscenePlayer`:** O `AnimationPlayer` que conterá a lógica da cutscene.

## 3. Implementação Passo a Passo

### 3.1. Criando a Animação
1.  Selecione o `CutscenePlayer`.
2.  No painel de Animação, clique em "Animação" e "Nova". Dê um nome, como `boss_introduction`.
3.  Defina a duração da animação (ex: 5 segundos).

### 3.2. Animando a Câmera
1.  Com o `CutscenePlayer` selecionado, selecione o nó `WorldCamera` na árvore de cena.
2.  No Inspector da câmera, encontre a propriedade `Position`.
3.  Clique no ícone de chave ao lado de `Position`. Isso criará uma nova trilha de animação para a posição da câmera.
4.  Mova a linha do tempo na animação (ex: para o segundo 2.0), mude a posição da câmera na viewport e clique no ícone de chave novamente para criar um novo keyframe. A câmera agora se moverá entre esses dois pontos.

### 3.3. Controlando Personagens
O processo é o mesmo. Você pode criar trilhas para:
- A propriedade `animation` de um `AnimatedSprite2D` para fazer um personagem executar uma animação específica (ex: "taunt").
- A propriedade `visible` de um nó para fazê-lo aparecer ou desaparecer.

### 3.4. Disparando Eventos (A Mágica do "Call Method Track")
Esta é a parte mais poderosa. Você pode chamar qualquer função de qualquer nó em um momento exato.

1.  No `CutscenePlayer`, clique em "Adicionar Trilha" e escolha "Trilha de Chamada de Método".
2.  Uma janela aparecerá. Selecione o nó que contém o script com a função que você quer chamar (ex: o nó do `Player` ou um Autoload como `DialogueManager`).
3.  Uma nova trilha será criada. Clique com o botão direito na trilha no ponto do tempo desejado e selecione "Inserir Chave".
4.  Uma janela aparecerá, listando todos os métodos do nó que você selecionou. Escolha o método (ex: `start_dialogue`). Se o método tiver argumentos, você pode preenchê-los aqui.

## 4. Exemplo de Uso: A Chegada do Chefe

Vamos juntar tudo em um cenário prático.

1.  **O Gatilho:** O jogador entra no `CutsceneTrigger`. O script do trigger chama `$CutscenePlayer.play("boss_introduction")`.
2.  **A Animação Começa (0.0s):**
    - **Call Method Track (no Player):** Chama uma função `set_input_enabled(false)` no script do jogador para que ele não possa se mover.
3.  **Movimento da Câmera (0.5s - 2.0s):**
    - A trilha de posição da `WorldCamera` move a câmera do jogador para focar na arena do chefe.
4.  **Ação do Chefe (2.5s):**
    - **Animation Track (no AnimatedSprite2D do Chefe):** Ativa a animação "emerge_from_ground".
5.  **Diálogo (3.5s):**
    - **Call Method Track (no DialogueManager):** Chama a função `start_dialogue` com o recurso de diálogo da fala do chefe como argumento.
6.  **Fim da Cutscene (5.0s):**
    - A animação termina. Podemos usar o sinal `animation_finished` do `CutscenePlayer`.
    - **Sinal `animation_finished`:** Conectado a uma função no script do nível que chama `player.set_input_enabled(true)`, devolvendo o controle ao jogador.

Este sistema permite criar sequências narrativas complexas e dinâmicas inteiramente dentro do editor do Godot, sincronizando perfeitamente animações, som, diálogos e lógica de jogo.
