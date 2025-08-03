# Manual de Testes Automatizados com GDUnit

A prática de escrever testes automatizados é um dos pilares da engenharia de software moderna e um diferencial que separa projetos amadores de produtos profissionais e robustos. Em desenvolvimento de jogos, onde a complexidade pode crescer exponencialmente, ter uma suíte de testes confiável é a sua rede de segurança.

Este manual introduz o conceito de testes de unidade e como implementá-los em Godot usando o poderoso plugin **GDUnit4**.

---

### **1. Por que Testar Automaticamente?**

-   **Confiança para Refatorar:** Mude e melhore seu código sem medo de quebrar funcionalidades existentes. Se os testes passarem, você sabe que o comportamento central foi preservado.
-   **Design de Código Melhor:** Escrever código testável geralmente força você a criar scripts menores, mais focados e menos acoplados.
-   **Detectar Bugs Cedo:** Encontre problemas no momento em que são introduzidos, em vez de semanas depois, quando o custo de correção é muito maior.
-   **Documentação Viva:** Testes são exemplos de como seu código deve ser usado.

---

### **2. O que é GDUnit?**

GDUnit é um framework de testes de unidade para Godot, inspirado em ferramentas populares como JUnit (Java) e NUnit (.NET). Ele se integra à interface do Godot e fornece um conjunto rico de ferramentas para escrever e executar testes diretamente do editor.

**Instalação:**

1.  Vá para a aba `AssetLib` no Godot.
2.  Procure por "GDUnit4".
3.  Clique em `Download` e, em seguida, `Install`.
4.  Ative o plugin em `Project > Project Settings > Plugins`, marcando a caixa `Enable` para `GDUnit4`.

Após a ativação, você verá uma nova aba **GDUnit** no painel inferior do editor.

---

### **3. Escrevendo seu Primeiro Teste**

A convenção é criar um script de teste para cada script de produção. Se você tem `scripts/player.gd`, seu teste será `tests/unit/player_test.gd`.

**Exemplo: Testando um `CharacterStats.gd`**

Vamos supor que temos nosso `Resource` de stats:

```gdscript
# res://scripts/resources/character_stats.gd
class_name CharacterStats
extends Resource

@export var max_health: int = 100
@export var defense: int = 5

func take_damage(amount: int) -> int:
    var final_damage = max(1, amount - defense)
    return final_damage
```

Agora, vamos criar um teste para ele:

```gdscript
# tests/unit/character_stats_test.gd
@tool
extends GdUnitTestSuite

# O nome da função DEVE começar com 'test_'
func test_take_damage_with_defense():
    # Arrange: Crie os objetos e o estado inicial
    var stats = CharacterStats.new()
    stats.defense = 5
    
    # Act: Execute a função que você quer testar
    var resulting_damage = stats.take_damage(20)
    
    # Assert: Verifique se o resultado é o esperado
    assert_int(resulting_damage).is_equal(15)

func test_take_damage_less_than_defense_is_always_one():
    # Arrange
    var stats = CharacterStats.new()
    stats.defense = 10
    
    # Act
    var resulting_damage = stats.take_damage(3)
    
    # Assert
    assert_int(resulting_damage).is_equal(1)
```

Para executar, abra a aba **GDUnit**, clique no ícone de recarregar e execute a suíte de testes.

---

### **4. Assertivas Essenciais (Asserts)**

GDUnit fornece uma API fluente para verificar resultados.

-   `assert_that(value)`: Genérico.
-   `assert_int(number)`: Para inteiros.
-   `assert_string(text)`: Para strings.
-   `assert_array(array)`: Para arrays.
-   `assert_dict(dictionary)`: Para dicionários.
-   `assert_signal(signal_emitter, "signal_name")`: Para sinais.

**Exemplos de Assertivas:**

```gdscript
assert_that(player.is_dead).is_true()
assert_that(player.name).is_not_null()
assert_string(player.name).is_equal("Bruno")
assert_int(player.health).is_greater_than(50)
assert_array(inventory.items).is_empty()
assert_array(inventory.items).contains("Sword")
```

---

### **5. Testando Sinais**

Testar se um sinal foi emitido é crucial para sistemas baseados em eventos.

**Exemplo: Sinal `health_depleted`**

```gdscript
# no player.gd
signal health_depleted

func take_damage(amount):
    health -= amount
    if health <= 0:
        health_depleted.emit()
```

**Teste para o Sinal:**

```gdscript
# tests/unit/player_test.gd
@tool
extends GdUnitTestSuite

func test_health_depleted_signal_emitted():
    var player = Player.new()
    player.health = 10
    
    # Verifica se o sinal 'health_depleted' é emitido no objeto 'player'
    # durante a execução da lambda.
    assert_signal(player, "health_depleted") \
        .during_lambda(func(): player.take_damage(20)) \
        .is_emitted()
```

---

### **6. Mocking (Simulando Dependências)**

Às vezes, um script depende de outro. Para testar um script de forma isolada, usamos "Mocks" (objetos simulados).

**Exemplo: `Player` depende de `AudioManager`**

```gdscript
# player.gd
func die():
    # ... lógica de morte
    AudioManager.play_sfx("player_death.wav")
```

Não queremos que o som toque durante o teste. Então, simulamos o `AudioManager`.

```gdscript
# tests/unit/player_test.gd
@tool
extends GdUnitTestSuite

# Simula o autoload 'AudioManager' para todos os testes neste arquivo
const AudioManager := preload("res://scripts/core/audio_manager.gd")
@onready var audio_manager_mock = mock(AudioManager)

func before_test():
    # Injeta o mock no singleton
    Engine.set_singleton("AudioManager", audio_manager_mock)

func test_death_plays_sfx():
    var player = Player.new()
    
    # Act
    player.die()
    
    # Assert: Verifica se a função 'play_sfx' foi chamada no mock
    # com o argumento esperado.
    verify(audio_manager_mock, "play_sfx").with_arguments("player_death.wav").is_called()
```

---

### **7. Boas Práticas de Teste**

-   **Rápidos:** Testes devem rodar em segundos. Evite `yield` ou longos `await`.
-   **Isolados:** Um teste não deve depender de outro.
-   **Repetíveis:** Um teste deve passar ou falhar de forma consistente.
-   **Focados:** Cada função de teste deve verificar uma única coisa.
-   **Legíveis:** Nomes claros e estrutura Arrange-Act-Assert.

---

### **8. Integração com CI/CD**

GDUnit pode ser executado via linha de comando, o que permite a integração com sistemas de Integração Contínua como o GitHub Actions. Você pode configurar um fluxo de trabalho que executa todos os testes a cada `push`, garantindo que nenhum código quebrado seja mesclado à branch principal.

**Comando de Exemplo:**

```bash
godot --headless --run-tests -s res://addons/gdUnit4/bin/run_tests.gd
```

Adotar testes automatizados é um investimento que se paga muitas vezes ao longo do ciclo de vida de um projeto. Comece pequeno, testando suas funções de lógica mais críticas, e expanda a cobertura com o tempo.