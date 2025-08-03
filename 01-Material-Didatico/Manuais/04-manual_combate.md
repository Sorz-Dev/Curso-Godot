# Manual de Combate Unificado e Expandido

Este documento é um compêndio de arquiteturas e conceitos para diversos sistemas de combate em Godot, projetado para ser uma base flexível para qualquer gênero de jogo de ação.

## Índice

1.  [**Conceitos Fundamentais de Combate**](#1-conceitos-fundamentais-de-combate)
    *   [1.1. A Santíssima Trindade: Hitbox, Hurtbox e Dano](#11-a-santíssima-trindade-hitbox-hurtbox-e-dano)
    *   [1.2. O Pacote de Dados do Ataque (`AttackData`)](#12-o-pacote-de-dados-do-ataque-attackdata)
    *   [1.3. A Função `take_damage`](#13-a-função-take_damage)
    *   [1.4. Knockback e Frames de Invencibilidade](#14-knockback-e-frames-de-invencibilidade)
2.  [**Arquétipos de Combate Corpo a Corpo (Melee)**](#2-arquétipos-de-combate-corpo-a-corpo-melee)
    *   [2.1. Hack 'n' Slash](#21-hack-n-slash)
    *   [2.2. Duelista / Esgrimista](#22-duelista--esgrimista)
    *   [2.3. Arma Pesada / Bárbaro](#23-arma-pesada--bárbaro)
    *   [2.4. Pugilista / Desarmado](#24-pugilista--desarmado)
    *   [2.5. Lanceiro](#25-lanceiro)
    *   [2.6. Lâminas Duplas (Dual Wielding)](#26-lâminas-duplas-dual-wielding)
    *   [2.7. Assassino / Adagas](#27-assassino--adagas)
    *   [2.8. Escudeiro](#28-escudeiro)
    *   [2.9. Ataque em Queda (Plunge Attack)](#29-ataque-em-queda-plunge-attack)
3.  [**Arquétipos de Combate à Distância (Ranged)**](#3-arquétipos-de-combate-à-distância-ranged)
    *   [3.1. O Projétil Genérico](#31-o-projétil-genérico-projectiletscn)
    *   [3.2. Arqueiro Clássico](#32-arqueiro-clássico)
    *   [3.3. Atirador (Hitscan)](#33-atirador-hitscan)
    *   [3.4. Lançador de Granadas / Projéteis com Física](#34-lançador-de-granadas--projéteis-com-física)
    *   [3.5. Feixe de Energia / Laser](#35-feixe-de-energia--laser)
    *   [3.6. Projétil Teleguiado](#36-projétil-teleguiado)
    *   [3.7. Boomerang / Chakram](#37-boomerang--chakram)
    *   [3.8. Orbes Giratórios](#38-orbes-giratórios)
    *   [3.9. Torreta (Turret)](#39-torreta-turret)
4.  [**Arquétipos de Combate Mágico e Especial**](#4-arquétipos-de-combate-mágico-e-especial)
    *   [4.1. Dano em Área (AoE)](#41-dano-em-área-area-of-effect---aoe)
    *   [4.2. Dano Contínuo (DoT)](#42-dano-contínuo-damage-over-time---dot)
    *   [4.3. Armadilhas (Traps)](#43-armadilhas-traps)
    *   [4.4. Invocações / Companheiros (Summons)](#44-invocações--companheiros-summons)
    *   [4.5. Buffs e Debuffs](#45-buffs-e-debuffs)
    *   [4.6. Dreno de Vida (Life Steal)](#46-dreno-de-vida-life-steal)
    *   [4.7. Controle de Grupo (Crowd Control - CC)](#47-controle-de-grupo-crowd-control---cc)
    *   [4.8. Reflexão de Dano](#48-reflexão-de-dano)

---

## 1. Conceitos Fundamentais de Combate

### 1.1. A Santíssima Trindade: Hitbox, Hurtbox e Dano
- **Hitbox (Caixa de Ataque):** Uma `Area2D` que representa o alcance de um ataque.
  - **Layer:** "hitbox", **Mask:** "hurtbox".
  - Geralmente ativada apenas durante os frames de ataque de uma `AnimationPlayer`.
- **Hurtbox (Caixa de Dano):** Uma `Area2D` que representa as partes vulneráveis de um personagem.
  - **Layer:** "hurtbox", **Mask:** "hitbox".
  - Possui (ou seu `owner` possui) a função `take_damage(attack_data)`.
- **O Evento de Dano:** A `Hitbox` detecta uma `Hurtbox` (via `area_entered`) e chama a função `take_damage` na vítima.

### 1.2. O Pacote de Dados do Ataque (`AttackData`)
Passe sempre um dicionário com os dados do ataque para máxima flexibilidade. O dano real pode ser calculado usando os `stats` do atacante.
- **Exemplo:**
  ```gdscript
  # No atacante, antes de chamar take_damage
  var attack_data = {
      "base_damage": stats.base_damage, # Dano base vindo dos stats
      "damage_multiplier": 1.5, # Para um golpe forte, por exemplo
      "knockback_force": 200.0,
      "source": self, # Referência ao nó do atacante
      "damage_type": "physical",
  }
  ```

### 1.3. A Função `take_damage`
A função no script do personagem que recebe o `AttackData` e aplica seus efeitos, considerando os `stats` do defensor.
```gdscript
# No defensor (jogador, inimigo)
func take_damage(attack_data: Dictionary):
    # Calcula o dano final considerando a defesa
    var incoming_damage = attack_data.get("base_damage", 0) * attack_data.get("damage_multiplier", 1.0)
    var final_damage = max(1, incoming_damage - stats.defense) # Garante pelo menos 1 de dano

    current_health -= final_damage
    
    var knockback_source = attack_data.get("source")
    if knockback_source:
        var direction = (global_position - knockback_source.global_position).normalized()
        velocity = direction * attack_data.get("knockback_force", 0)
    
    state_machine.transition_to("Hurt")
    if current_health <= 0: die()
```

### 1.4. Knockback e Frames de Invencibilidade
- **Knockback:** Aplique uma velocidade instantânea ao `CharacterBody2D`. Em jogos de plataforma, adicione um componente vertical.
- **Invincibility Frames:** Após sofrer dano, desative a `Hurtbox` com um `Timer` para evitar dano múltiplo. Dê feedback visual (personagem piscando).

---

## 2. Arquétipos de Combate Corpo a Corpo (Melee)

### 2.1. Hack 'n' Slash
- **Conceito:** Ataques rápidos com arcos amplos.
- **Implementação:** `Area2D` com `CollisionShape2D` em arco. Colete alvos em um array antes de aplicar dano para evitar acertos múltiplos.

### 2.2. Duelista / Esgrimista
- **Conceito:** Ataques precisos, focados em um alvo e `parry`.
- **Implementação:** `Area2D` com `CollisionShape2D` longa e fina. Uma "parrybox" (`Area2D`) separada aciona um contra-ataque ao colidir com uma hitbox inimiga.

### 2.3. Arma Pesada / Bárbaro
- **Conceito:** Golpes lentos e devastadores.
- **Implementação:** Use um `Timer` para medir a carga do ataque. Implemente "Super Armor" (não ser interrompido) com uma flag booleana.

### 2.4. Pugilista / Desarmado
- **Conceito:** Combate de curto alcance com combos complexos.
- **Implementação:** Hitbox pequena. Use um `Timer` para a janela de combos e um contador para a sequência.

### 2.5. Lanceiro
- **Conceito:** Manter distância com estocadas de longo alcance.
- **Implementação:** `Area2D` com `CollisionShape2D` retangular e longa.

### 2.6. Lâminas Duplas (Dual Wielding)
- **Conceito:** Ataques muito rápidos que acertam em uma sequência de "flurry".
- **Implementação:** Animações que ativam duas hitboxes menores em rápida sucessão ou uma hitbox que pulsa várias vezes.

### 2.7. Assassino / Adagas
- **Conceito:** Dano massivo ao atacar de uma posição vantajosa (costas, invisível).
- **Implementação:** A função `take_damage` do inimigo verifica a posição relativa do atacante. Se for por trás, o dano no `AttackData` é multiplicado.

### 2.8. Escudeiro
- **Conceito:** Foco em defesa e contra-ataque.
- **Implementação:** Manter o botão de defesa pressionado ativa uma `Area2D` (o escudo) que bloqueia projéteis (destruindo-os) e ataques melee (anulando o dano). Soltar o botão após um bloqueio pode acionar um "empurrão" (bash) com uma hitbox própria.

### 2.9. Ataque em Queda (Plunge Attack)
- **Conceito:** (Específico de Plataforma) Um ataque de cima para baixo que causa dano em área ao aterrissar.
- **Implementação:** Se o jogador estiver no ar e pressionar ataque, ele entra em um estado de "queda". Ao colidir com o chão (`is_on_floor()`), instancie uma `Area2D` de dano AoE nos seus pés.

---

## 3. Arquétipos de Combate à Distância (Ranged)

### 3.1. O Projétil Genérico (`projectile.tscn`)
- **Conceito:** Uma cena base (`Area2D`) para todos os projéteis, com script contendo `speed`, `direction`, `damage`, etc.

### 3.2. Arqueiro Clássico
- **Conceito:** Projéteis com velocidade finita e arco.
- **Implementação:** Adicione `gravity` à velocidade do projétil. Carregar o tiro aumenta a `speed` inicial.

### 3.3. Atirador (Hitscan)
- **Conceito:** Ataques instantâneos.
- **Implementação:** Use um `RayCast2D`. Aplique dano instantaneamente no ponto de colisão. Use `Line2D` para feedback visual.

### 3.4. Lançador de Granadas / Projéteis com Física
- **Conceito:** Projéteis que quicam e explodem.
- **Implementação:** Use um `RigidBody2D` para o projétil. Um `Timer` a bordo aciona a explosão (dano AoE).

### 3.5. Feixe de Energia / Laser
- **Conceito:** Ataque contínuo.
- **Implementação:** Use um `RayCast2D` atualizado a cada frame. Aplique dano em pequenos intervalos.

### 3.6. Projétil Teleguiado
- **Conceito:** Projéteis que perseguem um alvo.
- **Implementação:** O projétil tem uma `Area2D` de detecção e usa `lerp` para ajustar sua direção em direção ao alvo.

### 3.7. Boomerang / Chakram
- **Conceito:** Um projétil que vai e volta, podendo acertar duas vezes.
- **Implementação:** O projétil viaja para frente por uma certa `distância` ou `tempo`. Depois, inverte sua direção e passa a mirar a posição do jogador até ser pego.

### 3.8. Orbes Giratórios
- **Conceito:** Orbes que giram ao redor do jogador, funcionando como um escudo/dano passivo.
- **Implementação:** Instancie os orbes como filhos de um nó central. No `_process`, rotacione o nó central. Cada orbe é uma `Area2D` de dano.

### 3.9. Torreta (Turret)
- **Conceito:** Invocar um objeto estacionário que ataca inimigos automaticamente.
- **Implementação:** Similar a uma Invocação, mas sem movimento. A torreta tem uma `Area2D` de detecção e atira (`RayCast` ou projéteis) no primeiro inimigo que entra no seu alcance.

---

## 4. Arquétipos de Combate Mágico e Especial

### 4.1. Dano em Área (Area of Effect - AoE)
- **Conceito:** Habilidades que afetam uma área designada.
- **Implementação:** Instancie uma `Area2D` no local alvo. Use `get_overlapping_areas()` para danificar todos os alvos.

### 4.2. Dano Contínuo (Damage over Time - DoT)
- **Conceito:** Aplicar status que causa dano em intervalos (veneno, queimadura).
- **Implementação:** O `AttackData` carrega um `dot_effect`. A vítima cria um `Timer` que aplica dano a cada "tick".

### 4.3. Armadilhas (Traps)
- **Conceito:** Colocar objetos que disparam quando inimigos se aproximam.
- **Implementação:** Uma cena com uma `Area2D` de detecção que ativa uma `Hitbox`.

### 4.4. Invocações / Companheiros (Summons)
- **Conceito:** Invocar aliados com IA.
- **Implementação:** Uma cena de "minion" (`CharacterBody2D`) com IA simples para atacar inimigos.

### 4.5. Buffs e Debuffs
- **Conceito:** Alterar temporariamente os atributos.
- **Implementação:** Similar ao DoT, mas altera uma estatística (ex: `speed *= 1.5`). Um `Timer` reverte a alteração.

### 4.6. Dreno de Vida (Life Steal)
- **Conceito:** Curar o atacante com base no dano causado.
- **Implementação:** O `AttackData` contém uma flag `lifesteal_ratio` (ex: 0.1 para 10%). A `Hitbox` do atacante, ao confirmar um acerto, se cura em `dano * lifesteal_ratio`.

### 4.7. Controle de Grupo (Crowd Control - CC)
- **Conceito:** Habilidades que limitam a capacidade de ação do inimigo.
- **Implementação:** O `AttackData` carrega um efeito de CC (ex: `stun`, `freeze`, `slow`). A função `take_damage` do inimigo aplica esse efeito, geralmente entrando em um estado específico na sua máquina de estados que impede o movimento ou ataque por um tempo.

### 4.8. Reflexão de Dano
- **Conceito:** Um buff que faz com que os atacantes recebam uma parte do dano que causam.
- **Implementação:** Quando o jogador tem o buff "Reflexão" ativo, sua função `take_damage` não apenas aplica dano a si mesmo, mas também chama a função `take_damage` no atacante (passado via `attack_data.source`).