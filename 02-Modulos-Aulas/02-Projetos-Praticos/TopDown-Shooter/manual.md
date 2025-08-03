# Manual de Visão Geral - TopDown-Shooter

## 1. Visão do Projeto

**Nome Provisório:** TopDown-Shooter

**Referência Principal:** Minishoot' Adventures

**Conceito:** Um jogo de aventura e exploração com combate twin-stick shooter. O jogador controla uma nave em um mundo aberto, derrota inimigos e chefes, adquire novas habilidades e equipamentos para acessar novas áreas e se tornar mais forte.

## 2. Pilares do Design

1.  **Exploração Recompensadora:** O mundo é um grande mapa interconectado com segredos, atalhos e áreas bloqueadas. A principal motivação do jogador é a curiosidade e a descoberta.
2.  **Combate Acessível e Frenético:** A mecânica de tiro é fácil de aprender (twin-stick), mas o desafio vem dos padrões de ataque dos inimigos (bullet hell lite). O "game feel" (feedback de dano, sons, efeitos) é crucial.
3.  **Progressão Constante:** O jogador sente que está sempre melhorando, seja através de:
    *   **Habilidades:** Novas armas ou movimentos que abrem o mapa.
    *   **Stats:** Level up e equipamentos que aumentam dano, vida, etc.
    *   **Coletáveis:** Itens que dão pequenas melhorias permanentes.

## 3. Arquitetura Inicial

O projeto seguirá a arquitetura padrão do curso:

*   **Dados:** Usaremos `Resource` para definir `EnemyData`, `ItemData`, `LevelData`, etc.
*   **Lógica:** A nave do jogador e os inimigos usarão a **Máquina de Estados (FSM)** para gerenciar seus comportamentos.
*   **Sistemas Globais:** Teremos `Autoloads` para gerenciar o estado do mundo, inventário, áudio, cenas, etc.
