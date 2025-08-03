# Manual de Visão Geral - Pong Moderno

## 1. Visão do Projeto

**Conceito:** Uma recriação moderna do clássico Pong. O objetivo é ser o primeiro jogo completo do curso, focando nos conceitos mais básicos do Godot de forma prática e divertida.

## 2. Pilares do Design

1.  **Simplicidade:** A jogabilidade é direta e fácil de entender. Dois jogadores controlam paletas para rebater uma bola.
2.  **Feedback Visual:** O jogo terá elementos de "juice" como partículas ao colidir, um rastro na bola e um leve "screen shake" ao pontuar.
3.  **Fundamentos Essenciais:** O projeto servirá para ensinar:
    *   Input do jogador.
    *   Nós de física (`CharacterBody2D` para as paletas, `RigidBody2D` para a bola).
    *   Detecção de colisão.
    *   UI simples para o placar (`Label`).
*   Sinais para comunicação (bola pontuou -> placar atualiza).
*   **Arquitetura de Dados com `Resources`**: Usaremos arquivos `.tres` para definir os stats da bola (velocidade) e das paletas (velocidade), introduzindo este conceito fundamental de forma prática.
