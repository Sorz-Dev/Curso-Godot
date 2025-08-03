# Apostila 13: Publicação e Marketing

**Nível de Dificuldade:** Essencial para Todos os Níveis

**Pré-requisitos:** Um jogo completo e exportado.

---

## 1. A Filosofia: O Lançamento é Apenas o Começo

Fazer o jogo é metade da batalha. A outra metade é garantir que as pessoas saibam que ele existe e possam comprá-lo. Esta apostila cobre o processo prático de colocar seu jogo nas lojas e os primeiros passos para divulgá-lo.

---

## 2. Checklist Pré-Lançamento

Antes de pensar em fazer o upload, garanta que você tem:

-   [ ] **Build Final do Jogo:** Uma versão estável e testada.
-   [ ] **Ícone do Jogo:** Em várias resoluções (ex: 1024x1024, 512x512, etc.).
-   [ ] **Material de Marketing (Press Kit):**
    -   **Screenshots:** Pelo menos 5-10 imagens de alta qualidade mostrando os melhores momentos do jogo.
    -   **Trailer:** Um trailer de 60-90 segundos é crucial.
    -   **Arte Chave (Key Art):** A imagem principal que representa seu jogo.
    -   **Descrição do Jogo:** Textos curtos e longos para as páginas da loja.
-   [ ] **Página Web / Rede Social:** Um lugar para os jogadores encontrarem mais informações.

---

## 3. Publicando em Lojas de PC

### 3.1. Itch.io
-   **Nível:** Básico. Ideal para iniciantes, protótipos e game jams.
-   **Processo:**
    1.  Crie uma conta.
    2.  Vá em `Dashboard -> Create new project`.
    3.  Preencha o título, descrição e tags.
    4.  Faça o upload do seu jogo (geralmente um arquivo `.zip` contendo o executável e o arquivo `.pck` do Godot).
    5.  Para jogos Web, você pode fazer o upload do HTML5 e marcá-lo para ser jogado diretamente no navegador.
    6.  Personalize a página da sua loja com imagens e GIFs.
    7.  Defina o preço (pode ser grátis, com doações ou um preço fixo).

### 3.2. Steam
-   **Nível:** Intermediário. A maior plataforma de PC, com um processo mais envolvido.
-   **Processo:**
    1.  **Steamworks:** Torne-se um parceiro Steamworks. Isso envolve preencher formulários e pagar uma taxa única por jogo (Steam Direct Fee).
    2.  **Página da Loja:** Após a aprovação, você terá acesso para criar a página da sua loja. Ela precisa ser aprovada pela Valve antes de ir ao ar, então faça isso com **meses de antecedência** para poder divulgar sua página de "Em Breve" e coletar Wishlists.
    3.  **Builds:** O upload dos builds do jogo é feito através de uma ferramenta de linha de comando chamada **SteamPipe**. Você criará scripts para fazer o upload de novas versões.
    4.  **Integração:** Para usar recursos como Conquistas e Salvamento na Nuvem, você precisará integrar a API da Steam, idealmente usando o plugin **GodotSteam** (ver Módulo 6).

### 3.3. Epic Games Store
-   **Nível:** Avançado. O processo é semelhante ao da Steam, mas a loja é mais curada.
-   **Processo:** Requer a criação de uma conta de desenvolvedor na Epic e a submissão do seu jogo para aprovação. O processo de upload e gerenciamento é feito através do portal de desenvolvedor da Epic.

---

## 4. Publicando em Lojas Mobile

### 4.1. Google Play Store (Android)
-   **Nível:** Intermediário.
-   **Processo:**
    1.  Crie uma conta de desenvolvedor no Google Play (taxa única).
    2.  **Assinatura do App:** Você precisa gerar uma "chave de assinatura" (`keystore`) para assinar seu `.apk` ou `.aab` (Android App Bundle). **NÃO PERCA ESTA CHAVE!** Sem ela, você não poderá atualizar seu jogo.
    3.  No Godot, em `Projeto -> Exportar... -> Android`, preencha as informações da sua chave de assinatura.
    4.  Crie sua listagem na loja no Google Play Console, faça o upload dos seus assets de marketing e do seu arquivo de jogo.
    5.  Preencha questionários de classificação de conteúdo e política de privacidade.
    6.  Envie para revisão.

### 4.2. Apple App Store (iOS)
-   **Nível:** Avançado.
-   **Processo:**
    1.  Requer uma assinatura anual do Apple Developer Program.
    2.  Requer um Mac com Xcode.
    3.  O processo envolve a criação de certificados, IDs de aplicativo e perfis de provisionamento no portal de desenvolvedor da Apple.
    4.  O build do Godot é exportado como um projeto Xcode, que é então compilado e enviado para a App Store Connect, a plataforma de gerenciamento da Apple.
    5.  O processo de revisão da Apple é notoriamente rigoroso.

---

## 5. Bônus: Marketing 101 para Desenvolvedores Indie

Publicar não é o suficiente. Você precisa fazer barulho.

-   **Comece Cedo:** Comece a falar sobre seu jogo meses antes do lançamento. Use o Twitter/X, TikTok, etc., com a hashtag `#GodotEngine` e `#indiedev`.
-   **GIFs e Vídeos Curtos:** São a moeda das redes sociais. Mostre sua mecânica mais legal, um efeito visual bonito ou um momento engraçado.
-   **Crie uma Comunidade:** Um servidor no Discord é um ótimo lugar para reunir seus primeiros fãs, obter feedback e criar um senso de comunidade.
-   **Wishlists são Ouro:** Na Steam, o número de wishlists que seu jogo tem no lançamento afeta diretamente a visibilidade que o algoritmo da Valve lhe dará. Incentive as pessoas a adicionarem seu jogo à lista de desejos.
-   **Contate a Imprensa e Influenciadores:** Prepare um e-mail curto e direto, com um link para seu trailer e press kit, e envie para jornalistas e YouTubers/Streamers que cobrem jogos do seu gênero. Não espere uma taxa de resposta alta, mas um único vídeo grande pode fazer toda a diferença.
