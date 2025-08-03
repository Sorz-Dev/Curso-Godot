# Manual de Visão Geral - Clicker de Moedas

## 1. Visão do Projeto

**Conceito:** Um jogo idle/clicker onde o jogador clica para ganhar moedas e compra upgrades que geram moedas automaticamente. Este projeto foca em UI, gerenciamento de estado e persistência de dados.

## 2. Pilares do Design

1.  **Ciclo de Gameplay Viciante:** O loop de clicar, comprar upgrade, gerar mais moedas e comprar upgrades mais caros é o núcleo da experiência.
2.  **UI Reativa:** A interface é o jogo. Ela precisa ser clara, responsiva e fornecer feedback constante sobre os ganhos.
3.  **Persistência:** O progresso do jogador deve ser salvo para que ele possa fechar o jogo e continuar de onde parou.

## 3. Foco de Aprendizado

*   Nós de UI avançados (`Button`, `TextureProgressBar`, `Containers`).
*   Uso de `Timer` para geração passiva de recursos.
*   Sistema de Save/Load com arquivos JSON.
*   Formatação de números grandes (ex: 1.000 -> 1k, 1.000.000 -> 1M).
