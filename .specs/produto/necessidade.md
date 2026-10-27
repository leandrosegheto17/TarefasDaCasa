# Necessidade: Tarefas da Casa

- **Data**: 2026-10-27
- **Veredito**: construir
- **Aprovado**: 2026-10-27, pelo usuário (fases 1 a 3)
- **Mockup**: aprovado em 2026-10-27 — direção C "Rotina em colunas", só tema claro; `.specs/mockup/` (galeria: https://claude.ai/artifact/SCcivnZ8r7TvuNHahN9jba)
- **Motivo de construir**: quero aprender (praticar o padrão LJS num app novo) e resolver a divisão de tarefas da família; há potencial de virar produto Free/Pro, ainda sem modelo de monetização definido.

## 1. Necessidade

- **O que resolve**: dividir as tarefas domésticas entre as pessoas da casa (quem faz o quê), sem esquecer as que se repetem, e ver quem cumpriu.
- **Como faço hoje**: combinado de boca, papel na geladeira e grupo de WhatsApp.
- **Frequência de uso**: diária (marcar o que fez, receber o lembrete do dia).
- **Quem usa**: a família, 4 a 6 pessoas, pelo celular (PWA).

## 2. O que já existe

Pesquisa do agente `pesquisador` em 2026-10-27. Confiança alta para Donetick, Grocy e KitchenOwl (README e releases lidos, nada testado); baixa para o restante.

| Solução | Cobre | Não cobre | Licença e custo | Roda local (Docker)? | Ativa? | Fonte |
|---|---|---|---|---|---|---|
| Donetick | Recorrência, atribuição, rodízio (round-robin, aleatório, quem fez menos), multiusuário, pontos, lembretes (app, Telegram, Discord, Pushover), API | App iOS em alpha, Android só por APK; PT-BR não confirmado; versão 0.x | AGPLv3, grátis | sim | v0.1.83, 2026-10-18 | github.com/donetick/donetick |
| Grocy (módulo chores) | Tarefas recorrentes divididas entre membros, multiusuário | Sistema amplo (estoque, compras) e interface pesada; rodízio e lembretes não confirmados; sem app nativo | MIT, grátis | sim (linuxserver/grocy) | v4.7.1, 2026-09-04 | github.com/grocy/grocy |
| Homechart | Calendário compartilhado com tarefas e lembretes | Sem PT entre os idiomas; licença e Docker não confirmados | não confirmada | não confirmado | v2026.10 (data não obtida) | homechart.app/docs |
| KitchenOwl | Compras, receitas, despesas | Não tem tarefas | AGPL-3.0 | sim | v0.7.10, 2026-07-26 | github.com/TomBursch/kitchenowl |
| Tody, Sweepy, Cozi | Tarefas/limpeza com atribuição (Cozi: listas e calendário) | Não auto-hospedáveis; sincronizar a família é pago no Tody; rodízio do Cozi não confirmado | proprietárias, freemium | não | não verificado | reportagens sem data (kob.com, tomsguide.com) |

- **Conclusão**: o Donetick cobre quase todo o essencial e seria a escolha se o objetivo fosse só resolver a necessidade. Constrói-se porque o objetivo inclui aprender e manter um app no padrão LJS com potencial de produto; nenhuma alternativa tem PT-BR confirmado nem push no celular sem app de terceiros. Se a construção perder o sentido, **adaptar o Donetick** é o plano B.

## 3. Escopo pessoal

- **Essencial**:
  - Casa (grupo) com membros: adultos com conta própria (e-mail) que entram por convite; crianças podem ser **perfis sem login**, marcados por um adulto (D-02).
  - Tarefas com responsável, inclusive **recorrentes** (diária, semanal, mensal) sem recadastrar.
  - **Marcar como feita** e **histórico** de quem fez o quê (ex.: semana).
  - **Lembretes no celular** por Web Push (padrão LJS) com as tarefas do dia.
  - PWA instalável (Android e iOS).
- **Fica de fora** (primeira entrega):
  - **Rodízio automático** (D-03): atribuição é manual; vira evolução.
  - **Cobrança** (Asaas, página "Meu plano", trial): a estrutura Free/Pro do padrão fica prevista, mas não é construída agora (D-01).
  - Pontos, gamificação, recompensas; integração com WhatsApp ou Telegram; lista de compras.
- **Bom o bastante quando**: a família (4 a 6 pessoas) troca o papel e o WhatsApp pelo app por **2 semanas seguidas**: as tarefas recorrentes aparecem sozinhas, cada um recebe o lembrete do dia e marca o que fez, e o histórico da semana mostra quem fez o quê; publicado no domínio com backup diário restaurado com sucesso.

### Decisões do usuário (2026-10-27)

| ID | Tema | Decisão |
|---|---|---|
| D-01 | Monetização | Segue no fluxo 2. Free/Pro do padrão LJS fica previsto (sem bloquear o modelo de dados), mas limites, preço e Asaas ficam fora da primeira entrega. [A ESCLARECER: o que é Free e o que é Pro; se a dúvida pesar, abrir o fluxo 1 só para o plano comercial] |
| D-02 | Membros | Conta própria para adultos, por convite; perfis sem login para crianças, marcados por um adulto |
| D-03 | Rodízio | Fora da primeira entrega |
| D-04 | Domínio | `tarefasdacasa.ljssoftware.com.br` |
| D-05 | Stack e infra | Padrão LJS ([padrao-ljs.md](padrao-ljs.md)), sem trocar nenhum item sem justificar e perguntar |
| D-06 | Isolamento | O dono dos dados é a **casa** (`casa_id`), não o usuário: o RLS do padrão filtra pela casa da sessão (`SET LOCAL app.casa_id` além de `app.usuario_id`). Teste negativo obrigatório: membro da casa B não lê nem escreve nada da casa A. PREMISSA: um usuário pertence a uma casa só na primeira entrega [A ESCLARECER na spec] |

## 4. Restrições

- **Onde roda**: nuvem gratuita (Cloudflare Workers + Neon Free via Hyperdrive), padrão LJS. Localmente, Docker só para o Postgres.
- **Limites dos planos gratuitos**: consultados em **2026-10-24** pelo agente `pesquisador` para o EvolucaoSegura_LJS (`.specs/produto/necessidade.md` §4 daquele projeto), com fonte. Reaproveitados aqui porque são de 3 dias atrás e da mesma conta; reconferir na implantação.

| Serviço | Limite | Fonte |
|---|---|---|
| Workers Free | 100.000 requisições/dia; **10 ms de CPU** por requisição e por cron; 50 subrequests por invocação; **5 Cron Triggers por conta** | developers.cloudflare.com/workers/platform/limits/ |
| Rate Limiting binding | Disponibilidade no Free não confirmada (confiança baixa) | developers.cloudflare.com/workers/runtime-apis/bindings/rate-limit/ |
| Hyperdrive Free | 10 configs; ~20 conexões à origem; 100.000 consultas/dia (confiança média) | developers.cloudflare.com/hyperdrive/platform/limits/ |
| Neon Free | 1 GB por projeto; 100 CU-h/mês; autosuspend de 5 min; 10 branches; restore de 6 h; sa-east-1 | neon.com/docs/introduction/plans |
| Resend Free | 100 e-mails/dia, 3.000/mês, 3 domínios | resend.com/pricing |
| Sentry Developer | 5k erros; retenção de 30 dias (confiança média) | sentry.io/pricing/ |
| GitHub Actions (privado) | 2.000 min/mês; 500 MB de artefatos | docs.github.com |

- **Stack**: a do padrão LJS (pnpm, TypeScript, Hono no Worker, React 19 + Vite + PWA, Kysely, Vitest) — já dominada; usada em ControleEmCasa_LJS, EvolucaoSegura_LJS e GestaoDaPelada_LJS.
- **Exposição**: internet, com autenticação própria, HTTPS, rate limit e **auditoria de segurança** na validação.

## 5. Dados e backup

- **Dados guardados**: contas (nome, e-mail, hash de senha), casas e membros (inclusive nomes de crianças), tarefas, conclusões (histórico) e inscrições de push. Dado pessoal de menores (LGPD art. 14): coletar o mínimo (só nome ou apelido do perfil).
- **Custo de perder**: médio. Recadastrar tarefas é chato, e o histórico se perde, mas nada tem obrigação legal.
- **Backup**: padrão LJS — diário às 04:00 BRT no GitHub Actions, `pg_dump -Fc` com a role `backup_ro`, cifrado com `age`, retenção de 30 dias, e branch de restauração no Neon antes de cada deploy.
- **Teste de restauração**: obrigatório na validação, a partir de uma cópia limpa, e documentado no runbook.

## 6. Riscos e dúvidas

- **Cron Triggers: 5 por conta**, e agora são 4 apps LJS na mesma conta. Este app usa **um único cron** (lembretes do dia e geração das recorrências). [A ESCLARECER: quantos crons os outros 3 apps já usam; se faltar, despachar por um cron compartilhado ou mover para GitHub Actions]
- **Resend: 100 e-mails/dia** compartilhado com os outros apps no mesmo domínio. Aqui só convite, confirmação e recuperação gastam e-mail; o risco é a soma com os outros apps.
- **Web Push no iOS** só funciona com o PWA instalado na tela inicial (padrão LJS já prevê instrução de instalação). PREMISSA: a família tem iPhone e Android.
- **Perfis sem login** (crianças) não recebem push; o lembrete vai para o adulto responsável. [A ESCLARECER na spec]
- **Horário do lembrete**: [A ESCLARECER: hora fixa por casa (ex.: 7h) ou por pessoa]
- **Monetização**: indefinida (D-01). Risco de modelar algo que depois o plano comercial contradiga; mitigação: manter os limites do Free na API, configuráveis, sem regra de negócio espalhada.
- **Abandono**: a ferramenta só vale se a família usar; o critério de "bom o bastante" (2 semanas de uso real) é o teste.
