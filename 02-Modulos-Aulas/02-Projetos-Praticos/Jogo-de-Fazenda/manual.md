# Manual de Visão Geral - Jogo de Fazenda

## 1. Visão do Projeto

**Conceito:** Um jogo de simulação de fazenda, inspirado em clássicos como Stardew Valley e Harvest Moon. O jogador gerencia uma fazenda, planta colheitas, cuida de animais e interage com os habitantes de uma cidade próxima.

## 2. Pilares do Design

1.  **Ciclo de Jogo Relaxante:** O loop de plantar, regar, colher e vender é o núcleo da experiência.
2.  **Interação e Relacionamento:** O jogador pode conversar com NPCs, construir amizades e participar de eventos da cidade.
3.  **Progressão da Fazenda:** O jogador expande sua fazenda, constrói novas estruturas e automatiza tarefas.

## 3. Foco de Aprendizado

*   **Arquitetura de Dados com `Resources`**: Usaremos arquivos `.tres` para definir os dados de cada tipo de plantação (tempo de crescimento, preço de venda), ferramentas e animais.
*   Uso avançado de `TileMap` com múltiplas camadas (terra arada, plantações).
*   Sistema de inventário para ferramentas e itens.
*   Ciclo de dia/noite e passagem de estações.
*   Sistema de interação com objetos (plantar sementes, usar ferramentas).
*   Sistema de diálogo com NPCs.
*   **Arquitetura de Dados com `Resources`**: Usaremos `.tres` para tudo: sementes, dados de crescimento de plantas, ferramentas, animais, etc. Isso tornará o jogo extremamente modular.
