# STATE

## Decisions

### AD-001 — Roteiro em 5 features (2026-10-27)

- **Decisão**: quebrar o escopo de [necessidade.md](produto/necessidade.md) em 5 features verticais, nesta ordem: `fundacao` → `conta-e-acesso` → `casa-e-membros` → `tarefas-e-historico` → `lembretes` (`.specs/projeto/roadmap.md`). A ordem segue a dependência: a infraestrutura destrava a conta, a conta destrava a casa, e a casa e o isolamento por `casa_id` (D-06) destravam as tarefas. Depois da feature 4 a família já consegue largar o papel; os lembretes vêm por último porque dependem das tarefas.
- **Incerteza puxada para a frente**: a `fundacao` confere quantos Cron Triggers a conta ainda tem livres (limite de 5 por conta, dividido com os outros apps LJS) e se o binding de rate limit existe no Free, antes de alguma feature depender disso.
- **Alternativa descartada**: uma feature única dividida em etapas (como no EvolucaoSegura_LJS). Foi descartada porque não tem ponto de validação e liberação no meio, e a família só usaria no fim.
- **Fora do roteiro por enquanto**: rodízio automático (D-03) e planos e cobrança (D-01). Entram como features novas, com novo AD, quando forem decididos.

### AD-002 — Reuso da fundação do GestaoDaPelada_LJS (2026-10-27)

- **Decisão**: infra, ferramentas, workflows, checagens, cliente de banco, middlewares e a infra do PWA são copiados de `C:\Leandro\Projetos\GestaoDaPelada_LJS` (commit `9a4afab`) e adaptados. Testes copiados só entram ligados a um requisito. O visual não é copiado: vem de `.specs/mockup/`.
- **Alternativas descartadas**: montar do zero pelo `padrao-ljs.md` (repete trabalho já liberado) e extrair um template LJS compartilhado (fora do escopo deste projeto).

### AD-003 — Isolamento por casa com RLS (2026-10-27)

- **Decisão**: toda tabela de negócio tem `casa_id`, com RLS `FORCE`. O contexto é `set_config('app.usuario_id', …, true)` por transação, e `casas_visiveis()` (`SECURITY DEFINER`, `search_path` fixo) devolve as casas do usuário via `membro`. Escrita só com usuário definido. Role da API `tarefas_app` (sem bypass), backup `tarefas_backup` com policy de leitura total, migrations como owner.
- **Vale para**: todas as features. Tabela nova com `casa_id` precisa de RLS forçada e caso de isolamento (meta-teste).

### AD-004 — Repositório público no desenvolvimento, privado antes de publicar; backup como artefato (2026-10-27)

- **Decisão**: o repositório fica público enquanto não há dados reais (minutos do Actions). O backup diário cifrado é artefato do Actions com 30 dias de retenção. O backup e o dump do deploy recusam rodar com o repositório público, então a primeira publicação exige torná-lo privado.
- **Alternativas descartadas**: release num repositório privado separado e Cloudflare R2 (pesquisa de 2026-10-27).

### AD-005 — Fontes locais, iguais no mockup e no app (2026-10-27)

- **Decisão**: Sora e Source Sans 3 (OFL) ficam como arquivos do projeto, usados pelo mockup e pelo app. O `@import` do Google Fonts sai do `tokens.css`. A CSP fica sem host externo de fonte.

### AD-006 — Instalabilidade por Playwright no lugar do Lighthouse PWA (2026-10-27)

- **Decisão**: o teste de instalabilidade (manifest, SW controlando a página, ícones e página offline) substitui o "Lighthouse PWA ≥ 90" do padrão LJS. A categoria PWA saiu do Lighthouse (mesma decisão do AD-005 do GestaoDaPelada_LJS).

### AD-007 — Tarefas da fundação aprovadas (2026-10-27)

- **Decisão**: `.specs/features/fundacao/tasks.md` aprovado com 86 tarefas (T1 a T86) em 11 fases, matriz de testes e gates do padrão LJS. A execução fica para uma sessão nova, por decisão do usuário, e as ações externas da fase 11 pedem confirmação uma a uma.

## Retomada

- **Fluxo**: 2 Uso próprio — skill `uso-proprio`
- **Item**: `.specs/features/fundacao/`
- **Fase aprovada**: 5, Tarefas (tasks.md T1 a T86) em 2026-10-27
- **Próxima fase**: 6, Construção (Execute do `tlc-spec-driven`) — modelo indicado: sonnet
- **Construção**: ainda não iniciada. Antes de começar, o tlc oferece despachar subagentes por lote (~7 tarefas, fases inteiras).
- **Progresso**: Plano: faltam 5 de 5 features (0%); Projeto: faltam 86 de 86 tarefas (0%), conferido em 2026-10-27
- **Combinado na conversa e não registrado em artefato**: o usuário pediu parar antes de executar. Ações externas da fase 11 (Hyperdrive/secrets, push, tornar o repositório privado, deploy, restauração, instalação do PWA) pedem confirmação uma a uma.
- **Gravada em**: 2026-10-27
