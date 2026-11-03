# Fundação — Tarefas

## Protocolo de Execução (OBRIGATÓRIO — não pular)

Implemente estas tarefas com a skill `tlc-spec-driven`: **acione-a pelo nome e siga o fluxo de Execute e as Critical Rules.** Não procure arquivos da skill por caminho. A skill é a fonte da verdade do fluxo completo (ciclo por tarefa, delegação a subagentes, revisão de adequação, Verificador, sensor de discriminação).

**Se a skill não puder ser acionada, PARE e avise o usuário. Não prossiga sem ela.**

---

**Design**: `.specs/features/fundacao/design.md`
**Spec**: `.specs/features/fundacao/spec.md`
**Status**: Approved (usuário, 2026-10-27; execução ainda não iniciada)

> Premissas desta lista:
> - O código nasce na raiz deste repositório. Os caminhos `pelada:` são relativos a `C:\Leandro\Projetos\GestaoDaPelada_LJS` (commit `9a4afab`) e são somente leitura (AD-002).
> - **Teste copiado do Pelada só entra ligado a um `FUN-NN`**, indicado em cada tarefa. O verificador recusa ligação sem asserção correspondente.
> - Cada tarefa tem **Estimativa** de até 2 h de trabalho humano (regra de Tarefas do `CLAUDE.md`). Tarefa que estourar a estimativa é dividida, não prorrogada.
> - Nomes de pacote: `@tarefas/contrato`, `@tarefas/dominio`, `@tarefas/api`, `@tarefas/web`. `backend/scripts` não tem `package.json` próprio: roda com o Vitest da raiz.
> - **A execução desta lista começa só depois de aprovada. As fases 22 e 23 têm ações externas (Cloudflare, GitHub, produção): cada uma exige confirmação específica do usuário no momento, mesmo com a lista aprovada.**
> - `git push`, mudar a visibilidade do repositório e `wrangler deploy` nunca rodam sem essa confirmação.

---

## Test Coverage Matrix

> Gerada a partir do padrão LJS e do design. Confirmar antes do Execute. Guias encontrados: `.specs/produto/padrao-ljs.md` (§3: Vitest, `@cloudflare/vitest-pool-workers` (hoje `@cloudflare/vitest-plugin`), Testing Library, Playwright para o e2e crítico). Sem `AGENTS.md`, `CONTRIBUTING.md` nem limiar de cobertura. Padrão forte aplicado: todo critério de aceite e todo caso limite da spec tem teste.

| Camada | Tipo de teste exigido | Expectativa de cobertura | Padrão de local | Comando |
| ------ | --------------------- | ------------------------ | --------------- | ------- |
| Domínio (`backend/dominio`) e contrato (`backend/contrato`) | unit | Todos os ramos; 1:1 com os critérios. Na fundação: só FUN-06 (sem I/O) e o schema de saúde | `backend/{dominio,contrato}/test/**/*.test.ts` | `pnpm --filter @tarefas/dominio test` |
| Banco: migrations, roles, RLS | integration (Postgres real, `DATABASE_URL_TESTE`) | Cada migration aplica do zero e uma segunda vez sem alterar nada; cenários de isolamento por tabela com `casa_id` (A lê só o seu, B não lê/insere/altera/apaga, sem contexto = zero linhas) | `backend/api/test/{migracoes,isolamento}/**/*.test.ts` | `pnpm --filter @tarefas/api test` |
| Rotas e middlewares da API | e2e no pool workerd | Toda rota em escopo (`/api/health`): caminho feliz, cabeçalhos e erro | `backend/api/test/rotas/**/*.test.ts` | `pnpm --filter @tarefas/api test` |
| Scripts, checagens e ESLint | unit | Cada checagem: caso que passa e caso que falha | `backend/scripts/**/test/*.test.*`, `eslint/test/*.test.mjs` | `pnpm test:checagens` |
| Front: componentes e lógica | unit (jsdom + Testing Library + axe) | Cada componente: renderização e axe sem violações; cada módulo de lógica: todos os ramos | `frontend/web/src/**/*.test.{ts,tsx}` | `pnpm --filter @tarefas/web test` |
| Front: PWA, cabeçalhos, instalabilidade | e2e (Playwright contra o build) | Manifest, SW controlando a página, ícones, offline e cabeçalhos | `frontend/web/e2e/*.spec.ts` | `pnpm --filter @tarefas/web e2e` |
| Front: comparação visual | e2e visual (limite de 1% de pixels) | Toda tela ativa em `telas.json` nos dois viewports | `.specs/mockup/telas.json` | `pnpm --filter @tarefas/web visual` |
| Workflows, `.env.example`, docs, ADRs, config de build | none (gate de build e checagens do CI) | — | — | gate de build |

## Gate Check Commands

> Gerados a partir do padrão LJS (`ci.yml` do Pelada). Confirmar antes do Execute. O gate local roda o mesmo que o CI. Nas fases iniciais, o Build roda só os comandos que já existem.

| Nível do gate | Quando usar | Comando |
| ------------- | ----------- | ------- |
| Quick | Tarefas só com testes unitários, no pacote tocado | `pnpm --filter <pacote> test` (ou `pnpm test:checagens` para `backend/scripts` e `eslint/`) |
| Full | Tarefas com integration ou e2e. Exige `docker compose up -d` e `DATABASE_URL_TESTE` | `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e` |
| Build | Fim de fase e tarefas só de config, workflow ou docs | `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual` |

O comando de `.specs/projeto/testes.json` é `pnpm test` (T10); a checagem final antes de integrar roda o gate de Build completo.

---

## Execution Plan

As fases rodam em ordem; dentro da fase, as tarefas rodam na ordem numérica.

### Phase 1: Repositório e ferramentas (parte 1 de 2)

```
T1 → T2
T2 → T3
T2 → T4
T2 → T5
```

### Phase 2: Repositório e ferramentas (parte 2 de 2)

```
T6 → T9
T8 → T9
T7 → T9
T9 → T10
```

### Phase 3: Checagens do CI

```
T11 → T12
T11 → T13
T11 → T14
T11 → T15
```

### Phase 4: Banco: migrations e roles (parte 1 de 2)

```
T16 → T18
T17 → T18
```

### Phase 5: Banco: migrations e roles (parte 2 de 2)

```
T19 → T20
T20 → T21
T21 → T22
```

### Phase 6: Banco: RLS, isolamento e seed (parte 1 de 2)

```
T23 → T24
T24 → T25
```

### Phase 7: Banco: RLS, isolamento e seed (parte 2 de 2)

```
T26 → T29
T27 → T29
T28
T30
```

### Phase 8: API (Worker, Hono, contexto de banco) (parte 1 de 2)

```
T32 → T33
T33 → T34
T31 → T34
T33 → T35
```

### Phase 9: API (Worker, Hono, contexto de banco) (parte 2 de 2)

```
T36 → T37
T38
T39
```

### Phase 10: Front base (parte 1 de 2)

```
T40 → T41
T41 → T42
```

### Phase 11: Front base (parte 2 de 2)

```
T43 → T44
T45
```

### Phase 12: Componentes do guia de estilo (parte 1 de 2)

```
T46 → T47
T46 → T48
T46 → T49
T46 → T50
```

### Phase 13: Componentes do guia de estilo (parte 2 de 2)

```
T51
T52
T53
T54
```

### Phase 14: Shell PWA e ferramentas de execução local (parte 1 de 3)

```
T55 → T56
T57 → T58
```

### Phase 15: Shell PWA e ferramentas de execução local (parte 2 de 3)

```
T59 → T60
T61
T62
```

### Phase 16: Shell PWA e ferramentas de execução local (parte 3 de 3)

```
T63 → T64
T63 → T65
```

### Phase 17: CI, deploy e backup (parte 1 de 3)

```
T66 → T69
T67 → T69
T68
```

### Phase 18: CI, deploy e backup (parte 2 de 3)

```
T70 → T71
T72
```

### Phase 19: CI, deploy e backup (parte 3 de 3)

```
T73 → T74
T74 → T75
```

### Phase 20: Documentação (parte 1 de 2)

```
T76
T77
T78
```

### Phase 21: Documentação (parte 2 de 2)

```
T79
T80
```

### Phase 22: Entrega (ações externas, cada uma com confirmação) (parte 1 de 2)

```
T81 → T82
T82 → T83
```

### Phase 23: Entrega (ações externas, cada uma com confirmação) (parte 2 de 2)

```
T84 → T85
T84 → T86
```

---

## Task Breakdown

### Phase 1: Repositório e ferramentas (parte 1 de 2) (tarefas)

### T1: package.json e workspace da raiz

**What**: Criar o `package.json` da raiz (`type: module`, `engines` Node >=24 <25, `packageManager` pnpm 11), o `pnpm-workspace.yaml` com os cinco pacotes e o `.nvmrc` com 24.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `package.json`
**Depends on**: None
**Reuses**: pelada:package.json, pnpm-workspace.yaml (`minimumReleaseAge`, `trustPolicy`)
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm install` roda sem erro
- [ ] `engines`, `packageManager` e `.nvmrc` dizem Node 24 e pnpm 11
- [ ] Os cinco pacotes aparecem em `pnpm -r list`
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T2: tsconfig.base.json estrito

**What**: Criar `tsconfig.base.json` com `strict`, `noUncheckedIndexedAccess`, `module: NodeNext` e as demais opções do Pelada.
**Estimativa**: 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `tsconfig.base.json`
**Depends on**: T1
**Reuses**: pelada:tsconfig.base.json
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Opções estritas ligadas
- [ ] Arquivo reutilizável por `extends` nos cinco pacotes
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T3: Esqueletos de backend/contrato e backend/dominio

**What**: Criar os dois pacotes (`@tarefas/contrato`, `@tarefas/dominio`) com `package.json`, `tsconfig.json`, `src/index.ts` vazio e um teste de fumaça cada.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `backend/dominio/package.json`
**Depends on**: T2
**Reuses**: pelada:backend/contrato, backend/dominio
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm --filter @tarefas/dominio test` e `@tarefas/contrato test` passam
- [ ] `type: module` e TypeScript estrito nos dois
- [ ] Gate check passa: `pnpm --filter @tarefas/dominio test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T4: Esqueleto de backend/api com Vitest da Cloudflare

**What**: Criar o pacote `@tarefas/api` com `package.json`, `tsconfig.json`, `vitest.config.ts` (`@cloudflare/vitest-plugin`) e um teste de fumaça no pool workerd.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/vitest.config.ts`
**Depends on**: T2
**Reuses**: pelada:backend/api/vitest.config.ts, package.json
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Teste de fumaça roda no pool workerd
- [ ] `compatibility_date` aceita pelo workerd do plugin
- [ ] Gate check passa: `pnpm --filter @tarefas/api test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T5: Esqueleto de backend/scripts e eslint/

**What**: Criar `backend/scripts/` (sem `package.json` próprio, roda com o Vitest da raiz) com `tsconfig.json` e um teste de fumaça; criar o script raiz `test:checagens`.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `backend/scripts/tsconfig.json`
**Depends on**: T2
**Reuses**: pelada:backend/scripts/tsconfig.json, package.json (`test:checagens`)
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm test:checagens` roda o teste de fumaça
- [ ] TypeScript estrito em `backend/scripts`
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 2: Repositório e ferramentas (parte 2 de 2) (tarefas)

### T6: Esqueleto de frontend/web

**What**: Criar o pacote `@tarefas/web` com `package.json`, `tsconfig.json`, `vite.config.ts` (Vitest com jsdom, `vitest` declarado no pacote) e um teste de fumaça.
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/vite.config.ts`
**Depends on**: T2
**Reuses**: pelada:frontend/web/package.json, vite.config.ts
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm --filter @tarefas/web test` passa
- [ ] `vitest` está nas dependências do próprio pacote, não içado da raiz
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T7: Prettier, .gitattributes e .gitignore

**What**: Criar `.prettierrc.json`, `.prettierignore`, `.gitattributes` com `* text=auto eol=lf` e `.gitignore` (node_modules, dist, .wrangler, .env).
**Estimativa**: 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `.gitattributes`
**Depends on**: T1
**Reuses**: pelada:.prettierrc.json, .gitattributes
**Requirement**: FUN-01

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm format:check` passa na base limpa
- [ ] Arquivos de texto saem com `eol=lf` (o `tokens.css` precisa ser idêntico byte a byte)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T8: ESLint com a regra de domínio sem I/O

**What**: Criar `eslint.config.mjs` (typescript-eslint, import-x) e o plugin local com a regra que proíbe `node:fs`, rede e banco em `backend/dominio`, com teste de fixture.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `eslint.config.mjs`
**Depends on**: T3, T5
**Reuses**: pelada:eslint.config.mjs, eslint/
**Requirement**: FUN-06

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Fixture com `import 'node:fs'` em `backend/dominio` falha no lint
- [ ] `backend/dominio` limpo passa
- [ ] `pnpm lint` passa na base limpa
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T9: Scripts lint, typecheck e test na raiz

**What**: Definir `lint`, `typecheck`, `test` e `test:checagens` na raiz, executando todos os pacotes (`pnpm -r`), e provar que saem com código 0 na base limpa.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `package.json`
**Depends on**: T3, T4, T5, T6, T8, T7
**Reuses**: pelada:package.json (scripts)
**Requirement**: FUN-02

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm lint`, `pnpm typecheck` e `pnpm test` saem com 0 na base limpa
- [ ] O comando roda nos cinco pacotes (saída lista cada um)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T10: testes.json com o comando da suíte

**What**: Trocar `{"dispensado": true}` por `{"comando": "pnpm test"}` em `.specs/projeto/testes.json` e rodar `python .claude/scripts/trava-testes.py --rodar`.
**Estimativa**: 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `.specs/projeto/testes.json`
**Depends on**: T9
**Reuses**: —
**Requirement**: FUN-42

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `testes.json` registra `pnpm test`
- [ ] `trava-testes.py --rodar` sai verde
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 3: Checagens do CI (tarefas)

### T11: Helpers das checagens (arquivos e YAML)

**What**: Copiar `arquivos.mjs` (lista arquivos versionados) e `yaml-estrutura.mjs` (lê a estrutura dos workflows) com testes.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/checagens/arquivos.mjs`
**Depends on**: T5
**Reuses**: pelada:backend/scripts/checagens/arquivos.mjs, yaml-estrutura.mjs
**Requirement**: FUN-19

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Cada helper tem teste que passa e teste que falha
- [ ] Nenhuma checagem depende de caminho absoluto
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T12: Checagem de URL absoluta

**What**: Copiar `checar-urls-absolutas.mjs`: falha se `ljssoftware.com.br` ou `workers.dev` aparecer fora de `wrangler.jsonc` e `deploy.yml`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/checagens/checar-urls-absolutas.mjs`
**Depends on**: T11
**Reuses**: pelada:backend/scripts/checagens/checar-urls-absolutas.mjs
**Requirement**: FUN-19

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Repositório limpo passa
- [ ] Fixture com a URL num `.ts` falha e aponta arquivo:linha
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T13: Checagem de wrangler deploy único

**What**: Copiar `checar-wrangler-deploy.mjs`: falha se `wrangler deploy` aparecer em qualquer arquivo que não seja o `deploy.yml`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/checagens/checar-wrangler-deploy.mjs`
**Depends on**: T11
**Reuses**: pelada:backend/scripts/checagens/checar-wrangler-deploy.mjs
**Requirement**: FUN-40

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Só `deploy.yml` passa
- [ ] Fixture com `wrangler deploy` em outro arquivo falha
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T14: Checagem de actions fixadas por SHA

**What**: Copiar `checar-acoes-fixadas.mjs`: falha se um `uses:` de workflow não estiver fixado por SHA de 40 caracteres.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/checagens/checar-acoes-fixadas.mjs`
**Depends on**: T11
**Reuses**: pelada:backend/scripts/checagens/checar-acoes-fixadas.mjs
**Requirement**: FUN-35

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `uses: x@<sha>` passa
- [ ] `uses: x@v4` falha
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T15: Checagem de migration aditiva

**What**: Copiar `checar-migracao-aditiva.mjs` e `sql-normalizado.mjs` ajustando ao nome de arquivo do `node-pg-migrate`: falha em `DROP COLUMN`/`DROP TABLE` sem exceção declarada em ADR.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/checagens/checar-migracao-aditiva.mjs`
**Depends on**: T11
**Reuses**: pelada:backend/scripts/checagens/checar-migracao-aditiva.mjs, sql-normalizado.mjs
**Requirement**: FUN-52

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Migration só com `CREATE`/`ALTER ADD` passa
- [ ] `DROP COLUMN` sem exceção falha; com exceção citando o ADR passa
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 4: Banco: migrations e roles (parte 1 de 2) (tarefas)

### T16: docker-compose.yml com Postgres 16

**What**: Criar `docker-compose.yml` com um serviço Postgres 16 (porta 5433 no host) e script de init que garante `pgcrypto` disponível.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `docker-compose.yml`
**Depends on**: T9
**Reuses**: pelada:docker-compose.yml
**Requirement**: FUN-03

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `docker compose up -d` sobe só o Postgres
- [ ] `CREATE EXTENSION pgcrypto` funciona no banco do compose
- [ ] Teste de integração conecta e consulta `select 1`
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T17: Trava de host para migrar e seed

**What**: Copiar `exigirHostPermitido` e a leitura de `.env`: recusa operar fora de `localhost`/`127.0.0.1` (usado por `seed` e `migrar --alvo local`).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/comum/host.ts`
**Depends on**: T5
**Reuses**: pelada:backend/scripts/comum/
**Requirement**: FUN-05

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] URL local passa
- [ ] URL do Neon é recusada com mensagem clara
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T18: Runner pnpm migrar

**What**: Criar `migrar.ts` sobre `node-pg-migrate` 9 com `--no-single-transaction` e advisory lock; se o Postgres não responde, aborta com 'Rode docker compose up -d'.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/migrar.ts`
**Depends on**: T16, T17
**Reuses**: pelada:backend/scripts/migrar.ts
**Requirement**: FUN-07, FUN-51

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Cada migration roda na sua transação
- [ ] Postgres fora do ar gera a mensagem com `docker compose up -d`
- [ ] Duas execuções seguidas não alteram o banco (`pgmigrations` igual)
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### Phase 5: Banco: migrations e roles (parte 2 de 2) (tarefas)

### T19: Migration 001: extensões

**What**: Criar a migration `001_extensoes` com `CREATE EXTENSION IF NOT EXISTS pgcrypto`.
**Estimativa**: 30 min
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/infraestrutura/db/migracoes/001_extensoes.sql`
**Depends on**: T18
**Reuses**: pelada:migrações SQL (formato `-- Up Migration`)
**Requirement**: FUN-08

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm migrar` num banco vazio aplica a migration
- [ ] `gen_random_uuid()` e `crypt()` funcionam
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T20: Migration 002: roles

**What**: Criar `002_roles` com `tarefas_app NOLOGIN NOBYPASSRLS` e `tarefas_backup NOLOGIN` (idempotente); as senhas ficam fora do repositório.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/infraestrutura/db/migracoes/002_roles.sql`
**Depends on**: T19
**Reuses**: pelada:migração de roles do Pelada (`pelada_app`, `pelada_backup`)
**Requirement**: FUN-09

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] As duas roles existem após migrar
- [ ] `tarefas_app` tem `rolbypassrls = false`
- [ ] Rodar de novo não falha
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T21: Migration 003: usuario, casa e membro

**What**: Criar `003_casa_membro_usuario` com as três tabelas do design (`membro.usuario_id` nulo = perfil sem login; `UNIQUE (casa_id, usuario_id)`).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/infraestrutura/db/migracoes/003_casa_membro_usuario.sql`
**Depends on**: T20
**Reuses**: design.md (Data Models)
**Requirement**: FUN-08

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] As três tabelas existem com as restrições do design
- [ ] Nome da casa vazio ou maior que 60 é recusado
- [ ] Migrar duas vezes não altera nada
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T22: Migration 004: funções de contexto

**What**: Criar `004_funcoes_contexto` com `app_usuario_id()` e `casas_visiveis()` (`SECURITY DEFINER`, `search_path = public, pg_temp`, `REVOKE ALL FROM PUBLIC`, `GRANT EXECUTE` a `tarefas_app`).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: sim
**Where**: `backend/api/src/infraestrutura/db/migracoes/004_funcoes_contexto.sql`
**Depends on**: T21
**Reuses**: pelada:`grupos_visiveis()`
**Requirement**: FUN-11

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Sem contexto, `casas_visiveis()` devolve vazio
- [ ] Com `app.usuario_id` definido, devolve só as casas do usuário
- [ ] Só `tarefas_app` executa a função
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### Phase 6: Banco: RLS, isolamento e seed (parte 1 de 2) (tarefas)

### T23: Migration 005: RLS forçada em casa e membro

**What**: Criar `005_rls` com `ENABLE` + `FORCE ROW LEVEL SECURITY` e as policies de leitura e escrita (`WITH CHECK` com `app_usuario_id() IS NOT NULL`) em `casa` e `membro`.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: sim
**Where**: `backend/api/src/infraestrutura/db/migracoes/005_rls.sql`
**Depends on**: T22
**Reuses**: pelada:migração `…_rls.sql`
**Requirement**: FUN-10, FUN-11

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `relrowsecurity` e `relforcerowsecurity` verdadeiros nas duas tabelas
- [ ] Policies de leitura e escrita existem
- [ ] Escrita sem usuário definido é recusada
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T24: Migration 006: grants, usuario e backup

**What**: Criar `006_grants` com os grants de `tarefas_app` (`SELECT/INSERT/UPDATE` em `casa` e `membro`, `DELETE` em `membro`), RLS de `usuario` (`id = app_usuario_id()`, sem grant ainda) e `SELECT` + policy `USING (true)` para `tarefas_backup`.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: sim
**Where**: `backend/api/src/infraestrutura/db/migracoes/006_grants.sql`
**Depends on**: T23
**Reuses**: pelada:grants do Pelada
**Requirement**: FUN-09, FUN-10

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `tarefas_app` não tem `TRUNCATE`, DDL nem `DELETE` em `casa`
- [ ] `tarefas_backup` lê todas as linhas de todas as tabelas
- [ ] `tarefas_app` não lê `usuario`
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T25: Apoio de teste: banco temporário e cenário de duas casas

**What**: Copiar o apoio (banco temporário por suíte, conexão como `tarefas_app`, contagem de linhas por tabela) e criar o cenário com duas casas, um usuário adulto e um perfil sem login cada.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/test/apoio/cenario-casas.ts`
**Depends on**: T24
**Reuses**: pelada:backend/api/test/apoio/
**Requirement**: FUN-14

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] O cenário cria as duas casas pelo `owner`
- [ ] Consultas como `tarefas_app` respeitam a RLS
- [ ] Cada suíte usa banco próprio e limpa depois
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### Phase 7: Banco: RLS, isolamento e seed (parte 2 de 2) (tarefas)

### T26: Isolamento: leitura

**What**: Teste de isolamento no banco, como `tarefas_app`, para `casa` e `membro`: o usuário A lê só os próprios dados e o usuário B não lê nada da casa A.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/test/isolamento/leitura.test.ts`
**Depends on**: T25
**Reuses**: pelada:backend/api/test/isolamento/
**Requirement**: FUN-11, FUN-14

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] A lê 1 casa e os membros dela
- [ ] B lê zero linhas da casa A
- [ ] Cada tabela de negócio tem um caso de leitura
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T27: Isolamento: escrita

**What**: Teste de isolamento: o usuário B não insere, não altera e não apaga linhas da casa A (zero linhas afetadas ou erro de policy).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/test/isolamento/escrita.test.ts`
**Depends on**: T25
**Reuses**: pelada:backend/api/test/isolamento/
**Requirement**: FUN-14

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] INSERT com `casa_id` de A falha para B
- [ ] UPDATE e DELETE de B afetam 0 linhas
- [ ] Estado da casa A é idêntico antes e depois
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T28: Isolamento: sem contexto

**What**: Teste: transação de `tarefas_app` sem `app.usuario_id` lê zero linhas e não escreve em nenhuma tabela de negócio (inclui `usuario`).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/test/isolamento/sem-contexto.test.ts`
**Depends on**: T25
**Reuses**: pelada:backend/api/test/isolamento/
**Requirement**: FUN-12

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] SELECT devolve 0 linhas em cada tabela
- [ ] INSERT é recusado
- [ ] `usuario` fica ilegível mesmo com grant futuro
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T29: Meta-teste: toda tabela com casa_id tem RLS forçada

**What**: Teste que lista as tabelas com coluna `casa_id` no catálogo e falha se alguma não tiver `FORCE ROW LEVEL SECURITY` ou caso de isolamento.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/test/isolamento/meta.test.ts`
**Depends on**: T26, T27
**Reuses**: pelada:backend/api/test/isolamento/meta
**Requirement**: FUN-10

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Passa com `membro`
- [ ] Falha numa tabela fixture com `casa_id` sem RLS (e a fixture é removida no fim)
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T30: pnpm seed

**What**: Criar `seed-local.ts`: define a senha de login das roles a partir do `.env`, cria duas casas de exemplo (nomes fictícios), cada uma com um adulto e um perfil sem login; recusa host não local.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/seed-local.ts`
**Depends on**: T17, T24
**Reuses**: pelada:backend/scripts/seed-local.ts
**Requirement**: FUN-05

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Num banco local migrado cria 2 casas e 4 membros
- [ ] Contra a URL do Neon recusa sem tocar nada
- [ ] Rodar duas vezes não duplica
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### Phase 8: API (Worker, Hono, contexto de banco) (parte 1 de 2) (tarefas)

### T31: Contrato: esquema da resposta de saúde

**What**: Criar em `@tarefas/contrato` o schema Zod `{status:'ok', versao:string}` e o tipo exportado.
**Estimativa**: 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `backend/contrato/src/saude.ts`
**Depends on**: T3
**Reuses**: design.md (C4)
**Requirement**: FUN-17

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Aceita `{status:'ok', versao:'abc'}`
- [ ] Rejeita `status` diferente de 'ok'
- [ ] Gate check passa: `pnpm --filter @tarefas/contrato test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T32: wrangler.jsonc e teste de lista fechada

**What**: Criar `wrangler.jsonc` (nome `tarefasdacasa`, assets SPA, `run_worker_first: ["/api/*"]`, `nodejs_compat`, Hyperdrive, ratelimits 4001 a 4003, rota com `custom_domain`, um único cron) e o teste que fixa a lista de chaves.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `wrangler.jsonc`
**Depends on**: T4
**Reuses**: pelada:wrangler.jsonc, backend/api/test/wrangler.test.ts
**Requirement**: FUN-16, FUN-20, FUN-21

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Teste confere `namespace_id` 4001, 4002 e 4003 com 10, 60 e 60 por minuto
- [ ] Teste confere exatamente um cron
- [ ] Teste confere a rota `tarefasdacasa.ljssoftware.com.br` com `custom_domain: true`
- [ ] Gate check passa: `pnpm --filter @tarefas/api test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T33: App Hono com no-store e nosniff

**What**: Criar `app.ts` e os middlewares `semCache` e `semSniff`: toda resposta de `/api/*` leva `Cache-Control: no-store` e `X-Content-Type-Options: nosniff`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/entrada/app.ts`
**Depends on**: T32
**Reuses**: pelada:backend/api/src/entrada/app.ts, middlewares/
**Requirement**: FUN-18

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Rota inexistente em `/api/x` devolve 404 com os dois cabeçalhos
- [ ] Resposta de erro também leva os cabeçalhos
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### T34: GET /api/health

**What**: Criar `rotas/health.ts` respondendo 200 `{"status":"ok","versao":env.VERSAO}` sem abrir conexão com o banco.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/entrada/rotas/health.ts`
**Depends on**: T33, T31
**Reuses**: pelada:backend/api/src/entrada/rotas/health.ts
**Requirement**: FUN-17

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Responde 200 com a versão injetada
- [ ] Passa mesmo com o Hyperdrive indisponível (nenhuma conexão aberta)
- [ ] Corpo valida no schema de `@tarefas/contrato`
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### T35: Middleware de limite de taxa

**What**: Copiar `limite-taxa.ts` ligado aos bindings `LIMITE_ENTRAR`, `LIMITE_PUBLICO` e `LIMITE_WEBHOOK`; sem rota que o use na fundação, só o middleware e o teste.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/entrada/middlewares/limite-taxa.ts`
**Depends on**: T33
**Reuses**: pelada:backend/api/src/entrada/middlewares/limite-taxa.ts
**Requirement**: FUN-20

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Dentro do limite a requisição passa
- [ ] Acima do limite devolve 429 com `Retry-After`
- [ ] Binding ausente nos testes não derruba o app
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### Phase 9: API (Worker, Hono, contexto de banco) (parte 2 de 2) (tarefas)

### T36: Cliente pg por requisição via Hyperdrive

**What**: Copiar `cliente.ts`: abre `pg.Client` pela connection string do Hyperdrive na primeira consulta e fecha com `waitUntil`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/infraestrutura/db/cliente.ts`
**Depends on**: T33
**Reuses**: pelada:backend/api/src/infraestrutura/db/cliente.ts
**Requirement**: FUN-13

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Conexão só abre na primeira consulta
- [ ] Fecha ao fim da requisição, inclusive em erro
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T37: Middleware comBanco: transação com contexto

**What**: Criar `comBanco`: `BEGIN` (`READ ONLY` em GET/HEAD), `set_config('app.usuario_id', $1, true)` com parâmetro, `COMMIT` se status < 400 ou `ROLLBACK`.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: sim
**Where**: `backend/api/src/entrada/middlewares/com-banco.ts`
**Depends on**: T36
**Reuses**: pelada:backend/api/src/entrada/middlewares/
**Requirement**: FUN-13

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Duas requisições concorrentes com usuários diferentes não vazam contexto
- [ ] Resposta 500 faz `ROLLBACK`
- [ ] Escrita em GET falha (READ ONLY)
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T38: Handler scheduled sem efeito

**What**: Criar `agendado.ts` e exportar `scheduled()` no worker: registra uma linha de log e retorna, sem tocar banco nem rede.
**Estimativa**: 30 min
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/entrada/agendado.ts`
**Depends on**: T32
**Reuses**: design.md (C4)
**Requirement**: FUN-21

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Disparar `scheduled` não lança erro
- [ ] Nenhuma conexão com o banco é aberta
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### T39: Sentry no Worker com scrubbing

**What**: Ligar `@sentry/hono/cloudflare` só quando há `SENTRY_DSN`, com `release = VERSAO` e `beforeSend` removendo corpo, cookies, `authorization` e e-mails.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/api/src/entrada/worker.ts`
**Depends on**: T33
**Reuses**: pelada:backend/api/src/entrada/worker.ts
**Requirement**: FUN-22, FUN-23

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Sem DSN nenhuma chamada de rede de terceiros é feita
- [ ] Evento de teste sai sem cookie, `authorization`, corpo e e-mail
- [ ] `release` é o SHA
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### Phase 10: Front base (parte 1 de 2) (tarefas)

### T40: Casca do front: main, App e roteador

**What**: Criar `index.html`, `main.tsx`, `App.tsx` com React Router e o `QueryClient` do TanStack Query; rota `/` aponta para a página provisória (placeholder até a fase 14).
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/app/App.tsx`
**Depends on**: T6
**Reuses**: pelada:frontend/web/src/app/App.tsx, dados/cliente.ts
**Requirement**: FUN-16

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `vite build` gera `dist/`
- [ ] Rota desconhecida cai no fallback da SPA
- [ ] Teste renderiza `/` sem erro
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T41: Fontes locais

**What**: Colocar Sora e Source Sans 3 (OFL) em `frontend/web/public/fontes/` e criar `fontes.css` com `@font-face` (`font-display: swap`) e a licença junto.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/estilos/fontes.css`
**Depends on**: T40
**Reuses**: .specs/mockup/tokens.css (@import a remover)
**Requirement**: FUN-26

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Os pesos usados pelos tokens carregam do próprio domínio
- [ ] Nenhum request para `fonts.googleapis.com` no build
- [ ] Arquivo de licença OFL presente
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T42: Mockup usa as fontes locais (AD-005)

**What**: Copiar as fontes para `.specs/mockup/fontes/`, trocar o `@import` do `tokens.css` por `@font-face` locais, e republicar a galeria do mockup.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `.specs/mockup/tokens.css`
**Depends on**: T41
**Reuses**: .specs/mockup/tokens.css
**Requirement**: FUN-26

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `tokens.css` não tem `@import` de host externo
- [ ] `checar-tokens.py` segue verde
- [ ] Galeria republicada no mesmo link, com o visual igual
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 11: Front base (parte 2 de 2) (tarefas)

### T43: tokens.css idêntico ao do mockup

**What**: Copiar `.specs/mockup/tokens.css` para `frontend/web/src/estilos/tokens.css` e criar o teste que compara os bytes.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/estilos/tokens.css`
**Depends on**: T42, T7
**Reuses**: .specs/mockup/tokens.css
**Requirement**: FUN-26

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Teste passa com os arquivos iguais
- [ ] Teste falha se um espaço divergir (fixture)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T44: Stylelint contra cor, fonte e sombra soltas

**What**: Configurar o Stylelint 17 para recusar cor, `font-family` e `box-shadow` literais fora de `tokens.css` e ligar `lint:css` ao `pnpm lint`.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/.stylelintrc.json`
**Depends on**: T43
**Reuses**: pelada:frontend/web/.stylelintrc.json
**Requirement**: FUN-28

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] CSS com `#fff` fora de `tokens.css` falha
- [ ] CSS só com `var(--...)` passa
- [ ] `pnpm lint` roda o `lint:css`
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T45: Sentry no front com scrubbing

**What**: Criar `observabilidade.ts` com `@sentry/react` ligado só se `VITE_SENTRY_DSN` existir, `release` = SHA e `beforeSend` limpando e-mails e cookies.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `frontend/web/src/app/observabilidade.ts`
**Depends on**: T40
**Reuses**: pelada:frontend/web/src/app/observabilidade.ts
**Requirement**: FUN-22, FUN-23

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Sem DSN, `Sentry.init` não é chamado
- [ ] Evento de teste sai sem e-mail
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 12: Componentes do guia de estilo (parte 1 de 2) (tarefas)

### T46: Componentes Botão e Selo

**What**: Criar `Botao` (primário, secundário, texto, desabilitado) e `Selo` (alerta, sucesso, neutro) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (botões e selos), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/botao-selo/`
**Depends on**: T44
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T47: Componentes Marcar e ItemTarefa

**What**: Criar `Marcar` (`aria-pressed`, desabilitado) e `ItemTarefa` (feita, atrasada) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (marcar e lista de tarefas), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/marcar-item/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T48: Componentes Campo e Opcoes

**What**: Criar `Campo` (normal, ajuda, erro) e `Opcoes` (rádio e caixa em pílula) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (campos e escolhas), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/campo-opcoes/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T49: Componentes Faixa e Anel

**What**: Criar `Faixa` (título e apoio) e `Anel` (progresso `N de M`, `aria-live`) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (faixa e anel), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/faixa-anel/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T50: Componentes Abas e Coluna

**What**: Criar `Abas` (`role=tab`, seleção por teclado) e `Coluna` (quadro de pessoas) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (abas e quadro), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/abas-coluna/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 13: Componentes do guia de estilo (parte 2 de 2) (tarefas)

### T51: Componentes Cartao e Aviso

**What**: Criar `Cartao` e `Aviso` (sucesso, alerta, erro com `role` correto) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (cartão e avisos), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/cartao-aviso/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T52: Componentes Estado e Esqueleto

**What**: Criar `Estado` (vazio, erro) e `Esqueleto` (respeita `prefers-reduced-motion`) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (estados), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/estado-esqueleto/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T53: Componente NavPrincipal

**What**: Criar `NavPrincipal` (rodapé com `aria-current`, área de toque de 44 px) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (navegação), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/nav-principal/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T54: Componente TabelaSemana

**What**: Criar `TabelaSemana` (cabeçalho fixo na coluna de nomes, rolagem horizontal acessível) como CSS Modules com os mesmos nomes de classe de `.specs/mockup/componentes.css` (tabela da semana), com teste de renderização e axe.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/componentes/tabela-semana/`
**Depends on**: T46
**Reuses**: .specs/mockup/componentes.css, .specs/mockup/guia.html
**Requirement**: FUN-27

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Renderiza com as variações do guia
- [ ] axe sem violações
- [ ] Nenhuma cor, fonte ou sombra literal (Stylelint verde)
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 14: Shell PWA e ferramentas de execução local (parte 1 de 3) (tarefas)

### T55: Página provisória em /

**What**: Criar a página provisória com `Faixa` e `Estado` ('Em breve'), no visual de `telas/provisoria.html`.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/paginas/Provisoria.tsx`
**Depends on**: T49, T52, T40
**Reuses**: .specs/mockup/telas/provisoria.html
**Requirement**: FUN-34

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `/` renderiza o texto do mockup
- [ ] axe sem violações
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T56: pnpm dev

**What**: Criar `dev.ts`: sobe o `wrangler dev` com `localConnectionString` do Hyperdrive apontando para o Postgres local e o Vite com proxy de `/api`; se o Postgres está fora do ar, aborta com 'Rode docker compose up -d'.
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `backend/scripts/dev.ts`
**Depends on**: T16, T55, T34
**Reuses**: pelada:backend/scripts/dev.ts
**Requirement**: FUN-04, FUN-51

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `pnpm dev` serve o shell em `localhost:5173` e `/api/health` responde 200 pelo proxy
- [ ] Sem Postgres, termina com a mensagem do compose
- [ ] Teste de integração cobre as duas situações
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T57: Ícone do app e gerador de PNG

**What**: Desenhar o ícone em SVG com as cores dos tokens e criar o script que gera `icone-192.png`, `icone-512.png` e `icone-maskable-512.png`.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/scripts/gerar-icones.mjs`
**Depends on**: T43
**Reuses**: pelada:frontend/web/public/icones/
**Requirement**: FUN-29

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Três PNGs com 192, 512 e 512 px
- [ ] O maskable tem a margem de segurança
- [ ] Teste confere dimensões
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T58: Manifest do PWA

**What**: Criar `config/manifesto.ts` gerando o manifest: nome 'Tarefas da Casa', `display: standalone`, `lang: pt-BR`, cores dos tokens, ícones 192 e 512 (um `maskable`).
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/config/manifesto.ts`
**Depends on**: T57
**Reuses**: pelada:frontend/web/src/config/manifesto.ts
**Requirement**: FUN-29

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Manifest gerado no build bate com o teste de unidade
- [ ] Ícones apontam para arquivos existentes
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 15: Shell PWA e ferramentas de execução local (parte 2 de 3) (tarefas)

### T59: Service worker: precache e handlers push

**What**: Criar o SW (`injectManifest`, Workbox 7) com precache do shell e handlers vazios de `push` e `notificationclick` registrados.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `frontend/web/src/pwa/sw.ts`
**Depends on**: T58
**Reuses**: pelada:frontend/web/src/pwa/
**Requirement**: FUN-30

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] O precache inclui `index.html` e os assets do build
- [ ] Os dois eventos têm listener registrado
- [ ] Teste unitário das regras de rota do SW
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T60: Página offline e fallback de navegação

**What**: Criar `public/offline.html` no visual de `telas/offline.html` (CSS inline copiado dos tokens) e o fallback de navegação no SW.
**Estimativa**: 1h 30 min
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/public/offline.html`
**Depends on**: T59
**Reuses**: .specs/mockup/telas/offline.html
**Requirement**: FUN-31

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Navegação sem rede fora do cache mostra `offline.html`
- [ ] A página não usa host externo
- [ ] Botão 'Tentar de novo' recarrega
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T61: Instrução de instalação no iOS

**What**: Copiar `pwa/instalacao.ts` e o aviso: no Safari do iOS fora do modo standalone aparece a instrução de adicionar à tela inicial; no standalone, não.
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/src/pwa/instalacao.ts`
**Depends on**: T40, T51
**Reuses**: pelada:frontend/web/src/pwa/instalacao.ts
**Requirement**: FUN-32

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Safari iOS fora do standalone mostra o aviso
- [ ] Standalone e outros navegadores não mostram
- [ ] Gate check passa: `pnpm --filter @tarefas/web test`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T62: Cabeçalhos de segurança do front

**What**: Criar `public/_headers` com `Content-Security-Policy` (`default-src 'self'`), `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin` e `Strict-Transport-Security`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `frontend/web/public/_headers`
**Depends on**: T55
**Reuses**: pelada:frontend/web/public/_headers
**Requirement**: FUN-25

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Os quatro cabeçalhos estão no arquivo
- [ ] A CSP não lista host externo
- [ ] O e2e da T63 confere contra o build
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 16: Shell PWA e ferramentas de execução local (parte 3 de 3) (tarefas)

### T63: Playwright e e2e de cabeçalhos

**What**: Configurar o Playwright (só Chromium) contra `vite preview` e escrever o e2e que confere os cabeçalhos de `/` no build.
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/e2e/playwright.config.ts`
**Depends on**: T62, T59
**Reuses**: pelada:frontend/web/e2e/playwright.config.ts
**Requirement**: FUN-25

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `/` devolve os quatro cabeçalhos
- [ ] O e2e roda com `pnpm --filter @tarefas/web e2e`
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### T64: e2e de instalabilidade

**What**: Escrever o e2e: manifest válido, SW ativo controlando a página, ícones 192 e 512 (um `maskable`) acessíveis e `offline.html` servida sem rede.
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/e2e/instalabilidade.spec.ts`
**Depends on**: T63, T60, T57
**Reuses**: pelada:frontend/web/e2e/
**Requirement**: FUN-33

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Os quatro verificações passam contra o build
- [ ] Falha se o ícone maskable sumir (fixture)
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### T65: Comparação visual no front

**What**: Ligar `.claude/scripts/comparar-visual.mjs` ao `pnpm --filter @tarefas/web visual` com `.specs/mockup/telas.json` (T1 provisória, T2 offline; 1280×800 e 390×844; limite de 1%).
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `frontend/web/package.json`
**Depends on**: T63, T55, T60
**Reuses**: .claude/scripts/comparar-visual.mjs, .specs/mockup/telas.json
**Requirement**: FUN-34

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] As 4 comparações ficam dentro de 1% de pixels
- [ ] Mudar uma cor do tokens faz o comando falhar (fixture local)
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: e2e
**Gate**: full

---

### Phase 17: CI, deploy e backup (parte 1 de 3) (tarefas)

### T66: Action preparar-node

**What**: Copiar `.github/actions/preparar-node` (Node 24, pnpm 11, cache do pnpm) fixando as actions por SHA.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `.github/actions/preparar-node/action.yml`
**Depends on**: T14
**Reuses**: pelada:.github/actions/preparar-node/
**Requirement**: FUN-35

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Actions fixadas por SHA (checagem verde)
- [ ] Usada por `ci.yml` e `deploy.yml`
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T67: Gitleaks

**What**: Copiar `.gitleaks.toml` e ajustar as regras permitidas (IDs de recurso não são segredo).
**Estimativa**: 30 min
**Risco**: alto
**Domínio**: não
**Where**: `.gitleaks.toml`
**Depends on**: T1
**Reuses**: pelada:.gitleaks.toml
**Requirement**: FUN-41

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `gitleaks detect` no repositório sai 0
- [ ] Um segredo de fixture é detectado
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T68: .env.example comentado

**What**: Criar `.env.example` listando cada variável com obrigatoriedade, formato e se é segredo (`DATABASE_URL_TESTE`, `CLOUDFLARE_HYPERDRIVE_LOCAL_CONNECTION_STRING_HYPERDRIVE`, `TARGET`, senhas das roles, `SENTRY_DSN`, `URL_PUBLICA`, `VERSAO`).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `.env.example`
**Depends on**: T30, T39
**Reuses**: pelada:.env.example
**Requirement**: FUN-41

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Nenhuma variável usada no código fica fora do arquivo
- [ ] Nenhum valor real no arquivo (gitleaks verde)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T69: Workflow ci.yml

**What**: Copiar `ci.yml`: lint, typecheck, testes, gitleaks, build do web, migrations do zero num Postgres de serviço, isolamento, comparação visual e instalabilidade; `pull_request` (nunca `pull_request_target`) e sem secrets.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `.github/workflows/ci.yml`
**Depends on**: T66, T67, T65, T64, T29, T15, T12, T13
**Reuses**: pelada:.github/workflows/ci.yml
**Requirement**: FUN-35

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Cada passo falho deixa o job vermelho (teste de estrutura do YAML)
- [ ] O workflow não referencia `secrets.`
- [ ] Primeiro push roda verde no GitHub (observado na entrega)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 18: CI, deploy e backup (parte 2 de 3) (tarefas)

### T70: Action dump-cifrado com a trava de repositório público

**What**: Copiar a action `dump-cifrado` (`pg_dump -Fc --enable-row-security` + `age`) e acrescentar o primeiro passo: se `github.event.repository.private != true`, falhar com 'Torne o repositório privado antes do backup' antes de qualquer `pg_dump`.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `.github/actions/dump-cifrado/dump-cifrado.sh`
**Depends on**: T66, T24
**Reuses**: pelada:.github/actions/dump-cifrado/
**Requirement**: FUN-44, FUN-45

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Com `REPO_PRIVADO=false` o script sai 1 sem chamar `pg_dump` (teste com `pg_dump` falso)
- [ ] Falha no dump ou na cifragem não deixa arquivo parcial
- [ ] Com repositório privado gera `.dump.age`
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T71: Workflow backup.yml

**What**: Copiar `backup.yml`: todo dia às 07:00 UTC (04:00 de Brasília) e manual, role `tarefas_backup`, artefato com `retention-days: 30`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `.github/workflows/backup.yml`
**Depends on**: T70
**Reuses**: pelada:.github/workflows/backup.yml
**Requirement**: FUN-43, FUN-44, FUN-45

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `cron: '0 7 * * *'` e `workflow_dispatch` presentes
- [ ] `retention-days: 30`
- [ ] Passo de dump usa a action com a trava
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T72: Branches de restauração no Neon

**What**: Copiar `restauracao-neon*.ts`: cria a branch de restauração antes do deploy e remove as antigas, mantendo só as 2 mais recentes.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: sim
**Where**: `backend/scripts/ops/restauracao-neon.ts`
**Depends on**: T17
**Reuses**: pelada:backend/scripts/ops/restauracao-neon*.ts
**Requirement**: FUN-37

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Com 3 branches antigas, remove a mais velha e cria a nova (API do Neon simulada)
- [ ] Erro da API para o script com código 1
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 19: CI, deploy e backup (parte 3 de 3) (tarefas)

### T73: Conferência do cache do Hyperdrive

**What**: Criar o script que consulta a configuração do Hyperdrive e falha se o cache estiver ligado (usado pelo deploy).
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/ops/checar-hyperdrive.ts`
**Depends on**: T72
**Reuses**: pelada:passo do `deploy.yml` do Pelada
**Requirement**: FUN-15

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Cache desligado passa
- [ ] Cache ligado falha com mensagem de como corrigir (API simulada)
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### T74: Workflow deploy.yml

**What**: Copiar `deploy.yml`: só `workflow_dispatch` na `main`, environment `producao`, `concurrency` sem cancelar; passos na ordem: build do web, branch de restauração, dump cifrado, migração com `NEON_URL_MIGRACAO`, `wrangler deploy --var URL_PUBLICA`, `GET /api/health` com `versao == github.sha`.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: sim
**Where**: `.github/workflows/deploy.yml`
**Depends on**: T69, T72, T73, T70
**Reuses**: pelada:.github/workflows/deploy.yml
**Requirement**: FUN-36, FUN-37, FUN-53

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Gatilho, ambiente e concorrência conforme a spec
- [ ] Ordem dos seis passos confere
- [ ] `wrangler deploy` só aparece neste arquivo (checagem verde)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T75: Testes de estrutura do deploy.yml

**What**: Escrever o teste (sobre `yaml-estrutura.mjs`) que prova: build antes de tocar o Neon, falha de migração impede o `wrangler deploy`, `URL_PUBLICA` vazia falha antes do deploy e o health confere a versão.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `backend/scripts/checagens/test/deploy-yml.test.mjs`
**Depends on**: T74
**Reuses**: pelada:backend/scripts/checagens/yaml-estrutura.mjs
**Requirement**: FUN-38, FUN-39, FUN-54

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Cada uma das quatro regras tem teste que passa e fixture que falha
- [ ] O teste lê o `deploy.yml` real
- [ ] Gate check passa: `pnpm test:checagens`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: unit
**Gate**: quick

---

### Phase 20: Documentação (parte 1 de 2) (tarefas)

### T76: README

**What**: Escrever o `README.md`: rodar local, variáveis, deploy e testes (em português).
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `README.md`
**Depends on**: T56, T68, T74
**Reuses**: pelada:README.md
**Requirement**: FUN-47

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Um agente sem contexto segue o README num clone limpo até `localhost:5173` (teste de aceitação)
- [ ] Todos os comandos citados existem no `package.json`
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T77: Runbook

**What**: Escrever `docs/runbook.md`: deploy, falha de migração (restaurar pela branch), restauração do backup, rotação de segredos, monitor do UptimeRobot, contagem de crons da conta e o primeiro passo da publicação ('tornar o repositório privado').
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T74
**Reuses**: pelada:backend/DEPLOY.md
**Requirement**: FUN-48, FUN-24

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Os seis tópicos estão presentes
- [ ] Procedimento de restauração com espaço para data e contagens (preenchido na entrega)
- [ ] Sem segredo nem dado pessoal
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T78: ADRs 001 a 005

**What**: Escrever os ADRs em `.md/adr/`: 001 migrations e linha de base vazia, 002 isolamento por casa com RLS, 003 backup como artefato com trava de repositório público, 004 instalabilidade por Playwright, 005 fontes locais.
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `.md/adr/001-migrations-node-pg-migrate.md`
**Depends on**: T24
**Reuses**: pelada:.md/adr/024 a 028
**Requirement**: FUN-49

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Cada ADR tem Contexto, Decisão e Consequências
- [ ] `Supersedes:` onde couber
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 21: Documentação (parte 2 de 2) (tarefas)

### T79: Documentação consolidada em .md/

**What**: Consolidar `PRD.md`, `PRD-TECNICO.md`, `SDD.md`, `GUARDRAILS.md` e `THREAT-MODEL.md` a partir de `.specs/` (necessidade, spec, design).
**Estimativa**: 2h
**Risco**: baixo
**Domínio**: não
**Where**: `.md/SDD.md`
**Depends on**: T78
**Reuses**: pelada:.md/
**Requirement**: FUN-49

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Os cinco documentos existem e citam os IDs da spec
- [ ] THREAT-MODEL sem informação sensível (repositório público)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T80: CLAUDE.md da raiz

**What**: Escrever o `CLAUDE.md` da raiz: stack, comandos, onde ficam regras e artefatos (nunca em `.claude/CLAUDE.md`).
**Estimativa**: 1h
**Risco**: baixo
**Domínio**: não
**Where**: `CLAUDE.md`
**Depends on**: T76
**Reuses**: pelada:CLAUDE.md
**Requirement**: FUN-50

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Lista os comandos padrão da raiz
- [ ] Aponta `.specs/`, `.md/` e `docs/runbook.md`
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 22: Entrega (ações externas, cada uma com confirmação) (parte 1 de 2) (tarefas)

### T81: Criar Hyperdrive e environment producao

**What**: Com o usuário: criar o Hyperdrive (cache desligado) apontando para o Neon `odd-voice-50267467` e o environment `producao` com os secrets (`NEON_URL_MIGRACAO`, `NEON_*`, `BACKUP_CHAVE_PUBLICA`, `CLOUDFLARE_*`); definir a senha de login das roles.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T77, T75, T71, T76
**Reuses**: —
**Requirement**: FUN-15, FUN-36

**Ação externa: pedir confirmação específica ao usuário no momento da execução.**

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Hyperdrive criado e o `id` colocado no `wrangler.jsonc`
- [ ] Secrets cadastrados (sem registrar valores no repositório)
- [ ] `checar-hyperdrive` passa contra o Hyperdrive real
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T82: Primeiro push e CI verde

**What**: Com o usuário: `git push` da branch de trabalho, abrir PR e conferir o `ci.yml` verde no GitHub.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T81, T80
**Reuses**: —
**Requirement**: FUN-35

**Ação externa: pedir confirmação específica ao usuário no momento da execução.**

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `ci.yml` verde no GitHub
- [ ] Nenhum segredo apareceu nos logs
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T83: Tornar o repositório privado

**What**: Com o usuário: mudar o repositório para privado nas configurações do GitHub e conferir a trava do backup (job de backup passa a rodar).
**Estimativa**: 30 min
**Risco**: alto
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T82
**Reuses**: —
**Requirement**: FUN-44

**Ação externa: pedir confirmação específica ao usuário no momento da execução.**

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Repositório privado
- [ ] Execução manual de `backup.yml` passa e gera artefato
- [ ] Com o repositório público a trava falhou antes (já provado em T de teste)
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### Phase 23: Entrega (ações externas, cada uma com confirmação) (parte 2 de 2) (tarefas)

### T84: Primeiro deploy em produção

**What**: Com o usuário: disparar `deploy.yml` na `main`; migrar o banco de produção e publicar em `tarefasdacasa.ljssoftware.com.br`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T83
**Reuses**: —
**Requirement**: FUN-16, FUN-21, FUN-37

**Ação externa: pedir confirmação específica ao usuário no momento da execução.**

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] `curl https://tarefasdacasa.ljssoftware.com.br/api/health` = 200 com o SHA
- [ ] O Worker aparece com exatamente um cron
- [ ] Cabeçalhos de segurança conferidos no domínio
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

### T85: Backup manual e restauração testada

**What**: Rodar o `backup.yml` manualmente, restaurar o dump num Postgres local limpo (decifrando com a chave privada guardada fora do GitHub), conferir a contagem de linhas por tabela e registrar data e contagens no runbook.
**Estimativa**: 2h
**Risco**: alto
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T83, T84
**Reuses**: pelada:backend/scripts/ops/restaurar-cli.ts
**Requirement**: FUN-46

**Ação externa: pedir confirmação específica ao usuário no momento da execução.**

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Contagens da restauração batem com a produção
- [ ] Data e contagens registradas no runbook
- [ ] Tamanho do primeiro dump anotado (cota de 500 MB)
- [ ] Gate check passa: `pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web e2e`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: integration
**Gate**: full

---

### T86: Instalar o PWA e criar o monitor

**What**: Com o usuário: instalar no Chrome do Android e no Safari do iOS, abrir sem rede e ver `offline.html`; criar o monitor do UptimeRobot em `/api/health`.
**Estimativa**: 1h
**Risco**: alto
**Domínio**: não
**Where**: `docs/runbook.md`
**Depends on**: T84
**Reuses**: —
**Requirement**: FUN-24, FUN-32, FUN-33

**Ação externa: pedir confirmação específica ao usuário no momento da execução.**

**Tools**:

- MCP: NONE
- Skill: NONE

**Done when**:

- [ ] Instala nos dois sistemas e abre como aplicativo
- [ ] Offline mostra a página 'Sem conexão'
- [ ] Monitor criado e verde
- [ ] Gate check passa: `pnpm lint && pnpm format:check && pnpm typecheck && pnpm test && pnpm test:checagens && pnpm --filter @tarefas/web build && pnpm --filter @tarefas/web e2e && pnpm --filter @tarefas/web visual`
- [ ] Contagem de testes registrada (sem remoção silenciosa)

**Tests**: none
**Gate**: build

---

## Phase Execution Map

Execução estritamente sequencial: um agente (ou worker de lote) faz uma tarefa por vez, em ordem. Cada Phase soma até 6h de Estimativa e é um lote (`python .claude/scripts/progresso.py --lote`).

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6 → Phase 7 → Phase 8 → Phase 9 → Phase 10 → Phase 11 → Phase 12 → Phase 13 → Phase 14 → Phase 15 → Phase 16 → Phase 17 → Phase 18 → Phase 19 → Phase 20 → Phase 21 → Phase 22 → Phase 23
```

## Cobertura de requisitos

| Requisito | Tarefas |
| --------- | ------- |
| FUN-01 | T1, T2, T3, T4, T5, T6, T7 |
| FUN-02 | T9 |
| FUN-03 | T16 |
| FUN-04 | T56 |
| FUN-05 | T17, T30 |
| FUN-06 | T8 |
| FUN-07 | T18 |
| FUN-08 | T19, T21 |
| FUN-09 | T20, T24 |
| FUN-10 | T23, T24, T29 |
| FUN-11 | T22, T23, T26 |
| FUN-12 | T28 |
| FUN-13 | T36, T37 |
| FUN-14 | T25, T26, T27 |
| FUN-15 | T73, T81 |
| FUN-16 | T32, T40, T84 |
| FUN-17 | T31, T34 |
| FUN-18 | T33 |
| FUN-19 | T11, T12 |
| FUN-20 | T32, T35 |
| FUN-21 | T32, T38, T84 |
| FUN-22 | T39, T45 |
| FUN-23 | T39, T45 |
| FUN-24 | T77, T86 |
| FUN-25 | T62, T63 |
| FUN-26 | T41, T42, T43 |
| FUN-27 | T46, T47, T48, T49, T50, T51, T52, T53, T54 |
| FUN-28 | T44 |
| FUN-29 | T57, T58 |
| FUN-30 | T59 |
| FUN-31 | T60 |
| FUN-32 | T61, T86 |
| FUN-33 | T64, T86 |
| FUN-34 | T55, T65 |
| FUN-35 | T14, T66, T69, T82 |
| FUN-36 | T74, T81 |
| FUN-37 | T72, T74, T84 |
| FUN-38 | T75 |
| FUN-39 | T75 |
| FUN-40 | T13 |
| FUN-41 | T67, T68 |
| FUN-42 | T10 |
| FUN-43 | T71 |
| FUN-44 | T70, T71, T83 |
| FUN-45 | T70, T71 |
| FUN-46 | T85 |
| FUN-47 | T76 |
| FUN-48 | T77 |
| FUN-49 | T78, T79 |
| FUN-50 | T80 |
| FUN-51 | T18, T56 |
| FUN-52 | T15 |
| FUN-53 | T74 |
| FUN-54 | T75 |

**Cobertura:** 54 requisitos, 54 mapeados a tarefas, 0 sem tarefa.

## Task Granularity Check

| Fase | Tarefas | Maior estimativa | Status |
| ---- | ------- | ---------------- | ------ |
| 1. Repositório e ferramentas | 10 | 2h (T4) | ✅ até 2 h |
| 2. Checagens do CI | 5 | 2h (T15) | ✅ até 2 h |
| 3. Banco: migrations e roles | 7 | 2h (T18) | ✅ até 2 h |
| 4. Banco: RLS, isolamento e seed | 8 | 2h (T23) | ✅ até 2 h |
| 5. API (Worker, Hono, contexto de banco) | 9 | 2h (T32) | ✅ até 2 h |
| 6. Front base | 6 | 2h (T40) | ✅ até 2 h |
| 7. Componentes do guia de estilo | 9 | 1h 30 min (T46) | ✅ até 2 h |
| 8. Shell PWA e ferramentas de execução local | 11 | 2h (T56) | ✅ até 2 h |
| 9. CI, deploy e backup | 10 | 2h (T69) | ✅ até 2 h |
| 10. Documentação | 5 | 2h (T77) | ✅ até 2 h |
| 11. Entrega (ações externas, cada uma com confirmação) | 6 | 2h (T85) | ✅ até 2 h |

Total: 86 tarefas, soma das estimativas ≈ 114 h de trabalho humano.

## Test Co-location Validation

Cada tarefa que cria uma camada com tipo de teste exigido na matriz leva esse teste na própria tarefa (sem tarefa de teste separada). `Tests: none` só aparece em configuração, workflows, documentação e ações externas, camadas que a matriz marca como `none`.

| Camada | Tipo exigido | Tarefas | Status |
| ------ | ------------ | ------- | ------ |
| (tarefas com `Tests: unit`) | unit | 38 | ✅ OK |
| (tarefas com `Tests: integration`) | integration | 18 | ✅ OK |
| (tarefas com `Tests: e2e`) | e2e | 8 | ✅ OK |
| (tarefas com `Tests: none`) | none | 22 | ✅ OK |

