# Apostila 11: Documentação de Design de Jogos

**Nível de Dificuldade:** Essencial para Todos os Níveis

**Pré-requisitos:** Uma ideia de jogo.

---

## 1. A Filosofia: Por que Documentar?

Documentação não é burocracia; é a **planta baixa** do seu jogo. Ela serve para:

-   **Clarificar suas próprias ideias:** Escrever te força a pensar nos detalhes.
-   **Comunicar a visão:** Essencial para trabalhar em equipe. Um artista, um programador e um músico precisam estar na mesma página.
-   **Manter o escopo:** Um GDD bem feito é a sua âncora. Quando surgem novas ideias, você pode se perguntar: "Isso serve à visão original do documento?"
-   **Atrair Investimento:** Documentos como o Pitch e o Briefing são ferramentas para vender seu projeto.

---

## 2. O Kit de Documentos Essenciais

### 2.1. O Pitch e o Briefing (A Venda da Ideia)

-   **O que são?** Documentos curtos e de alto impacto para apresentar a ideia rapidamente.
-   **Para que servem?** Para convencer alguém (um editor, um investidor, um novo membro da equipe) em poucos minutos.
-   **Estrutura Essencial (Briefing):**
    -   **O Jogo:** Qual é o gênero e o conceito central?
    -   **O Diferencial (USP):** O que torna seu jogo único?
    -   **Público e Mercado:** Para quem é este jogo e por que ele venderia?
    -   **Estratégia e Visão:** Como ele será feito e qual o objetivo de longo prazo?
-   **Dica de Ouro:** Escreva o "Elevator Pitch" primeiro: uma descrição de 1 a 3 frases. Se você não consegue explicar seu jogo de forma tão concisa, sua ideia talvez não esteja clara o suficiente.

### 2.2. GDD (Game Design Document)

-   **O que é?** O documento mestre, a "Bíblia" do seu projeto. Descreve **tudo** sobre o jogo.
-   **Para que serve?** É a fonte da verdade para toda a equipe durante o desenvolvimento.
-   **Estrutura Essencial:**
    -   **Visão Geral:** Expansão do Pitch.
    -   **Core Gameplay Loop:** O ciclo principal de ações do jogador (ex: em um roguelite, "Lutar -> Morrer -> Aprimorar -> Repetir").
    -   **Mecânicas Detalhadas:** Descrição de cada sistema (combate, pulo, diálogo, etc.).
    -   **Sistemas de Progressão:** Como o jogador fica mais forte (XP, itens, etc.).
    -   **Narrativa e Lore:** A história, os personagens, o mundo.
    -   **Visão Artística e Sonora:** A direção de arte e música.
-   **Dica de Ouro:** O GDD é um **documento vivo**. Ele vai mudar e evoluir durante o desenvolvimento. Não tenha medo de atualizá-lo, mas sempre discuta as mudanças com a equipe.

### 2.3. TDD (Technical Design Document)

-   **O que é?** A planta baixa da **programação** do jogo.
-   **Para que serve?** Para a equipe de desenvolvimento planejar a arquitetura de software antes de escrever o código.
-   **Estrutura Essencial:**
    -   **Arquitetura de Software:** Padrões a serem usados (FSM, Singletons, Orientado a Dados).
    -   **Estrutura de Dados:** Como os dados de save, itens e inimigos serão armazenados (JSON, Resources).
    -   **Detalhamento de Classes e APIs:** Descrição das funções e variáveis principais de cada sistema (ex: `InventoryManager.add_item(item, quantity)`).
    -   **Desafios Técnicos:** Identificar problemas potenciais (ex: performance com muitos inimigos) e propor soluções.
-   **Dica de Ouro:** Um bom TDD economiza semanas de refatoração. Pensar na estrutura antes de programar evita becos sem saída.

### 2.4. ADD (Audio Design Document)

-   **O que é?** O plano para toda a paisagem sonora do jogo.
-   **Para que serve?** Para guiar o compositor e o designer de som.
-   **Estrutura Essencial:**
    -   **Visão e Filosofia Sonora:** Pilares do áudio (épico, minimalista, retrô?).
    -   **Direção Musical:** Estilo para diferentes contextos (combate, exploração, menus).
    -   **Lista de Efeitos Sonoros (SFX):** Uma lista de todos os sons necessários (passos, ataques, cliques de UI).
-   **Dica de Ouro:** Pense em áudio como 50% da experiência. Um bom design de som pode elevar um jogo mediano a uma experiência memorável.

### 2.5. Outros Documentos Úteis

-   **Guia de Estilo de Arte:** Define a paleta de cores, proporções de personagens e estilo visual.
-   **LDD (Level Design Document):** Planta baixa de uma fase específica, com layout, inimigos e puzzles.
-   **Plano de Localização:** Estratégia para traduzir o jogo para outros idiomas.
-   **Plano de Testes (QA):** Como os bugs serão reportados e quais os critérios para o lançamento.
