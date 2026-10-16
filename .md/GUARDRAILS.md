# GUARDRAILS.md: Tarefas da Casa

> **Status:** **em vigor desde 2026-10-16.** Proposto pelo Coordenador no Loop C do `/definir` (rodada 1), junto com o `TASK.md`, que o usuário aprovou em 2026-10-16. Aprovado com ajustes pelo Gestor (skill `guardrails-governance`) no mesmo dia. Ver o Log de Alterações no fim e o registro em `CTO-REVIEW.md`.
> **Origem:** `CTO-REVIEW.md` (Gate 1), `SDD.md` (Pacotes e fronteiras, §6 e §7), ADR-001 a ADR-007, `UX-SPEC.md` §0 e §2.
> **Como ler:** cada regra é inegociável e tem uma checagem que roda (lint, teste, script ou passo de CI). A coluna "Tarefa que cria a checagem" aponta a tarefa do `TASK.md` que entrega a verificação. Preferências de estilo não estão aqui; elas ficam na Seção 1 do `TASK.md`.
> **Contrato ≠ arquivo:** toda regra protege **comportamento observável** (forma da resposta, schema, cabeçalho, comando). Refatorar o código por trás é sempre permitido, desde que as checagens continuem passando. Nenhuma regra proíbe editar um arquivo.

---

## Regras

### Origem e publicação

| ID | Regra | Origem | Como verificar | Tarefa que cria a checagem |
|---|---|---|---|---|
| G-01 | A origem definitiva é `https://tarefas-da-casa-ljs.vercel.app`, definida **só** pela variável `ORIGEM_PUBLICA`. Nenhum domínio aparece no código-fonte nem no bundle. A única exceção é `scripts/conferir-ambiente.ts`, que compara com o valor do ADR-006 | ADR-006 itens 1, 2 e 6 | (a) `scripts/conferir-ambiente.ts` no build de produção falha se `ORIGEM_PUBLICA` estiver vazia ou diferente; (b) `guarda-bundle-externo` no CI falha se `vercel.app` ou outro domínio aparecer em `frontend/dist`, `frontend/src` ou `backend/*/src` | TP-0097, TP-0071 |
| G-02 | O projeto Vercel `tarefas-da-casa-ljs` nunca é renomeado nem apagado, e a produção só publica a partir dele. Nenhum aparelho da família é instalado fora da origem definitiva | ADR-006 item 7; SDD RT-11; RNF-06 | `scripts/conferir-ambiente.ts` falha se `VERCEL_PROJECT_PRODUCTION_URL` ≠ `tarefas-da-casa-ljs.vercel.app`; a faixa G3 aparece em todo host ≠ `ORIGEM_PUBLICA` (`ambienteTeste` em `GET /api/situacao`, teste de integração) | TP-0097, TP-0027 |
| G-03 | No deploy de produção, todo host diferente da origem responde `308` para ela. Previews usam banco separado (branch do Neon), nunca o de produção | ADR-006 itens 4 e 5 | Teste do middleware de borda (host ≠ origem → 308); `curl -I` registrado no spike; `conferir-ambiente`, em Preview, falha se o host da `DATABASE_URL` for o do branch de produção (`NEON_HOST_PRODUCAO`) | TP-0022, TP-0004, TP-0097 |
| G-04 | Toda migração de produção é precedida por backup e por um branch de segurança do Neon, e roda pelo `deploy.yml`, nunca à mão | SDD §6 Troca de dados em produção; ADR-007 | O `deploy.yml` tem os passos backup → branch → `migrar --producao` → deploy, nessa ordem: `actionlint` + checagem da ordem dos passos no CI | TP-0097 |

### Dados e banco

| ID | Regra | Origem | Como verificar | Tarefa que cria a checagem |
|---|---|---|---|---|
| G-05 | SQL e o driver `postgres` só existem em `backend/api/src/infraestrutura/banco/`. O módulo exporta funções por agregado e **nunca** a conexão | SDD Pacotes e fronteiras; CONVENCOES §2 | `lint-fronteiras` (ESLint `no-restricted-imports` de `postgres` fora de `infraestrutura/banco/`) no `pnpm lint` e no CI; o tipo público do módulo não exporta a conexão (teste de tipo) | TP-0010, TP-0003 |
| G-06 | Migração é **expandir e depois contrair**: cada arquivo roda numa transação; `DROP`, `RENAME` ou troca de tipo só com o marcador `-- contrair:` num deploy posterior; migração já aplicada nunca é editada | SDD §6 Troca de dados em produção | `guarda-migracoes` (`scripts/checar-migracoes.ts`) no CI; `migrar.ts` falha se o hash de um arquivo aplicado mudou | TP-0005 |
| G-07 | `semana_fechada` nasce completa e **nunca** é atualizada nem apagada. Ocorrência marcada **nunca** é apagada | RN-09; ADR-003; SDD §5 | Gatilhos no banco (`002_rotina.sql`, `003_placar.sql`) com teste de integração que tenta UPDATE/DELETE e espera erro | TP-0007, TP-0008 |
| G-08 | Todo script ou teste que escreve no banco recusa host não local, salvo `--producao` explícito com confirmação. A confirmação é interativa quando o script roda à mão (ex.: `redefinir-senha.ts`). No `deploy.yml` (G-04), a execução pelo workflow da `main` com `--producao` é a confirmação, e nenhum outro workflow nem script usa `--producao` sem pedir confirmação | CONVENCOES §7; G-04 | `trava-host-local` com teste próprio (host remoto sem flag → erro); usada por `migrar.ts`, `redefinir-senha.ts` e `test/apoio/banco-teste.ts` | TP-0005 |
| G-09 | Dado de criança é **só** apelido e avatar do conjunto fixo. Dado de adulto é só apelido, e-mail e hash de senha. Nenhuma coluna de foto, telefone, data de nascimento, sobrenome ou localização. O rótulo do aparelho é guardado já resumido, sem o user-agent bruto | RNF-08; LGPD art. 14; SDD §7 Dados pessoais | `teste-schema` (colunas do `information_schema` = lista permitida do SDD §5); esquema zod estrito da Criança recusa campo extra (teste do contrato); teste do `rotuloAparelho` | TP-0009, TP-0018, TP-0024 |

### Camadas e regra de negócio

| ID | Regra | Origem | Como verificar | Tarefa que cria a checagem |
|---|---|---|---|---|
| G-10 | Direção de import: `rotas → aplicacao → dominio`; `infraestrutura → dominio` só tipos; `dominio` não importa `hono`, `postgres` nem `node:*`; rota não importa rota | SDD Pacotes e fronteiras; CONVENCOES §2 | `lint-fronteiras` no CI, com matriz adversarial | TP-0010 |
| G-11 | `@tdc/pwa` nunca depende de `@tdc/api`. `@tdc/contrato` depende só de `zod` | SDD Pacotes e fronteiras | `checar-dependencias` no CI (lê os `package.json`) | TP-0010 |
| G-12 | Regra de negócio (estado, atraso, permissão, %) só roda em `dominio/` e `aplicacao/`. A tela formata o que a API manda (`estado`, `diasAtraso`, `podePular`, `podeDesfazer`, `percentual`) e não recalcula | SDD §2 (onde a regra roda); CONVENCOES §2 | `checar-dependencias` (o PWA não tem como importar o domínio) + testes do `contrato/rotina` exigem esses campos na resposta | TP-0010, TP-0019 |
| G-13 | Toda data de regra usa o fuso `America/Sao_Paulo`, por um relógio injetado. `Date.now()` e `new Date()` sem argumento não aparecem fora de `dominio/relogio` e `infraestrutura/` | RNF-15; RN-01; SDD RT-03 | `lint-fronteiras` (`no-restricted-syntax`) no CI | TP-0010 |
| G-14 | A aplicação não tem agendador, cron, fila nem worker na Fase 1. Ocorrências e fechamento são postos em dia sob demanda (`garantirEmDia`). A única tarefa agendada do projeto é o `backup.yml` do GitHub Actions (ADR-007), que é operação, fora da aplicação, e nunca gera ocorrência nem fecha semana | ADR-003; ADR-007 | `checar-dependencias` falha com pacote de agendamento/fila (`node-cron`, `bullmq`...) e com chave `crons` no `vercel.json` | TP-0010 |

### Segurança e acesso

| ID | Regra | Origem | Como verificar | Tarefa que cria a checagem |
|---|---|---|---|---|
| G-15 | Toda rota fora da lista pública (`GET /api/situacao`, `POST /api/familia`, `POST /api/entrar/*`, estáticos) exige sessão válida | SDD §7 Rotas públicas; RNF-09 | `teste-rotas-protegidas`: percorre as rotas registradas e espera 401 sem cookie | TP-0023 |
| G-16 | O membro que age vem **só** da sessão. A API recusa com 403 o que o papel não pode, mesmo que a tela já esconda | SDD §7 Autorização; ADR-004 | Tabela de testes do `dominio/permissoes` + teste de 403 para Criança em cada tarefa de endpoint (`pnpm test:integracao`) | TP-0016 e cada endpoint |
| G-17 | Senha só como hash scrypt (N ≥ 2^15, r=8, p=1, sal de 16 bytes). Token de sessão e código de vínculo só como hash SHA-256. Nenhum segredo no repositório | SDD §7 Autenticação e Criptografia; RNF-09 | Testes de `infraestrutura/senha` e `infraestrutura/token`; `gitleaks` no CI | TP-0021, TP-0002 |
| G-18 | Cookie de sessão `tdc_sessao`: `HttpOnly; Secure; SameSite=Lax; Path=/`, **sem** `Domain` | ADR-004; ADR-006 item 7 | Teste do `criarSessaoAparelho` confere os atributos exatos | TP-0024 |
| G-19 | Método que altera dado exige `Origin` = `ORIGEM_PUBLICA` e `Content-Type: application/json` | SDD §7 CSRF | Teste do middleware de borda (Origin ausente ou diferente → 403) | TP-0022 |
| G-20 | Toda resposta (API e estáticos) leva os cabeçalhos do SDD §7: CSP `default-src 'self'` (com `img-src 'self' data:`, `object-src 'none'`, `base-uri 'none'`, `frame-ancestors 'none'`), HSTS sem `includeSubDomains` e sem `preload`, `nosniff`, `Referrer-Policy: no-referrer` e `Permissions-Policy` sem câmera, microfone e geolocalização | SDD §7 Superfície de exposição; ADR-006 item 7 (HSTS) | Teste do middleware + teste que compara a lista do middleware com o bloco `headers` do `vercel.json` | TP-0022 |
| G-21 | Limites de tentativa: 5 falhas por e-mail → 15 min; 5 por aparelho → 10 min; 30 por IP por hora → 1 h. Código de vínculo: uso único, 10 min, invalidado ao gerar outro | CA-02.3, CA-07.4; RN-18 | Testes de `limiteTentativas` (relógio fixo) e de `banco/codigos` (concorrência) | TP-0025, TP-0026 |

### Privacidade, linguagem e interface

| ID | Regra | Origem | Como verificar | Tarefa que cria a checagem |
|---|---|---|---|---|
| G-22 | Nenhum SDK de terceiro, analytics, anúncio, pixel ou fonte de CDN, em nenhuma tela | RNF-08; SDD §7 Sem terceiros | `guarda-bundle-externo` no CI (nenhuma URL externa no `dist`) + CSP `'self'` (G-20) | TP-0071 |
| G-23 | As respostas de "Da casa" (Hoje), Casa e Semanas anteriores não contêm apelido nem id do membro atribuído ou de quem não fez. Não existe ranking nem % individual | RN-17a, RN-17b; SDD §7 | Testes do `contrato/rotina` e do `contrato/placar` falham se o campo aparecer | TP-0019, TP-0020 |
| G-24 | Texto de usuário nunca usa: "culpa", "falhou", "preguiça", "devendo", "punição", "castigo", "atrasado(a)", "não fez". O estado "Atrasada" não aparece como palavra na tela | RN-17c, RN-17d; UX-SPEC §2 | `guarda-palavras-proibidas` no CI sobre `frontend/src/textos/` e as mensagens da API | TP-0071 |
| G-25 | O service worker guarda só o shell. `/api/*` nunca é cacheado. Não existe marcação offline: sem rede, a ação falha com "Sem conexão" | ADR-005; D-04; RNF-10 | Teste da configuração do `vite-plugin-pwa` (nenhuma regra de cache para `/api/*`) | TP-0065 |
| G-26 | A aparência segue o mockup aprovado: `tokens.css` e `base.css` são cópias **idênticas** de `.md/mockup/`, e toda tela automática fica a no máximo 1% de pixels divergentes, com a mesma altura de página. Mudança visual começa no mockup | UX-SPEC §0 (precedência e fidelidade); SDD §3 (Estilo) | Teste de hash de `tokens.css` e `base.css` contra o mockup; `job-comparacao-visual` no CI (`comparar-visual.mjs --limite 1`) | TP-0062, TP-0071 |
| G-27 | O contrato da API dentro da Fase 1 é só **aditivo**: campo novo é opcional e nenhum campo existente muda de sentido ou some. O formato de referência são os JSON de `.md/mockup/respostas/` | SDD §2.6; RT-05 | Testes do contrato validam todos os JSON do mockup (TP-0017 a TP-0020); quebrar um campo derruba o teste | TP-0017 a TP-0020 |

### Processo de código

| ID | Regra | Origem | Como verificar | Tarefa que cria a checagem |
|---|---|---|---|---|
| G-28 | Nenhum comentário ou string de código cita ID de tarefa, lote ou rodada (`TP-`, `RTP-`, `SPK-`, `BK-`, "Lote N") | CONVENCOES §4 | `guarda-id-tarefa` no CI | TP-0002 |
| G-29 | `backend/` e `frontend/` têm `README.md` e `.env.example` com todas as variáveis, sem valor real | Convenção do ambiente (`implementation-guideline-drafting`) | Passo do CI que falha se algum dos quatro arquivos faltar; `gitleaks` | TP-0002 |

---

## Fora deste documento (governados em outro lugar)

Estes itens são restrições reais do projeto, mas não são regra de código verificável por máquina. Ficam onde já estão:
- **Escopo da Fase 1 congelado** e teto de esforço de **150 h** (desde 2026-10-16; antes 90 h), com a lista de corte do PRD §5 como reserva: `CTO-REVIEW.md` (Gate 1, ressalva 1), `PRD.md` §4 e §5, RNF-16 e `TASK.md` §5.
- **Regra de passagem entre fases** (2 semanas de uso real): `CTO-REVIEW.md` (ressalva 4).
- **Custo recorrente ≤ R$ 10/mês** (alvo R$ 0): `SDD.md` §3.
- **Chave privada do backup com o usuário**: ADR-007 (procedimento no `DEPLOY.md`).

---

## Como mudar este documento

- **Mudança estrutural** (adicionar, remover ou reescrever uma regra, ou trocar a checagem dela): o Coordenador propõe, com o motivo. O Gestor aprova ou reprova (skill `guardrails-governance`). Uma mudança aprovada entra na regra e no Log de Alterações no mesmo passo. Uma reprovação fica registrada em `CTO-REVIEW.md`.
- **Exceção pontual** (pular uma regra por um escopo ou prazo): o mesmo caminho, com **validade obrigatória** (data ou condição de expiração). Quando ela expira, a regra original volta a valer sem nova aprovação.
- **Checagem que falha:** o Executor nunca afrouxa a checagem nem o limite para o CI passar (ex.: o `--limite 1` da G-26). Ele corrige o código, ou registra um BK pedindo a mudança da regra.
- **Formatação e typo:** qualquer agente corrige direto, sem registro.

---

## Log de Alterações

| Data | Proposto por | Aprovado por | Mudança | Motivo | Validade |
|---|---|---|---|---|---|
| 2026-10-16 | coordenador | gestor | Versão inicial aprovada: G-01 a G-29, com os ajustes das linhas abaixo | Regras derivadas do Gate 1, do SDD, dos ADR-001 a 007 e do UX-SPEC, aprovados pelo usuário no Loop B. Cada regra tem origem, checagem automática e tarefa dona da checagem no `TASK.md` (Loop C aprovado) | Permanente |
| 2026-10-16 | gestor (revisão da proposta) | gestor | G-14 reescrita: a proibição vale para a **aplicação**, e o `backup.yml` agendado (ADR-007) fica explicitamente fora dela | A redação original ("não existe agendador, cron...") contradizia literalmente o ADR-007, já aprovado. A checagem não muda | Permanente |
| 2026-10-16 | gestor (revisão da proposta) | gestor | G-08 esclarecida: o que conta como "confirmação" do `--producao` à mão e no `deploy.yml` | Sem isso, a G-08 (confirmação) e a G-04 (migração só pelo workflow, que não é interativo) podiam ser lidas como contraditórias | Permanente |
| 2026-10-16 | gestor (revisão da proposta) | gestor | Seção "Como mudar este documento" adicionada. Coluna `Validade` adicionada ao log. Status passa de rascunho para em vigor. Teto de 150 h citado em "Fora deste documento" | Governança de PIPELINE-CONVENTIONS.md §5 explícita no próprio documento. Teto atualizado por decisão do usuário na rodada 2 do Loop C (`TASK.md` §5.2, S-01) | Permanente |
