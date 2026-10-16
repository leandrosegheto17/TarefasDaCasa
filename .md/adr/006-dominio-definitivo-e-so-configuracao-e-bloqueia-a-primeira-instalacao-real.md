# ADR-006: A origem definitiva é `https://tarefas-da-casa-ljs.vercel.app`, definida só por configuração (`ORIGEM_PUBLICA`); outros hosts da produção são redirecionados e os previews ficam protegidos

- **Status:** Aceito (D-02 respondida pelo usuário na rodada 2 do Loop B, 2026-10-16)
- **Data:** 2026-10-16 (rodada 1); revisado em 2026-10-16 (rodada 2, antes da aceitação)
- **Decisor:** o domínio é escolha do **usuário** (D-02). O Coordenador decidiu como ele entra na arquitetura e registrou as implicações
- **Requisitos ligados:** RF-23, RNF-06, RNF-14, R-P3, D-02; ADR-001, ADR-002, ADR-004, ADR-005

## Histórico de revisão

| Rodada | Mudança |
|---|---|
| 1 | Domínio em aberto. Arquitetura independente do domínio |
| 2 | **D-02:** a origem definitiva é o subdomínio gratuito da Vercel `tarefas-da-casa-ljs.vercel.app`. Implicações registradas no item 7. A regra "o deploy falha se a origem apontar para um domínio do provedor" foi trocada por "falha se `ORIGEM_PUBLICA` for diferente do valor deste ADR" |

## Contexto

- **R-P3:** instalação, armazenamento, cookie e (na Fase 3) inscrição de push ficam presos à origem. Trocar a origem depois da primeira instalação na família exige reinstalar e revincular todos os aparelhos.
- **D-02 (rodada 2):** o usuário escolheu o subdomínio gratuito da Vercel em vez de um `.com.br` ou de um subdomínio próprio.
  - Isso zera o custo de domínio (RNF-14: R$ 0).
  - O PRD-TECNICO já listava essa alternativa ("domínio gratuito do provedor"), com o aviso de que ela fica presa para sempre ao provedor.
- A Vercel cria vários hosts para o mesmo projeto:
  - a URL de produção do projeto (`<projeto>.vercel.app`);
  - URLs por deploy (`<projeto>-<hash>-<escopo>.vercel.app`);
  - URLs por branch (`<projeto>-git-<branch>-<escopo>.vercel.app`).
- O sufixo `vercel.app` está na Public Suffix List. Para o navegador, cada subdomínio é um "site" separado.

## Decisão

1. **Origem definitiva:** `ORIGEM_PUBLICA=https://tarefas-da-casa-ljs.vercel.app`.
2. **Nenhum domínio no código nem no build.**
   - O manifest e o service worker usam caminhos relativos.
   - Os cookies são host-only, sem o atributo `Domain`.
   - O valor só existe na variável de ambiente de produção e neste ADR.
3. **A API usa `ORIGEM_PUBLICA` para:**
   - validar o cabeçalho `Origin` nas requisições que alteram dados (ADR-004);
   - montar o endereço do QR de instalação (RF-06 CA-06.3, Could).
4. **Produção:** toda requisição que chega ao deploy de produção por um host diferente de `tarefas-da-casa-ljs.vercel.app` recebe `308` para a origem definitiva.
   - Isso inclui a URL por deploy e a URL de branch da `main`.
   - Fica configurado no `vercel.json` (redirect condicionado ao host) e, por reforço, no middleware da API.
5. **Previews e desenvolvimento** (uso exclusivo do desenvolvedor):
   - os previews **não redirecionam**, porque precisam funcionar para o desenvolvedor testar;
   - usam **banco separado**, um branch do Neon, nunca o banco de produção;
   - mostram a faixa **"AMBIENTE DE TESTE"** em toda tela (UX-SPEC G3), sempre que o host for diferente de `ORIGEM_PUBLICA`;
   - ficam atrás da **proteção de deploy da Vercel** (Vercel Authentication nos previews), para que ninguém da família consiga abrir, e muito menos instalar. A disponibilidade no Hobby será confirmada no spike de infraestrutura. Sem essa proteção, a faixa G3 e o banco separado continuam valendo.
6. **Trava no deploy:** o deploy de produção falha se `ORIGEM_PUBLICA` estiver vazia ou diferente de `https://tarefas-da-casa-ljs.vercel.app`.
7. **Implicações de usar `*.vercel.app` como origem definitiva** (avaliadas na rodada 2):

   | Implicação | Avaliação | Tratamento |
   |---|---|---|
   | **Nome do projeto** | A URL de produção nasce do nome do projeto. Se o nome já estiver em uso por outra conta, a Vercel acrescenta um sufixo e a URL muda | **Ação imediata do usuário:** criar o projeto `tarefas-da-casa-ljs` agora e conferir que a URL de produção é exatamente `tarefas-da-casa-ljs.vercel.app`. Faz parte do spike de infraestrutura e é pré-requisito do resto. **Nunca renomear nem apagar o projeto:** apagar libera o nome, e a origem pode se perder para sempre |
   | **Irreversibilidade (R-P3)** | Não dá para migrar a origem depois sem perder instalação, sessão e (na Fase 3) inscrição de push. Um domínio próprio adicionado no futuro seria **outra** origem: exigiria reinstalar e revincular todos os aparelhos | Aceito pelo usuário. O plano B do ADR-002 (API ou agendador na VM, atrás de um rewrite) **preserva** a origem. Só a troca do próprio front-end de provedor exigiria reinstalar tudo |
   | **Dependência da conta Vercel** | Se a conta ou o projeto forem suspensos ou apagados, a origem se perde. Também vale se a Vercel mudar a regra do `vercel.app` | Risco RT-11 (SDD §6). Os dados estão a salvo no Neon e no backup (ADR-007). A recuperação seria uma nova origem com reinstalação, e o procedimento fica no `DEPLOY.md` |
   | **Cookie e Public Suffix List** | O navegador não aceita cookie com `Domain=vercel.app` (sufixo público), mas este desenho **não usa** `Domain`. O cookie host-only de `tarefas-da-casa-ljs.vercel.app` funciona normalmente. Como cada subdomínio é um site separado, cookies de outros projetos `*.vercel.app` (inclusive os previews deste) **não** chegam à origem nem a afetam | Sem mudança no ADR-004. Uma vantagem: a sessão de um preview nunca vaza para a produção |
   | **Limite do Safari para cookie de servidor de outro subdomínio** | Não se aplica: página e API estão no mesmo host (ADR-001) | — |
   | **HSTS** | O TLD `.app` inteiro está na lista de pré-carga de HSTS dos navegadores, então HTTPS é obrigatório de qualquer forma. O cabeçalho próprio continua (`max-age=31536000`), **sem** `includeSubDomains` e **sem** `preload`, porque não controlamos o domínio-pai | Ajuste na SDD §7 |
   | **Confiança e phishing** | Qualquer pessoa pode criar `tarefas-da-casa-algo.vercel.app` parecido | Baixo para uso familiar: a instalação é feita pelo próprio usuário em cada aparelho (B8). O código de vínculo nunca vai em link (IR-05) |
   | **Certificado TLS** | Gerenciado pela Vercel, sem nenhuma ação nossa | — |
8. **Bloqueio de processo:** a origem definitiva precisa estar confirmada (projeto criado, URL exata, HTTPS respondendo) **antes da primeira instalação em aparelho da família**. Isso vale para o início do bloco B8, ou antes, se houver teste num aparelho da família.

## Consequências

**Positivas**
- **Custo zero** e nenhuma configuração de DNS.
- O desenvolvimento não dependeu da decisão. Como só a configuração muda, a resposta do D-02 não mexeu em código.
- O redirecionamento e a proteção dos previews impedem o erro mais caro do projeto: instalar no endereço errado.

**Negativas**
- **Origem presa à Vercel para sempre.** Trocar o provedor do front-end ou adotar um domínio próprio custa reinstalar e revincular toda a família.
- A origem depende da continuidade da conta e do projeto na Vercel (RT-11).
- O nome precisa estar disponível. Se não estiver, a decisão volta ao usuário antes de qualquer outra coisa.
- A faixa G3, o redirecionamento por host e a trava de deploy são três peças pequenas a implementar e testar.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| `.com.br` novo (~R$ 40/ano) | Independente do provedor, mas o usuário preferiu custo zero |
| Subdomínio de um domínio do usuário | Independente do provedor e sem custo extra. O usuário preferiu o `vercel.app` |
| Domínio fixo no build | Força rebuild por ambiente e espalha o domínio pelo código |
| Confiar só na disciplina de não instalar no endereço errado | O erro é irreversível. Um redirecionamento custa pouco |
