# Manual de Perigos Ambientais

Este documento descreve um sistema para criar perigos ambientais, como poças de lava, espinhos, nuvens de veneno, etc. O objetivo é ter uma cena `Hazard` genérica e reutilizável.

## 1. A Filosofia: Dano Desacoplado

Um perigo ambiental é, em essência, uma `Hitbox` persistente que pertence ao "mundo" em vez de a um inimigo. Ele aplica um `AttackData` a qualquer personagem (jogador ou inimigo) que entrar em contato.

## 2. A Cena Base: `Hazard.tscn`

Esta cena pode ser colocada em qualquer nível para criar uma área de dano.

- **Criação:** Crie uma nova cena `Hazard.tscn`.
- **Estrutura da Cena:**
  - **Nó Raiz:** `Hazard` (Area2D)
    - **Script:** `hazard.gd`
    - **Collision Layer:** "hitbox" (ou uma camada dedicada "world_hazard").
    - **Collision Mask:** "hurtbox".
  - **Nós Filhos:**
    - `CollisionShape2D`: Define a forma e o tamanho da área de perigo.
    - `AnimatedSprite2D` ou `GPUParticles2D`: O efeito visual do perigo (lava borbulhando, gás venenoso).
    - `DamageTimer` (Timer): Controla a frequência com que o dano é aplicado.

- **Script (`hazard.gd`):**
  ```gdscript
  class_name Hazard
  extends Area2D

  # --- Configuração do Perigo ---
  @export_group("Comportamento do Dano")
  # O dano a ser aplicado a cada tick
  @export var damage_per_tick: int = 5
  # O intervalo entre cada aplicação de dano (em segundos)
  @export var tick_interval: float = 1.0
  # O knockback a ser aplicado
  @export var knockback_force: float = 100.0
  # O tipo de dano (para resistências)
  @export var damage_type: String = "fire"

  # --- Lógica Interna ---
  # Lista de corpos atualmente dentro da área de perigo
  var bodies_in_area: Array[Node] = []

  func _ready():
      # Configura o timer
      $DamageTimer.wait_time = tick_interval
      $DamageTimer.one_shot = false # Queremos que ele dispare repetidamente
      $DamageTimer.start()
      
      # Conecta os sinais da própria Area2D
      body_entered.connect(_on_body_entered)
      body_exited.connect(_on_body_exited)
      # Conecta o sinal do Timer
      $DamageTimer.timeout.connect(_on_damage_timer_timeout)

  func _on_body_entered(body):
      # Adiciona o corpo à lista se ele puder tomar dano
      if body.has_method("take_damage") and not bodies_in_area.has(body):
          bodies_in_area.append(body)
          # Aplica dano imediatamente ao entrar
          apply_damage(body)

  func _on_body_exited(body):
      if bodies_in_area.has(body):
          bodies_in_area.erase(body)

  # Chamado a cada 'tick_interval'
  func _on_damage_timer_timeout():
      # Itera sobre todos os corpos na área e aplica dano
      for body in bodies_in_area:
          # Garante que o corpo ainda é válido antes de aplicar dano
          if is_instance_valid(body):
              apply_damage(body)
          else:
              # Remove corpos inválidos (que podem ter sido destruídos)
              bodies_in_area.erase(body)

  # Função central que constrói e envia o AttackData
  func apply_damage(target_body):
      var attack_data = {
          "base_damage": damage_per_tick,
          "knockback_force": knockback_force,
          "source": self,
          "damage_type": damage_type
      }
      target_body.take_damage(attack_data)
  ```

## 3. Exemplos de Uso

Com esta cena genérica, criar diferentes tipos de perigos é apenas uma questão de ajustar as propriedades no Inspector.

### 3.1. Poça de Lava
1.  Arraste `Hazard.tscn` para o seu nível.
2.  Ajuste a `CollisionShape2D` para cobrir a área da lava.
3.  No Inspector do script `hazard.gd`:
    - `damage_per_tick = 10`
    - `tick_interval = 0.5`
    - `knockback_force = 50`
    - `damage_type = "fire"`
4.  Adicione um `AnimatedSprite2D` com uma animação de lava borbulhando.

### 3.2. Espinhos no Chão (Dano Único)
Para um perigo que causa dano apenas uma vez ao entrar, a lógica é um pouco diferente.

1.  Arraste `Hazard.tscn` para o nível.
2.  **Modificação:** Desative o `DamageTimer`. O dano será aplicado apenas no `_on_body_entered`.
3.  No Inspector:
    - `damage_per_tick = 25`
    - `knockback_force = 300` (um grande impulso para jogar o jogador para fora)
4.  **Modificação no Script:** Para evitar dano contínuo se o jogador permanecer nos espinhos, você pode desativar a `Hurtbox` do jogador por um momento (usando os frames de invencibilidade) após o primeiro hit. A lógica `take_damage` do jogador já deve cuidar disso.

### 3.3. Nuvem de Veneno
1.  Arraste `Hazard.tscn` para o nível.
2.  No Inspector:
    - `damage_per_tick = 2`
    - `tick_interval = 1.0`
    - `knockback_force = 0` (veneno não causa repulsão)
    - `damage_type = "poison"`
3.  Adicione um `GPUParticles2D` com um efeito de fumaça verde.

Este sistema modular permite que designers de níveis criem desafios variados e complexos sem precisar de código adicional, simplesmente configurando a cena `Hazard` no editor.