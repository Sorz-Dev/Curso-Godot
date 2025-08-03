# Planejamento do Curso de Godot - "A Jornada do Dev de Jogos"

Este documento serve como um esboço estratégico para a criação de um curso de desenvolvimento de jogos com a Godot Engine, inspirado por sua visão e pela análise de canais e cursos de referência.

## 1. Filosofia e Conceito Central

A filosofia do curso deve ser baseada no conceito de **"Aprender Fazendo, de Forma Incremental"**.

Inspirado pela mensagem do canal "Código Fonte TV" e pelo sucesso de modelos como o "Noneclass", o foco não é apenas seguir tutoriais, mas capacitar o aluno a **pensar como um desenvolvedor de jogos**. Cada módulo deve introduzir um novo conjunto de conceitos através da criação de um minijogo completo, garantindo que o aluno tenha um projeto funcional e uma sensação de conquista ao final de cada etapa.

**Princípios-chave:**
*   **Prática Acima de Tudo:** Menos tempo em teoria abstrata, mais tempo com a engine aberta.
*   **Projetos Curtos e Variados:** Evitar um único projeto massivo. Vários jogos pequenos mantêm o engajamento e expõem o aluno a diferentes gêneros e mecânicas.
*   **Dificuldade Progressiva:** Cada novo jogo introduz um ou dois conceitos complexos novos, construindo sobre o que já foi aprendido.
*   **Independência Criativa:** Ao final de cada módulo, o aluno deve ser incentivado a modificar ou expandir o jogo criado, fomentando a autonomia.

## 2. Análise de Referências

### Canais de Godot em Português
*   **Clecio Espindola, NextIndie Studio, Yatsura Games:** Todos são excelentes referências e seguem um modelo de sucesso: ensinam através da prática, geralmente focando em um projeto por série de vídeos. A didática é um ponto forte em comum. A principal oportunidade de diferenciação é oferecer uma **estrutura unificada e progressiva** que guie o aluno por *vários* gêneros, em vez de focar em um único projeto longo.
*   **MerliGameDev:** Não foram encontrados resultados detalhados sobre a estrutura de um curso específico, mas o canal é reconhecido na comunidade.

### Modelo de Inspiração (Noneclass / Oficina Indie)
Este é o nosso principal modelo estrutural.
*   **Estrutura:** O curso é uma jornada através de +10 jogos.
*   **Progressão:** Começa com um "Pong", passa por "Flappy Bird", "Bomberman", até chegar a um RPG no estilo Zelda.
*   **Resultado:** Ao final, o aluno não apenas sabe usar a engine, mas tem um portfólio diversificado de projetos que ele mesmo construiu.

### A Mentalidade (Vídeo "Código Fonte TV")
A mensagem é clara: **Pare de ser um colecionador de tutoriais e comece a ser um construtor de soluções.** Nosso curso deve internalizar essa filosofia, sendo o "empurrão" que o aluno precisa para começar a construir de forma independente.

## 3. Estrutura Proposta para o Curso

A jornada será dividida em módulos, onde cada módulo (a partir do 2) resulta em um jogo completo.

---

### **Módulo 0: Bem-vindo à Godot Engine**
*   **Objetivo:** Familiarizar o aluno com o ambiente, sem programação.
*   **Aulas:**
    *   O que é uma Game Engine? Por que Godot?
    *   Baixando e instalando a Godot.
    *   Visão geral da interface: Gerenciador de Projetos, Editor.
    *   A Trindade da Godot: Nós, Cenas e o Sistema de Árvore.
    *   Criando sua primeira cena e manipulando Nós 2D.

---

### **Módulo 1: Fundamentos de Lógica e GDScript**
*   **Objetivo:** Ensinar o básico da programação dentro do contexto da Godot.
*   **Aulas:**
    *   Introdução ao GDScript: O que é e como funciona.
    *   Variáveis e Tipos de Dados (Inteiros, Floats, Strings, Booleanos).
    *   Funções: `_ready()` e `_process()`.
    *   Estruturas de Controle: `if`, `else`, `elif`.
    *   Loops: `for` e `while`.
    *   **Miniprojeto Prático:** Um nó que imprime mensagens diferentes no console com base em condições.

---

### **Módulo 2: Jogo 1 - "Pong Moderno"**
*   **Objetivo:** Primeiro jogo completo. Foco em input, colisões, UI simples e introdução prática à arquitetura de dados.
*   **Conceitos:** `CharacterBody2D`, Sinais, Detecção de Colisão, Labels para UI, **criação e uso de `Resources` para os stats da bola e das paletas**.
*   **Projeto:** Jogo de Pong funcional para dois jogadores locais.

---

### **Módulo 3: Jogo 2 - "Clicker de Moedas"**
*   **Objetivo:** Foco em UI, gerenciamento de estado e persistência de dados.
*   **Conceitos:** Nós de UI (Botões, Painéis), Timers, salvar e carregar dados (`FileAccess`).
*   **Projeto:** Um jogo idle/clicker onde o jogador clica para ganhar moedas e compra upgrades que geram moedas automaticamente.

---

### **Módulo 4: Jogo 3 - "Nave Espacial (Top-Down Shooter)"**
*   **Objetivo:** Introduzir movimento mais complexo, instanciar cenas e gerenciar múltiplos objetos.
*   **Conceitos:** Movimento em 8 direções, instanciar cenas em tempo de execução (tiros, inimigos), `Area2D` para detecção, efeitos de partículas simples.
*   **Projeto:** Jogo de nave que atira em asteroides/inimigos que aparecem na tela.

---

### **Módulo 5: Jogo 4 - "Plataforma 2D Simples"**
*   **Objetivo:** Explorar a física da Godot e o sistema de TileMaps.
*   **Conceitos:** `CharacterBody2D` com gravidade, `TileMap` para criação de fases, `AnimatedSprite2D` para animações de personagem (parado, correndo, pulando).
*   **Projeto:** Um jogo de plataforma onde o jogador deve chegar do ponto A ao B, pulando sobre obstáculos.

---

### **Módulos Futuros (Avançado):**
*   **Jogo 5: Jogo de Fazenda (Estilo Stardew Valley):** `TileMap` layers, interações com objetos, inventário básico.
*   **Jogo 6: RPG de Turno:** Sistemas de menu complexos, IA de inimigo simples, estrutura de dados para stats.
*   **Tópicos Avançados:** Shaders, Multiplayer, Introdução ao 3D.

## 4. Próximos Passos e Visão de Longo Prazo

Sua visão de cobrir todo o espectro do desenvolvimento é o grande diferencial a longo prazo. A estrutura acima foca na "Engine", mas podemos planejar **Módulos Transversais**.

*   **Módulo de Arte 2D:**
    *   Pixel Art para Desenvolvedores (Ferramentas, técnicas básicas).
    *   Arte Vetorial com Figma/Inkscape para Jogos (Criação de UI e personagens).
*   **Módulo de Áudio:**
    *   SFX: Onde encontrar e como editar sons.
    *   Música: Noções básicas de teoria musical para criar temas simples.
*   **Módulo de Modelagem 3D com Blender:**
    *   Introdução ao Blender para Devs Godot (Modelagem low-poly, exportação).

Esses módulos podem ser produzidos em paralelo e consumidos pelos alunos a qualquer momento da jornada, enriquecendo seus projetos.