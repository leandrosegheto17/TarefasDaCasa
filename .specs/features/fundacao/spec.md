# Fundação — Especificação

> Feature 1 de 5 (AD-001). **Spec aprovada pelo usuário em 2026-10-27.** Entrada: [necessidade.md](../../produto/necessidade.md) (D-01 a D-06) e [padrao-ljs.md](../../produto/padrao-ljs.md). O design desta feature é a arquitetura comum do projeto. Referência de outro app no mesmo padrão: `C:\Leandro\Projetos\GestaoDaPelada_LJS\.specs\features\fundacao\` (liberada em 2026-10-26). Ela serve só de consulta e não é fonte de requisito.

## Problem Statement

O Tarefas da Casa nasce do zero no padrão LJS. Antes das regras de casa e tarefas, o projeto precisa de uma base que rode local e em produção com custo zero. Essa base tem que testar, publicar, fazer backup e restaurar de forma reproduzível, e isolar os dados por casa já no Postgres. Sem ela, cada feature seguinte reinventaria infraestrutura, e a família correria o risco de perder dados ou de ver os dados de outra casa.

## Goals

- [ ] Do clone ao app rodando local com `pnpm install`, `docker compose up -d`, `pnpm migrar`, `pnpm seed` e `pnpm dev`, sem nenhum passo manual fora do README.
- [ ] `tarefasdacasa.ljssoftware.com.br` publicado pelo `deploy.yml`, com `GET /api/health` respondendo 200 e o shell PWA instalável no visual do mockup aprovado.
- [ ] Migrations aplicadas do zero no CI e no Neon, com RLS forçada em toda tabela de negócio e o teste de isolamento entre casas passando.
- [ ] Backup diário cifrado rodando e uma restauração testada a partir de uma cópia limpa, registrada no runbook.

## Out of Scope

| Feature | Reason |
| ----------- | -------------- |
| Cadastro, login, sessão, recuperação, landing, termos, privacidade, exclusão de conta | Feature `conta-e-acesso`. Aqui `/` mostra uma página provisória |
| Criar casa, convites, perfis sem login (telas e rotas) | Feature `casa-e-membros`. Aqui entram só as tabelas mínimas para provar o isolamento |
| Tarefas, recorrência, histórico | Feature `tarefas-e-historico` |
| Envio de e-mail (Resend) e Web Push | Features `conta-e-acesso` e `lembretes`. Aqui entram só os nomes das variáveis em `.env.example` e os handlers vazios no service worker |
| Planos, cobrança (Asaas), "Meu plano" | Fora do roteiro (D-01) |
| Ambiente de homologação | Padrão LJS: sem homologação; o preview é o `wrangler dev` local |
| Criar as contas de Sentry e UptimeRobot | Ação do usuário. O código funciona sem elas (FUN-22, FUN-24) |

---

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --------------------- | --------------- | --------- | ---------- |
| Repositório | `leandrosegheto17/TarefasDaCasa`, **público** | Decisão do usuário (2026-10-27) | y |
| Repositório público e backup | O dump cifrado **não** fica como artefato do Actions de um repositório público. O destino privado do backup é escolhido no Design, custo zero, com fonte e data | Artefato de repositório público pode ser baixado por terceiros; mesmo cifrado, não deve ficar exposto. Decisão do usuário: manter público e mover o backup | y |
| Repositório público e documentos | `THREAT-MODEL.md`, runbook e ADRs ficam versionados, sem segredo, host interno, ID de recurso sensível ou dado pessoal; gitleaks no CI | Repositório público. O ID do Hyperdrive e o Project ID do Neon não são credenciais | y |
| Banco | Projeto Neon já criado pelo usuário: Project ID `odd-voice-50267467` (sa-east-1 PREMISSA, conferir no Design). Branch `main` = produção, `dev` = desenvolvimento | Decisão do usuário (2026-10-27) | y |
| Unidade de isolamento | `casa_id` (D-06). A conta da sessão só enxerga as casas em que tem vínculo de membro | D-06 | y |
| Tabelas da fundação | A fundação cria só o mínimo para provar o isolamento: `usuario` (id), `casa` (id, nome) e `membro` (casa, usuário opcional para o perfil sem login, papel). As features 2 e 3 estendem por migrations novas | Sem tabela não há como testar a RLS; o resto do schema pertence à feature que o usa | y |
| Um usuário em uma casa | O schema **não** impede várias casas por usuário (o vínculo é por `membro`); a regra "uma casa só" (PREMISSA de D-06) fica para a feature `casa-e-membros` | Restrição de negócio não deve ficar presa no schema da fundação | y |
| Rota de saúde | `GET /api/health`, sem tocar o banco | Padrão LJS | y |
| Página provisória em `/` | Página estática com o nome do app, no visual do mockup, e "Em breve", até a landing da feature 2 | Permite publicar e testar a instalabilidade já na fundação | y |
| Visual | O mockup (skill `mockup-visual`) é feito depois desta spec e antes das tarefas; o `tokens.css` aprovado em `.specs/mockup/` é a fonte do visual | Decisão do usuário (2026-10-27) | y |
| Sentry e UptimeRobot | As contas ainda não existem. O Sentry só liga com `SENTRY_DSN` presente; o monitor do UptimeRobot é um passo do runbook | Decisão do usuário (2026-10-27); custo zero | y |
| Cron Trigger | A fundação declara **um único** cron (handler sem efeito até a feature `lembretes`), para reservar o slot na conta | Limite de 5 por conta: ControleEmCasa usa 2, EvolucaoSegura 1 (conferido nos `wrangler.jsonc` em 2026-10-27); com GestaoDaPelada e este app, a conta fica no limite | y |
| Rate limit no Free | O binding `ratelimits` funciona no plano Free | O GestaoDaPelada_LJS foi liberado em 2026-10-26 com os mesmos bindings (resolve a dúvida da necessidade §4) | y |
| `namespace_id` do rate limit | Faixa própria 4001 a 4003 | GestaoDaPelada e EvolucaoSegura repetem 1001 a 1003; IDs iguais na mesma conta podem dividir contadores | y |
| Lighthouse PWA | Substituído por teste de instalabilidade no Playwright (FUN-35) | A categoria PWA saiu do Lighthouse (AD-005 do GestaoDaPelada_LJS) | y |
| Trava de testes | Ao existir a suíte, `.specs/projeto/testes.json` passa de `dispensado` para `{"comando": "pnpm test"}` | Regra de testes do projeto; a dispensa valeu só para o commit inicial | y |

**Open questions:** none - all resolved or logged above.

---

## User Stories

### P1: Ambiente local reproduzível ⭐ MVP

**User Story**: Como desenvolvedor da LJS, quero subir o app inteiro na minha máquina com comandos padrão, para desenvolver e testar sem depender da nuvem.

**Why P1**: Toda feature seguinte depende disso.

**Acceptance Criteria**:

1. The repositório SHALL ser um monorepo pnpm 11 com Node 24 (`engines` e `.nvmrc`), `type: module` e TypeScript estrito nos pacotes `backend/contrato`, `backend/dominio`, `backend/api`, `backend/scripts` e `frontend/web`. [FUN-01]
2. WHEN o desenvolvedor roda `pnpm lint`, `pnpm typecheck` ou `pnpm test` na raiz THEN o repositório SHALL executar o comando em todos os pacotes e sair com código 0 na base limpa. [FUN-02]
3. WHEN o desenvolvedor roda `docker compose up -d` THEN o compose SHALL subir só um Postgres 16 com `pgcrypto` disponível. [FUN-03]
4. WHEN o desenvolvedor roda `pnpm dev` THEN o repositório SHALL subir o `wrangler dev`, com o Hyperdrive apontando por `localConnectionString` para o Postgres local, e o Vite com proxy de `/api` para o Worker. [FUN-04]
5. WHEN o desenvolvedor roda `pnpm seed` num banco local migrado THEN o script SHALL criar duas casas de exemplo, cada uma com um usuário adulto e um perfil sem login, e SHALL recusar rodar se a URL do banco não for local. [FUN-05]
6. The pacote `backend/dominio` SHALL não importar nenhum módulo de I/O (rede, banco, `node:fs`), e um teste SHALL falhar se algum import desses aparecer. [FUN-06]

**Independent Test**: num clone limpo, os comandos do README levam a `http://localhost:5173` mostrando o shell e `GET /api/health` = 200.

---

### P1: Banco com migrations, roles e isolamento por casa ⭐ MVP

**User Story**: Como dono da LJS, quero que cada casa só enxergue os próprios dados já no Postgres, para não depender só do código da API.

**Why P1**: Isolamento obrigatório do padrão LJS (D-06). Todas as features escrevem nessas tabelas.

**Acceptance Criteria**:

1. The projeto SHALL gerenciar o schema com `node-pg-migrate`, uma migration por mudança, cada uma em transação. [FUN-07]
2. WHEN `pnpm migrar` roda num banco vazio THEN as migrations SHALL criar as tabelas `usuario`, `casa` e `membro`, e uma segunda execução SHALL não alterar nada. [FUN-08]
3. The banco SHALL ter as roles `owner` (DDL, usada só nas migrations), `app` (runtime, sem DDL e sem `TRUNCATE`, com `DELETE` só nas tabelas em que apagar é regra) e `backup_ro` (somente leitura). [FUN-09]
4. The banco SHALL ter RLS habilitada com `FORCE ROW LEVEL SECURITY` em toda tabela de negócio que contenha `casa_id`, e um teste SHALL falhar se uma tabela com `casa_id` não tiver RLS forçada. [FUN-10]
5. WHILE uma transação da role `app` tem `app.usuario_id` definido the banco SHALL expor nas tabelas de negócio apenas linhas de casas em que esse usuário tem vínculo em `membro`. [FUN-11]
6. IF uma transação da role `app` não define `app.usuario_id` THEN o banco SHALL retornar zero linhas nas tabelas de negócio. [FUN-12]
7. WHEN a API atende uma requisição que toca o banco THEN ela SHALL abrir uma transação por requisição e definir o contexto com `SET LOCAL` antes de qualquer consulta. [FUN-13]
8. IF o usuário da casa B tenta ler, inserir, alterar ou apagar uma linha da casa A THEN o banco SHALL não retornar a linha na leitura e SHALL afetar zero linhas ou recusar a escrita (teste negativo obrigatório, por tabela de negócio). [FUN-14]
9. The cache do Hyperdrive SHALL estar desligado para as consultas da aplicação. [FUN-15]

**Independent Test**: no Postgres local e no CI, a suíte de isolamento cria duas casas com usuários diferentes e prova FUN-11 a FUN-14.

---

### P1: Esqueleto publicado no domínio ⭐ MVP

**User Story**: Como dono da LJS, quero o app publicado em `tarefasdacasa.ljssoftware.com.br` desde a fundação, para que cada feature seguinte já chegue ao ar pelo caminho definitivo.

**Why P1**: A entrega de cada feature é publicar. O caminho de deploy precisa existir e ter sido testado antes.

**Acceptance Criteria**:

1. The Worker SHALL servir os assets de `frontend/web/dist` com `not_found_handling: single-page-application` e as rotas `/api/*` pelo Hono, com `run_worker_first: ["/api/*"]` e `nodejs_compat`. [FUN-16]
2. WHEN alguém faz `GET /api/health` THEN a API SHALL responder 200 com `{"status":"ok","versao":"<sha>"}` sem tocar o banco. [FUN-17]
3. The API SHALL responder toda rota `/api/*` com `Cache-Control: no-store` e `X-Content-Type-Options: nosniff`. [FUN-18]
4. The código e o banco SHALL não conter URL absoluta do app. A única fonte é a variável `URL_PUBLICA`, injetada no deploy, e um teste SHALL falhar se aparecer `ljssoftware.com.br` ou `workers.dev` fora da configuração permitida (`wrangler.jsonc` e `deploy.yml`). [FUN-19]
5. The Worker SHALL declarar os bindings de rate limit `LIMITE_ENTRAR` (10/min), `LIMITE_PUBLICO` (60/min) e `LIMITE_WEBHOOK` (60/min), com `namespace_id` 4001, 4002 e 4003. [FUN-20]
6. The Worker SHALL publicar a rota `tarefasdacasa.ljssoftware.com.br` com `custom_domain: true` e declarar exatamente um Cron Trigger, cujo handler termina sem efeito até a feature `lembretes`. [FUN-21]
7. WHERE `SENTRY_DSN` está configurado the Worker (`@sentry/cloudflare`) e o front (`@sentry/react`) SHALL reportar erros com `release` igual ao SHA do commit, removendo do evento corpo, cookies, cabeçalho `Authorization` e e-mails. [FUN-22]
8. IF `SENTRY_DSN` não está configurado THEN o app SHALL funcionar normalmente, sem enviar nada a terceiros. [FUN-23]
9. The runbook SHALL descrever a criação do monitor do UptimeRobot em `GET /api/health`. [FUN-24]
10. The páginas servidas pelo domínio SHALL incluir os cabeçalhos `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin` e `Strict-Transport-Security`, conferidos por um teste e2e contra o build. [FUN-25]

**Independent Test**: depois do primeiro `deploy.yml`, `curl https://tarefasdacasa.ljssoftware.com.br/api/health` = 200 com o SHA publicado, e a página `/` mostra o shell.

---

### P1: Shell PWA instalável ⭐ MVP

**User Story**: Como membro da família, quero abrir o Tarefas da Casa no celular como um aplicativo, para usá-lo sem procurar o endereço.

**Why P1**: A família usa pelo celular (necessidade §1). Todas as telas das features seguintes se apoiam nesse shell e nos componentes base.

**Acceptance Criteria**:

1. The front SHALL usar um `frontend/web/src/estilos/tokens.css` idêntico a `.specs/mockup/tokens.css`, e um teste SHALL falhar se divergirem. [FUN-26]
2. The front SHALL ter os componentes base do guia de estilo aprovado no mockup, cada um com teste de renderização e de acessibilidade (axe sem violações). [FUN-27]
3. The Stylelint SHALL recusar cor, fonte e sombra literais fora de `tokens.css`. [FUN-28]
4. The build SHALL gerar um manifest com nome "Tarefas da Casa", `display: standalone`, `lang: pt-BR` e ícones 192 e 512, um deles `maskable`. [FUN-29]
5. The service worker SHALL fazer precache do shell e registrar handlers dos eventos `push` e `notificationclick`, que ficam sem efeito até a feature `lembretes`. [FUN-30]
6. IF o usuário abre o app sem conexão numa rota que não está em cache THEN o service worker SHALL mostrar a página offline. [FUN-31]
7. WHEN o app é aberto no Safari do iOS fora do modo standalone THEN o front SHALL mostrar a instrução de instalação na tela inicial. [FUN-32]
8. WHEN o CI roda o teste de instalabilidade (Playwright contra o build) THEN ele SHALL confirmar o manifest válido (FUN-29), o service worker ativo controlando a página, os ícones 192 e 512 (um `maskable`) acessíveis e a página offline servida sem rede. [FUN-33]
9. The comparação visual (`.claude/scripts/comparar-visual.mjs`, viewports de 1280×800 e 390×844) SHALL rodar no CI e falhar se uma tela ativa divergir do mockup aprovado; na fundação, as telas ativas são a página provisória e a página offline. [FUN-34]

**Independent Test**: instalar o PWA a partir do build no Chrome do Android e no Safari do iOS, abrir sem rede e ver a página offline. A comparação visual e a instalabilidade ficam verdes no CI.

---

### P1: CI e deploy seguros ⭐ MVP

**User Story**: Como dono da LJS, quero que nada chegue à produção sem passar por testes e que o deploy siga sempre a mesma ordem segura, para não quebrar o banco nem publicar código vermelho.

**Why P1**: Padrão LJS. Pela regra do projeto, a suíte verde é condição para integrar e publicar.

**Acceptance Criteria**:

1. WHEN há push ou PR THEN o `ci.yml` SHALL rodar lint, typecheck, testes, gitleaks, build do web, migrations do zero num Postgres de serviço, teste de isolamento, comparação visual e instalabilidade, e SHALL falhar se qualquer um falhar. [FUN-35]
2. The `deploy.yml` SHALL ser disparável só por `workflow_dispatch` na `main`, no environment `producao`, com `concurrency` sem cancelamento. [FUN-36]
3. WHEN o `deploy.yml` roda THEN ele SHALL executar, nesta ordem e parando no primeiro erro: (1) build do web; (2) branch de restauração no Neon, mantendo só as 2 mais recentes; (3) dump cifrado no destino privado do backup; (4) migração com `NEON_URL_MIGRACAO` (role `owner`); (5) `wrangler deploy --var URL_PUBLICA:<url>`; (6) `GET /api/health` = 200 com o SHA publicado. [FUN-37]
4. IF o build do web falha THEN o `deploy.yml` SHALL parar antes de tocar o Neon ou o Worker. [FUN-38]
5. IF a migração falha THEN o `deploy.yml` SHALL não executar o `wrangler deploy`, e o runbook SHALL descrever como restaurar pela branch de restauração. [FUN-39]
6. The repositório SHALL ter `wrangler deploy` em um único lugar (o `deploy.yml`), e um teste SHALL falhar se aparecer em outro arquivo. [FUN-40]
7. The repositório SHALL não conter segredo versionado: o gitleaks roda no CI e o `.env.example` lista cada variável com obrigatoriedade, formato e se é segredo. [FUN-41]
8. The `.specs/projeto/testes.json` SHALL registrar `{"comando": "pnpm test"}` no lugar da dispensa do commit inicial. [FUN-42]

**Independent Test**: um PR com um teste quebrado fica vermelho. Um `deploy.yml` com um erro de build injetado para no passo 1 sem criar branch no Neon.

---

### P1: Backup e restauração ⭐ MVP

**User Story**: Como dono da LJS, quero backup diário cifrado, guardado fora do alcance público, e uma restauração testada, para recuperar os dados da família se algo der errado.

**Why P1**: Perder os dados é o risco principal do uso próprio. Padrão LJS.

**Acceptance Criteria**:

1. The `backup.yml` SHALL rodar todo dia às 04:00 de Brasília (07:00 UTC) e manualmente, fazendo `pg_dump -Fc` com a role `backup_ro` e cifrando com `age` (chave pública em secret, chave privada fora do GitHub). [FUN-43]
2. The `backup.yml` SHALL guardar o dump cifrado num destino privado (não acessível sem credencial), com retenção de 30 dias, e SHALL não publicá-lo como artefato do repositório público. [FUN-44]
3. IF o dump, a cifragem ou o envio falha THEN o `backup.yml` SHALL falhar visivelmente (job vermelho) e não deixar dump parcial no destino. [FUN-45]
4. WHEN o procedimento de restauração do runbook é seguido (baixar o dump, decifrar com a chave privada, `pg_restore` num Postgres local limpo ou numa branch Neon nova) THEN a contagem de linhas por tabela SHALL bater com a origem, e a execução SHALL ficar registrada no runbook com data e contagens. [FUN-46]

**Independent Test**: rodar o `backup.yml` manualmente, restaurar o dump num Postgres local limpo e conferir a contagem de linhas por tabela contra a produção.

---

### P2: Documentação e decisões

**User Story**: Como dono da LJS, quero README, runbook e a pasta `.md/` no padrão, para que qualquer pessoa (ou IA) opere o projeto sem depender da memória.

**Why P2**: Não bloqueia o código, mas o padrão exige.

**Acceptance Criteria**:

1. The README SHALL cobrir rodar local, variáveis, deploy e testes. [FUN-47]
2. The `docs/runbook.md` SHALL cobrir deploy, falha de migração, restauração de backup e rotação de segredos. [FUN-48]
3. The `.md/adr/` SHALL ter um ADR por decisão de arquitetura da fundação, com `Supersedes:` quando substituir outro. [FUN-49]
4. The `CLAUDE.md` da raiz SHALL descrever o contexto do projeto (stack, comandos, onde ficam regras e artefatos). [FUN-50]

**Independent Test**: um agente sem contexto segue o README num worktree limpo e chega ao app rodando.

---

## Edge Cases

- IF o Postgres local não está de pé THEN `pnpm dev` e `pnpm migrar` SHALL falhar com uma mensagem que diz para rodar `docker compose up -d`. [FUN-51]
- IF uma migration nova não é aditiva (apaga coluna ou tabela) THEN o CI SHALL falhar, a menos que a migration declare a exceção com um ADR. [FUN-52]
- WHEN duas execuções do `deploy.yml` são disparadas juntas THEN a segunda SHALL esperar a primeira terminar, sem cancelá-la. [FUN-53]
- IF `URL_PUBLICA` não está definida no deploy THEN o `deploy.yml` SHALL falhar antes do `wrangler deploy`. [FUN-54]

---

## Implicit-requirement sweep

| Dimensão | Cobertura |
|---|---|
| Validação de entrada e limites | FUN-05 (seed só local), FUN-54. Validação de payload de API: N/A because a fundação não expõe rota de negócio |
| Falha e falha parcial | FUN-38, FUN-39, FUN-45, FUN-51 |
| Idempotência e repetição | FUN-08 (migrar duas vezes), FUN-53 |
| Fronteiras de auth e rate limit | FUN-11 a FUN-14, FUN-20. Autenticação de usuário: N/A because entra na feature `conta-e-acesso`; HTTPS é garantido pelo custom domain do Worker e pelo HSTS (FUN-25) |
| Concorrência e ordem | FUN-37, FUN-53 |
| Ciclo de vida dos dados | FUN-44 (retenção de 30 dias), FUN-37 (2 branches de restauração) |
| Observabilidade | FUN-17, FUN-22, FUN-24 |
| Falha de dependência externa | FUN-23 (Sentry ausente), FUN-39 (Neon), FUN-45 (destino do backup) |
| Integridade de transições de estado | N/A because a fundação não tem máquina de estados de negócio |

---

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| -------------- | ----------- | ------ | ------- |
| FUN-01 | P1: Ambiente local | Design | Pending |
| FUN-02 | P1: Ambiente local | Design | Pending |
| FUN-03 | P1: Ambiente local | Design | Pending |
| FUN-04 | P1: Ambiente local | Design | Pending |
| FUN-05 | P1: Ambiente local | Design | Pending |
| FUN-06 | P1: Ambiente local | Design | Pending |
| FUN-07 | P1: Banco | Design | Pending |
| FUN-08 | P1: Banco | Design | Pending |
| FUN-09 | P1: Banco | Design | Pending |
| FUN-10 | P1: Banco | Design | Pending |
| FUN-11 | P1: Banco | Design | Pending |
| FUN-12 | P1: Banco | Design | Pending |
| FUN-13 | P1: Banco | Design | Pending |
| FUN-14 | P1: Banco | Design | Pending |
| FUN-15 | P1: Banco | Design | Pending |
| FUN-16 | P1: Esqueleto publicado | Design | Pending |
| FUN-17 | P1: Esqueleto publicado | Design | Pending |
| FUN-18 | P1: Esqueleto publicado | Design | Pending |
| FUN-19 | P1: Esqueleto publicado | Design | Pending |
| FUN-20 | P1: Esqueleto publicado | Design | Pending |
| FUN-21 | P1: Esqueleto publicado | Design | Pending |
| FUN-22 | P1: Esqueleto publicado | Design | Pending |
| FUN-23 | P1: Esqueleto publicado | Design | Pending |
| FUN-24 | P1: Esqueleto publicado | Design | Pending |
| FUN-25 | P1: Esqueleto publicado | Design | Pending |
| FUN-26 | P1: Shell PWA | Design | Pending |
| FUN-27 | P1: Shell PWA | Design | Pending |
| FUN-28 | P1: Shell PWA | Design | Pending |
| FUN-29 | P1: Shell PWA | Design | Pending |
| FUN-30 | P1: Shell PWA | Design | Pending |
| FUN-31 | P1: Shell PWA | Design | Pending |
| FUN-32 | P1: Shell PWA | Design | Pending |
| FUN-33 | P1: Shell PWA | Design | Pending |
| FUN-34 | P1: Shell PWA | Design | Pending |
| FUN-35 | P1: CI e deploy | Design | Pending |
| FUN-36 | P1: CI e deploy | Design | Pending |
| FUN-37 | P1: CI e deploy | Design | Pending |
| FUN-38 | P1: CI e deploy | Design | Pending |
| FUN-39 | P1: CI e deploy | Design | Pending |
| FUN-40 | P1: CI e deploy | Design | Pending |
| FUN-41 | P1: CI e deploy | Design | Pending |
| FUN-42 | P1: CI e deploy | Design | Pending |
| FUN-43 | P1: Backup | Design | Pending |
| FUN-44 | P1: Backup | Design | Pending |
| FUN-45 | P1: Backup | Design | Pending |
| FUN-46 | P1: Backup | Design | Pending |
| FUN-47 | P2: Documentação | Design | Pending |
| FUN-48 | P2: Documentação | Design | Pending |
| FUN-49 | P2: Documentação | Design | Pending |
| FUN-50 | P2: Documentação | Design | Pending |
| FUN-51 | Edge Cases | Design | Pending |
| FUN-52 | Edge Cases | Design | Pending |
| FUN-53 | Edge Cases | Design | Pending |
| FUN-54 | Edge Cases | Design | Pending |

**Coverage:** 54 total, 0 mapped to tasks, 54 unmapped ⚠️ (tarefas na fase Tasks)

---

## Success Criteria

- [ ] Um clone limpo chega ao app rodando local só com os comandos do README.
- [ ] `https://tarefasdacasa.ljssoftware.com.br/api/health` responde 200 com o SHA publicado, e o PWA instala no Android e no iOS.
- [ ] CI verde com isolamento entre casas, comparação visual e instalabilidade.
- [ ] Um backup restaurado num Postgres limpo com contagens conferidas e registradas no runbook.
