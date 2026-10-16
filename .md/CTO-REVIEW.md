# CTO-REVIEW.md

Log de governança do Gestor (chapéu CTO). Cada seção = um gate ou parecer ad hoc, com data, achados e veredito. Entradas mais recentes no topo.

---

## Alteração da ressalva 1 do Gate 1 (teto da Fase 1) — 2026-10-16

**Origem:** decisão do usuário na rodada 2 do Loop C do `/definir` (`TASK.md` §5.2, opção 1; lacuna S-01 em §6.1).
**O que mudou:** o teto da Fase 1 passa de **90 h para 150 h**, sem cortes. A lista de corte do PRD §5 vira **reserva**: só é usada se o andamento real passar de 150 h, e cada item só sai com aprovação do usuário.
**Motivo:** a estimativa por tarefa do Coordenador deu 150 h (99 tarefas). Os ~85 h do PRD eram uma referência por bloco, sem estimativa por tarefa. O excedente vem de testes de contrato, integração e e2e (~13 h), guardas automáticas e CI (~7 h), fidelidade visual (~10 h) e operação (~10 h). Nada disso é escopo novo: é trabalho já decidido no SDD e no UX-SPEC que não aparecia nos blocos. Mesmo com a lista de corte inteira, o esforço não voltaria para 90 h (sobravam ~47 h).
**Leitura do Gestor:**
- **O escopo continua congelado.** Nenhum requisito entrou. A regra "requisito novo exige retirar outro de valor igual ou maior, ou reabrir este gate" continua valendo.
- **R-P7 (super-engenharia) continua aberto.** O teto maior aumenta a exposição ao risco que matou o projeto anterior. Por isso a regra de uso real fica mantida sem alteração: nenhuma fase seguinte começa sem 2 semanas de uso real da Fase 1 por toda a família (ressalva 4).
- **Prazo:** 150 h em 8 semanas são ~19 h por semana para uma pessoa. A data-limite D-03 é do usuário. Se ela ficar inviável, o usuário escolhe entre mover a data e usar a reserva de corte. O teto não sobe de novo sem reabrir este gate.
**Artefatos atualizados:** este arquivo (ressalva 1), `PRD.md` (§1, §3 M2, §4, §5, §6 A4 e histórico), `PRD-TECNICO.md` (RNF-16, R-P7 da §6.1 e histórico), `GUARDRAILS.md` ("Fora deste documento").
**Status de S-01 no `TASK.md`:** a atualização pendente com o Gestor está feita. A marcação de status na tabela é do Coordenador.

---

## Guardrails — Aprovação da versão inicial — 2026-10-16

**Skill:** `guardrails-governance`. **Proposto por:** coordenador (Loop C do `/definir`, rodada 1). **Insumos:** `GUARDRAILS.md` (rascunho, 29 regras), `SDD.md`, ADR-001 a 007, `UX-SPEC.md`, `TASK.md` (aprovado pelo usuário).
**Escopo:** governança das regras. Não é parecer técnico sobre o SDD nem sobre o TASK.

**Classificação:** primeira versão do documento, com status de rascunho até agora. Ela é tratada como mudança estrutural: as 29 regras entram de uma vez, como permanentes.

**Avaliação:**
- **Motivo e origem:** todas as 29 regras têm origem rastreável (Gate 1, SDD, ADR, UX-SPEC, PRD-TECNICO ou convenção), checagem automática e tarefa dona da checagem no `TASK.md`. Nenhuma é preferência de estilo.
- **Coerência com o Gate 1:** G-09 e G-22 sustentam o R-P6 (dados de menores). G-01 a G-03 sustentam o R-P3 (origem irreversível). G-25 sustenta o D-04. G-23 e G-24 sustentam o I6. G-14 sustenta o ADR-003 e o RNF-07.
- **Efeito colateral encontrado e corrigido:**
  1. **G-14 × ADR-007:** a redação "não existe agendador, cron..." contradizia o `backup.yml` agendado do ADR-007. Ela foi reescrita para valer só para a aplicação. A checagem não muda.
  2. **G-08 × G-04:** "`--producao` com confirmação" não dizia o que é a confirmação num workflow não interativo. Ficou esclarecido.
- **Governança:** foi adicionada a seção "Como mudar este documento" (estrutural, exceção com validade, checagem que falha nunca é afrouxada). O log ganhou a coluna `Validade`.
- **Fora do documento:** o teto de esforço, a regra de passagem e o custo seguem governados fora do GUARDRAILS (não são verificáveis por máquina). A referência ao teto foi atualizada para 150 h.

**Veredito:** **Aprovado com ajustes.** O documento está em vigor a partir de 2026-10-16. As 4 entradas estão no Log de Alterações do `GUARDRAILS.md`.

---

## Gate 1 — Pré-descoberta — 2026-10-16

**Insumos:** briefing do usuário (ideia original + decisões do Loop 0) e `.md/PLANO-COMERCIAL.md` (rodada 3, aprovado pelo usuário no `/avaliar_ideia`).
**Skill:** `tech-strategy-review`.

### Objetivo de negócio

Em uma frase: **dar à família do usuário (adultos e filhos, cada um no próprio celular) um placar semanal da casa, justo e não acusatório, que substitua a cobrança verbal e que todos usem de forma contínua por pelo menos 12 semanas.**

O objetivo é verificável. O critério de sucesso do `PLANO-COMERCIAL.md` é: em 12 semanas, todos os membros marcam pelo menos 1 tarefa por semana em pelo menos 10 das 12 semanas, e as crianças marcam sem um adulto lembrar. O usuário o deixou só como referência. Mesmo assim, o Gestor o adota como métrica do PRD, porque sem ele não há como saber se a Fase 1 deu certo. Não há objetivo de receita: o app é de uso pessoal, sem comercialização.

### Alinhamento com roadmap

**Reforça.** Não existe roadmap corporativo. O "roadmap" é o faseamento da Seção 6.4 do plano comercial, e esta proposta é exatamente a Fase 1 dele. A proposta não compete com nenhuma outra iniciativa. O único histórico relevante é contrário: o projeto anterior (`TarefasEmCasa_bkp`) morreu com 455 tarefas e nunca foi publicado (R-P7). Por isso o alinhamento só vale se a Fase 1 for de fato enxuta.

### Plausibilidade de orçamento/prazo (sinalização, sem estimativa detalhada)

- **Dinheiro:** plausível. O custo-alvo é de ~R$ 3,33/mês (domínio), com o restante em free tier. O teto de referência é R$ 10/mês.
- **Tempo:** plausível, **com risco alto de execução**. A Fase 1 tem ~85 h (teto de ~90 h) e meta de uso real em até 8 semanas. É viável para um desenvolvedor solo se o escopo ficar congelado. O sinal de alerta vem do histórico (R-P7), não da conta. *(Nota de 2026-10-16: a estimativa por tarefa do `TASK.md` deu 150 h, e esse passou a ser o teto. Ver a alteração da ressalva 1 no topo.)*
- **Sinais de incompatibilidade:**
  1. Push (I8) dentro do MVP estouraria o teto, e já está na Fase 3. Correto.
  2. A sessão da criança sem conta (G-1) tem ~8 h reservadas. É suficiente se a solução for um vínculo simples por código (proposta no PRD-TECNICO, D-01).
  3. Um free tier com pausa (R-P8) não muda o orçamento, mas pode quebrar a adoção nas férias. Vira requisito não funcional, não aumento de custo.

### Gap de roster

**Nenhum gap.** O app é web/PWA com back-end simples e sem IA, pagamentos ou integrações de terceiros na Fase 1. Coordenador (arquitetura + UX + decomposição), Executor (back-end + front-end) e Validador (QA + segurança + deploy) cobrem o projeto. Observação: o chapéu "Mobile" do Executor não é necessário, porque não há TWA nem app nativo. O PWA é responsabilidade do front-end.

### Riscos estratégicos e de compliance (nível estratégico; o tático fica com o Validador)

| ID | Leitura do Gestor | Encaminhamento |
|---|---|---|
| R-P6 / G-1 | Dados de menores (LGPD art. 14; ECA Digital, Lei 15.211/2025). Em uso estritamente familiar e privado, o risco jurídico é baixo, desde que haja minimização: só apelido e avatar, sem conta, e-mail, foto, data de nascimento ou rastreador de terceiros | Requisito RNF-08 e decisão D-01 (vínculo do aparelho por código de uso único). Se um dia comercializar, a análise jurídica precisa ser refeita (Anexo A) |
| R-P3 | O domínio é irreversível: instalação, armazenamento e push ficam presos à origem | RNF-06 e decisão D-02: domínio escolhido e apontado **antes da primeira instalação real** |
| R-P5 | Perda do armazenamento local no iOS | RNF-04: o servidor é a fonte da verdade, e o aparelho guarda só cache e sessão. Recuperação em até 2 min |
| R-P8 | Pausa do free tier | RNF-07: o back-end não pode ficar indisponível por até 30 dias de inatividade sem intervenção manual. A escolha da stack é do Coordenador |
| R-P4 | Login duplo (Safari ≠ app instalado no iOS) | RNF-05 e fluxo: a sessão é sempre criada **dentro do app instalado**. Sem link mágico por e-mail, porque ele abre no Safari |
| R-P7 | Super-engenharia | Escopo da Fase 1 congelado no PRD (Seção 4), com lista de corte ordenada (PRD Seção 5, reserva desde 2026-10-16), teto de 150 h, data-limite (D-03) e regra de uso real antes de qualquer fase seguinte (ressalva 4) |

### Veredito

**Aprovado com ressalvas.** Os chapéus PM e BA ficam liberados.

**Ressalvas (condições que acompanham o pipeline):**
1. **Escopo da Fase 1 congelado** no PRD.md, Seção 4. Qualquer requisito novo na Fase 1 exige retirar outro de valor igual ou maior, ou reabrir este gate. **Teto da Fase 1: 150 h** (atualizado em 2026-10-16, ver a alteração no topo deste arquivo). A lista de corte do PRD (Seção 5) é **reserva**: só é usada se o andamento real (horas gastas + estimativa das tarefas restantes) passar de 150 h, e cada item só sai com aprovação do usuário. O teto não sobe de novo sem reabrir este gate.
   *Redação original (2026-10-16, substituída):* "Se a estimativa do Coordenador (`effort-estimation`) passar de 90 h, aplica-se a lista de corte do PRD (Seção 5) antes de aprovar o TASK.md."
2. **Data-limite de uso real da Fase 1** a ser fixada pelo usuário (D-03; sugestão: 8 semanas a partir da aprovação do `/definir`).
3. **Domínio definitivo (R-P3)** escolhido antes da primeira instalação em aparelho da família (D-02).
4. **Regra de passagem entre fases:** a Fase 2 só começa depois de 2 semanas de uso real da Fase 1 por toda a família. A exceção é o gatilho de reordenação (troca da Fase 2 pela Fase 3), que depende de confirmação do usuário (D-08).
5. **Nenhum requisito do projeto anterior** além das 8 ideias aprovadas (I1 a I8, sendo I7 dormente).

**Upstream:** o `PLANO-COMERCIAL.md` está presente e aprovado. Não há ressalva por ausência do Loop 0.
