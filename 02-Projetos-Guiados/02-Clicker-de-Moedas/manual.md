# Manual de Visão Geral - Clicker de Moedas

## 1. Visão do Projeto

**Conceito:** Um jogo idle/clicker onde o jogador clica para ganhar moedas e compra upgrades que geram moedas automaticamente. Este projeto foca em UI, gerenciamento de estado e persistência de dados.

## 2. Pilares do Design

1.  **Ciclo de Gameplay Viciante:** O loop de clicar, comprar upgrade, gerar mais moedas e comprar upgrades mais caros é o núcleo da experiência.
2.  **UI Reativa:** A interface é o jogo. Ela precisa ser clara, responsiva e fornecer feedback constante sobre os ganhos.
3.  **Persistência:** O progresso do jogador deve ser salvo para que ele possa fechar o jogo e continuar de onde parou.

## 3. Foco de Aprendizado

## 3. Foco de Aprendizado

*   **Arquitetura de Dados com `Resources`**: Usaremos arquivos `.tres` para definir os stats da bola (velocidade) e das paletas (velocidade), introduzindo este conceito fundamental de forma prática.
*   **Sistema de Save/Load com JSON**: Implementaremos um sistema de salvamento e carregamento de dados do jogo usando arquivos JSON.
*   **UI Avançada**: Criaremos uma interface de usuário mais complexa, com botões, labels e barras de progresso.
*   **Animação**: Usaremos o `AnimationPlayer` para criar animações mais complexas e polidas.
*   **Efeitos Visuais**: Criaremos efeitos visuais para o jogo, como partículas e shaders.
*   **Controle de Versão**: Usaremos o Git e o GitHub para controlar as versões do nosso projeto.
*   **Arquitetura de Dados com `Resources`**: Cada upgrade será um arquivo `.tres` contendo seu custo inicial, custo de crescimento, moedas por segundo e textura, permitindo adicionar novos upgrades sem alterar o código.
