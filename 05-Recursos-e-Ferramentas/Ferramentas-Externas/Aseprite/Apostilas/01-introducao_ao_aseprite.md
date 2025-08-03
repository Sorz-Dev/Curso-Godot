# Apostila 01: Introdução ao Aseprite

**Nível de Dificuldade:** Essencial

**Pré-requisitos:** Nenhum.

---

## 1. O que é o Aseprite e por que usá-lo?

O Aseprite é um software de edição de imagem e animação focado especificamente em **Pixel Art**. Embora existam muitas ferramentas que podem criar pixel art (incluindo Photoshop e Krita), o Aseprite é o padrão da indústria por um motivo: cada ferramenta e cada atalho nele foi projetado para tornar o fluxo de trabalho de um artista de pixel o mais rápido e eficiente possível.

**Principais Vantagens:**
-   **Foco Total:** Não há distrações. Tudo é para pixel art.
-   **Timeline de Animação:** A timeline é intuitiva e perfeita para criar animações frame a frame.
-   **Ferramentas de Pixel:** Possui ferramentas que não existem em outros softwares, como "Pixel Perfect" para o lápis, sombreamento automático e gerenciamento de paletas de cores.
-   **Exportação para Jogos:** Exporta "Sprite Sheets" (folhas de sprites) de forma fácil e customizável, que é exatamente o que o Godot precisa.

---

## 2. Tour Rápido pela Interface

Ao abrir o Aseprite, você verá algumas áreas principais:

1.  **Tela Principal (Canvas):** Onde você desenha.
2.  **Timeline (Linha do Tempo):** Na parte inferior. É aqui que seus frames e camadas de animação vivem.
3.  **Barra de Ferramentas (Esquerda):** Contém o lápis, borracha, balde de tinta, etc.
4.  **Paleta de Cores (Esquerda Inferior):** Onde você escolhe suas cores.
5.  **Preview (Direita Superior):** Uma pequena janela que mostra sua animação rodando em tempo real. Essencial para sentir o ritmo da animação enquanto você trabalha.

---

## 3. Conceitos Fundamentais

-   **Sprite:** A imagem única de um personagem ou objeto.
-   **Frame (Quadro):** Uma única imagem em uma sequência de animação.
-   **Animação:** Uma sequência de frames que, quando tocados rapidamente, criam a ilusão de movimento.
-   **Layer (Camada):** Como em outros softwares de imagem, permite desenhar elementos em planos separados (ex: uma camada para o personagem, outra para a sombra).
-   **Sprite Sheet (Folha de Sprites):** Uma única imagem que contém todos os frames de todas as suas animações, organizados em uma grade. É o formato que importamos para o Godot.

---

## 4. Criando seu Primeiro Arquivo

1.  Vá em `File > New...`.
2.  **Width (Largura) e Height (Altura):** Para pixel art de jogos, começamos com tamanhos pequenos. `32x32` pixels é um ótimo tamanho para um personagem principal.
3.  **Color Mode:** `RGBA`. Permite cores e transparência.
4.  **Background:** `Transparent`.
5.  Clique em `OK`.

---

## 5. Exportando para o Godot

Depois de criar suas animações (que veremos em detalhes nos manuais), o passo final é exportar.

1.  Vá em `File > Export Sprite Sheet`.
2.  **Layout:**
    -   Marque a opção `Output File` e escolha onde salvar seu arquivo `.png`.
    -   Marque a opção `JSON Data` e salve o arquivo `.json` com o mesmo nome e no mesmo local. Este arquivo contém as informações sobre onde cada animação está na imagem, e o Godot sabe como lê-lo.
3.  **Sprite:**
    -   Em `Sheet Type`, escolha `Packed` para que o Aseprite organize os frames da forma mais otimizada possível.
4.  Clique em `Export`.

Você terá dois arquivos: `player.png` e `player.json`. São esses dois arquivos que levaremos para dentro do nosso projeto Godot para dar vida ao nosso personagem.
