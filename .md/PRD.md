# PRD.md — Tarefas da Casa

> **Status:** rascunho, rodada 1 do Loop A (`/planejar`), 2026-10-16. Gate 1 aprovado com ressalvas (`.md/CTO-REVIEW.md`).
> **Insumos:** briefing do usuário + `.md/PLANO-COMERCIAL.md` (rodada 3).
> **Uso:** pessoal, só a família do usuário. Não é produto comercial: o Anexo A do plano comercial e a ideia I7 ficam dormentes.
> **Escopo:** este documento detalha a **Fase 1 (MVP)**. As Fases 2 e 3 aparecem só como roadmap, **fora do escopo do MVP**.

---

## 1. Problema e Contexto

**Problema, em termos verificáveis:** hoje as tarefas recorrentes da casa (pendurar roupa, lavar louça, regar plantas, limpar banheiro) são distribuídas e cobradas **verbalmente** por um adulto. Isso cria três efeitos observáveis:
1. A carga mental de lembrar e cobrar fica com um adulto.
2. Não existe registro do que foi feito, de quem fez nem de quanto da casa foi cuidado na semana.
3. Quando uma tarefa não tinha como ser feita naquele dia (por exemplo, não havia roupa para pendurar), ela vira "não feita" e motivo de cobrança injusta.

**Contexto:**
- A família tem filhos. Cada criança tem celular próprio e idade para usar o app sozinha (~7 anos ou mais).
- Os aparelhos são recentes, e todos os iPhones têm iOS 16.4 ou superior.
- A distribuição é só por PWA instalado pelo navegador. Não há TWA, Google Play nem App Store.
- O próprio usuário desenvolve, com teto de 150 h para a Fase 1 (era ~90 h até 2026-10-16; ver o Histórico de alterações no fim).
- Um projeto anterior com a mesma ideia (`C:\Leandro\Projetos\TarefasEmCasa_bkp`) morreu com 455 tarefas e nunca foi publicado. Ele serve **só como referência conceitual**, e nenhum requisito dele entra aqui além das 8 ideias aprovadas (I1 a I8).

**Por que agora / por que construir:** as alternativas gratuitas (papel, WhatsApp, OurHome) não entregam ao mesmo tempo as regras I1 (pular sem punir), I2 (placar congelado), I3 (crédito para quem fez) e I6 (linguagem neutra), conforme a Seção 4 do plano comercial. O retorno não é monetário: casa em dia, crianças participando, menos cobrança verbal.

## 2. Público-Alvo

Só a família do usuário. Os papéis do produto são:

| Papel no produto | Quem | Necessidade principal | Acesso |
|---|---|---|---|
| **Responsável** | Adultos da casa. O primeiro é o próprio usuário, que cria a família | Cadastrar membros e tarefas em ≤ 15 min, manter com quase nenhum esforço, ver se a casa está em dia e marcar as próprias tarefas | Conta com credencial (e-mail + senha) e sessão persistente no próprio aparelho. Pode usar também o navegador do computador para cadastrar |
| **Criança** | Filhos, ~7 anos ou mais, cada um com celular próprio | Ver o que tem para fazer hoje, marcar em ≤ 10 s e ver o próprio esforço contar | **Sem conta.** Perfil com apelido e avatar, e sessão própria no próprio celular, criada por vínculo feito por um Responsável (D-01) |

Na Fase 1 não existe um papel de "adulto só executor": todo adulto é Responsável, com as mesmas permissões. Isso simplifica o MVP (interpretação registrada em PRD-TECNICO §7, IR-01).

## 3. Objetivo de Sucesso

| ID | Métrica | Baseline | Meta | Como medir |
|---|---|---|---|---|
| **M1 (principal)** | Adoção contínua: % de semanas em que **todos** os membros marcaram ao menos 1 ocorrência (concluída ou pulada) | 0 (não existe ferramenta; hoje é cobrança verbal) | **≥ 10 de 12 semanas** com todos os membros ativos, contadas a partir da semana em que o último aparelho da família foi vinculado | Visão "Atividade por membro" do Responsável (RF-22) |
| **M1b (qualitativa, acompanha M1)** | As crianças marcam **sem um adulto lembrar** | Desconhecido | Observação do usuário: nas semanas 3 a 12, nenhuma semana em que a marcação da criança dependeu de lembrete verbal | Observação do usuário, sem instrumento no app |
| **M2 (entrega)** | A Fase 1 chega a uso real | Projeto anterior: 0 publicações | Fase 1 instalada e em uso em **todos** os aparelhos da família até a data-limite (D-03), com **≤ 150 h** de esforço (teto atualizado em 2026-10-16) | Data da primeira semana com todos os membros ativos e horas registradas pelo usuário |
| **M3 (atrito, indicador antecipado)** | Tempo para marcar uma tarefa e tempo de cadastro | — | "Abrir o app → marcar" em **≤ 10 s** em todos os aparelhos. Cadastro da família inteira em **≤ 15 min** | Cronometragem pelo usuário na semana 1 (premissas A2 e A3) |

O usuário declarou o critério de sucesso como "indiferente" (só referência). O Gestor o mantém como métrica porque sem ele não há como decidir a passagem para a Fase 2 (Seção 4, regra de passagem).

## 4. Escopo desta Release (Fase 1 — MVP, congelado)

**Teto: 150 h**, aceito pelo usuário em 2026-10-16 (rodada 2 do Loop C), sem cortes. A estimativa oficial é a do Coordenador: 150 h em 99 tarefas (`TASK.md` §5). As horas por bloco da tabela abaixo (~85 h) são a referência original do Dono e ficam só como histórico. A diferença vem de testes, CI, fidelidade visual e operação, já decididos no SDD e no UX-SPEC, e **não de escopo novo**. O escopo continua congelado.

**Reserva de corte:** a lista de corte da Seção 5 só é usada se o andamento real (horas gastas + estimativa das tarefas restantes) passar de 150 h, e cada item só sai com aprovação do usuário.

**R-P7 continua:** nenhuma fase seguinte começa sem 2 semanas de uso real da Fase 1 por toda a família (regra de passagem abaixo).

### Dentro (Fase 1)

| Bloco | O que entra | Ideias | Horas de referência (Dono) |
|---|---|---|---|
| B1 Base | Domínio definitivo (D-02), PWA instalável em iOS e Android, deploy em HTTPS e instruções de instalação no app (Could) | — | ~10 h |
| B2 Família | Criar família, conta do Responsável, convidar outro Responsável, perfil de criança (apelido e avatar), editar e remover membro | — | ~15 h |
| B3 Vínculo de aparelho | Código de vínculo de uso único (QR + código digitável) gerado por um Responsável, sessão persistente sem conta e lista e revogação de aparelhos (D-01, resolve G-1) | — | ~8 h |
| B4 Tarefas | Cadastro de tarefa com periodicidade por dias da semana (cobre diária e semanal em dia fixo), periodicidade semanal flexível (D-14), atribuição manual a um membro ou a "Qualquer um", edição e arquivamento | — | ~15 h |
| B5 Ocorrências | Gerar ocorrências; concluir (crédito para quem concluiu); pular; estado Atrasada até concluir ou pular, com a próxima ocorrência gerada mesmo assim; desfazer no período aberto; pendências de semanas anteriores agrupadas | **I1, I3** | ~12 h |
| B6 Placar | % da semana corrente (parcial), fechamento e congelamento da semana, histórico das semanas fechadas e atividade por membro para Responsáveis | **I2** | ~10 h |
| B7 Painel | Tela "Hoje" e painel com linguagem neutra, "Minhas contribuições" | **I6** | ~5 h |
| B8 Instalação real | Instalação e teste em todos os aparelhos da família, e ajustes | — | ~10 h |
| | | | **~85 h** |

### Fora (Fase 1), com justificativa

| Fora | Justificativa | Vai para |
|---|---|---|
| Peso de esforço 1 a 3 (I5) | O % sem peso já funciona. O peso só gera valor depois que a família perceber, no uso, que algumas tarefas "valem mais" | Fase 2 |
| Rodízio automático (I4) | A atribuição manual basta para uma família pequena, e o rodízio pouparia o adulto só depois | Fase 2 |
| Recorrência "N dias depois da última conclusão" (I4) | Exige outra lógica de geração de ocorrências. Adiar protege o teto (R-P7) | Fase 2 |
| Lembretes push, horário de silêncio e aviso agrupado (I8) | É o bloco mais caro e de maior risco de plataforma, e traz agendamento no servidor | Fase 3 |
| Corte do plano grátis (I7) | Só se aplica se um dia comercializar | Dormente (Anexo A do plano) |
| TWA, Google Play e App Store | Decisão do usuário: só PWA | Fora de todas as fases |
| Marcação offline com sincronização posterior | Fila offline é complexidade alta para pouco ganho em casa, onde há Wi-Fi (D-04) | Backlog, sem fase |
| Recuperação de senha por e-mail | O link de e-mail abre no Safari, não no app instalado (R-P4), e exigiria um provedor de e-mail. Na Fase 1, um outro Responsável gera um código de vínculo, ou o usuário-desenvolvedor redefine a senha (D-11) | Backlog, sem fase |
| Periodicidade mensal, datas específicas e tarefa única | Não estão nas 8 ideias. Dias da semana e semanal flexível cobrem a rotina doméstica principal | Backlog, sem fase |
| Pontos, recompensas, mesada, ranking, chat, foto de comprovação e várias famílias | Não estão nas 8 ideias (R-P7). Ranking também contraria I6 | Fora |
| Funcionalidades do projeto `TarefasEmCasa_bkp` além de I1 a I8 | Regra de escopo crítica (R-P7) | Fora |

### Regra de passagem entre fases
A Fase N+1 só começa quando a Fase N estiver **em uso real por toda a família há pelo menos 2 semanas** (critério do Dono, ratificado no Gate 1). Há uma exceção, que depende de confirmação do usuário (D-08): se nas semanas 2 e 3 da Fase 1 as crianças **esquecem** de marcar, mas marcam quando alguém lembra, as Fases 2 e 3 trocam de ordem.

### Roadmap (fora do escopo do MVP)

| Fase | Conteúdo | Ideias | Horas de referência | Requisitos de alto nível |
|---|---|---|---|---|
| **Fase 2: justiça refinada e menos trabalho do Responsável** | Peso de esforço, rodízio automático e recorrência relativa | I5, I4 | ~25 h | RF-F2-01 a RF-F2-03 (PRD-TECNICO §1.2) |
| **Fase 3: lembretes** | Push por aparelho, pedido de permissão por gesto (iOS), horário de silêncio de 22h às 07h e no máximo 1 aviso de atraso agrupado por dia | I8 | ~32 h | RF-F3-01 a RF-F3-03 (PRD-TECNICO §1.2) |
| Dormente | Corte do plano grátis | I7 | — | Só se comercializar |

## 5. Requisitos de Alto Nível Priorizados (Fase 1)

Prioridade em MoSCoW. A ordem de corte é **reserva** (desde 2026-10-16): vale só se o andamento real passar do teto de 150 h, e cada corte exige aprovação do usuário. Os Could (H14, H15) saem antes do H13 (`TASK.md` §5.2).

| # | Requisito de alto nível | Prioridade | Justificativa | Ordem de corte |
|---|---|---|---|---|
| H1 | Cada membro tem sessão própria e persistente no próprio celular, e a criança entra **sem conta** (vínculo por código) | Must | Sem isso, nenhuma criança usa o app (A1, A3). Resolve G-1 e R-P6 | — |
| H2 | O Responsável cadastra família e tarefas recorrentes por dias da semana, com atribuição manual | Must | É o núcleo do pedido original ("cadastro de família", "cadastro de tarefas e periodicidade") | — |
| H3 | Qualquer membro conclui uma ocorrência e o crédito vai para quem concluiu | Must | Pedido original ("cada um informa que finalizou") + I3 | — |
| H4 | Pular uma ocorrência: conta como "checada, não feita", não pontua e não é atraso | Must | Caso original do usuário (varal) + I1 | — |
| H5 | Estado Atrasada até concluir ou pular, com a próxima ocorrência gerada mesmo assim | Must | I1. Sem isso a fila trava ou a falta some | — |
| H6 | % da semana, e a semana fechada fica congelada | Must | Pedido original ("% ao fim de cada período") + I2 | — |
| H7 | Painel e textos com linguagem neutra, sem associar nome a atraso | Must | I6. Custo baixo e protege a adesão das crianças | — |
| H8 | O app é instalável como PWA, no domínio definitivo, com o servidor como fonte da verdade | Must | R-P3 e R-P5. Sem isso, qualquer erro é irreversível ou perde dados | — |
| H9 | Atividade por membro (contagem semanal), visível para Responsáveis | Should | Instrumento da métrica M1. Sem ele, o sucesso não é medido | 5º a cortar (vira consulta manual no banco) |
| H10 | Desfazer marcação no período aberto | Should | Toque acidental de criança é provável, e sem desfazer o placar fica errado | 4º a cortar (vira só Responsável desfazendo) |
| H11 | Periodicidade semanal flexível (1x na semana, qualquer dia) | Should | Tarefas como "trocar roupa de cama" não têm dia fixo | 3º a cortar (vira dia fixo) |
| H12 | Pendências de semanas anteriores agrupadas, com "pular todas" para o Responsável | Should | Tarefas diárias acumulam atrasadas (I1) e entulham a tela | 2º a cortar |
| H13 | Histórico das semanas fechadas (lista de % congelados) | Should | Dá confiança no placar (I2), mas a semana anterior basta no início | 1º a cortar (vira só "semana anterior") |
| H14 | Instruções de instalação dentro do app (iOS: Compartilhar → Adicionar à Tela de Início) | Could | Na Fase 1 o usuário instala pessoalmente em cada aparelho (R-P2) | Primeiro dos Could |
| H15 | Responsável marca a conclusão **em nome de** outro membro (o crédito vai para o membro escolhido) | Could | Útil quando a criança fez mas está sem o celular. Fora disso, é custo extra | Primeiro dos Could |

## 6. Premissas e Riscos de Produto

| ID | Premissa / risco | Dono | Prazo de validação | Como validar |
|---|---|---|---|---|
| A1 | As crianças engajam além da novidade e marcam sozinhas | Usuário | Semanas 1 a 3 da Fase 1 em uso | RF-22 (atividade por membro). O esquecimento aciona o gatilho de reordenação (D-08) |
| A2 | O Responsável não abandona o cadastro (≤ 15 min) | Usuário | Semana 1 de uso | Cronometrar (M3) |
| A3 | Marcar leva ≤ 10 s e a sessão persiste no aparelho de cada um | Usuário (medição) + Gestor (requisito RNF-02 e RNF-05) | Semana 1 de uso | Cronometrar em cada aparelho |
| A4 | A Fase 1 chega a uso real em ≤ 8 semanas e ≤ 150 h (teto atualizado em 2026-10-16; ~19 h por semana) | Gestor (escopo congelado) + Coordenador (estimativa) + usuário (data-limite D-03) | No `/definir` (estimativa) e na data-limite | Estimativa de 150 h no TASK.md (feito); horas reais registradas; reserva de corte se passar do teto |
| A5 | Instalação, sessão e armazenamento funcionam em todos os aparelhos | Usuário | Semana 1 de uso (bloco B8) | Teste em cada aparelho |
| R-P3 | O domínio é irreversível | Usuário (escolha) | **Antes da primeira instalação real** (início do bloco B8, ou antes se houver teste em aparelho da família) | D-02 |
| R-P5 | Perda do armazenamento local no iOS | Gestor (requisito) + Coordenador (solução) | `/definir` (SDD) | RNF-04 |
| R-P6 / G-1 | Dados de menores e sessão da criança sem conta | Gestor (requisito) + Coordenador (solução) | `/definir` (SDD) | D-01, RNF-08 |
| R-P7 | Super-engenharia | Gestor | Cada rodada de `/definir` e `/executar` | Escopo congelado (Seção 4) + teto de 150 h + lista de corte como reserva (Seção 5) + regra de passagem (2 semanas de uso real antes de qualquer fase seguinte) |
| R-P8 | Pausa do free tier | Coordenador (stack) | `/definir` (SDD) | RNF-07 |
| RP-01 (novo) | O placar sem divisão por pessoa no painel compartilhado pode reduzir a motivação de quem gosta de ver o próprio número | Usuário | Semanas 1 a 3 | "Minhas contribuições" (RF-21) mitiga. Observar e reavaliar na Fase 2 |
| RP-02 (novo) | Ocorrências diárias atrasadas acumulam e entulham a tela, fazendo a família desistir | Gestor (requisito H12) | Semanas 1 e 2 | Observar o volume de atrasadas em aberto |

## 7. Perguntas em Aberto para o Business Analyst

Respondidas no `PRD-TECNICO.md` (as interpretações estão na Seção 7 de lá; as decisões que dependem do usuário estão na Seção 6):
1. Quando a semana começa e termina, e em qual fuso? → PRD-TECNICO RN-01 (D-06)
2. Uma ocorrência atrasada de uma semana já fechada, concluída depois, conta em qual %? → RN-10 (D-10)
3. Quem pode pular? A criança pode pular qualquer tarefa? → RN-12 (D-07)
4. Como o % parcial da semana corrente trata ocorrências futuras da própria semana? → RN-08
5. O que acontece com ocorrências já geradas quando a tarefa é editada ou arquivada, ou quando um membro é removido? → RN-14 a RN-16
6. Como exibir o % (arredondamento) e o que mostrar numa semana sem tarefas? → RN-09 (D-12)

---

### Registro do `stakeholder-alignment-check` (chapéu PM → chapéu BA)
- O escopo da Seção 4 cabe no teto do Gate 1 (~85 h, com lista de corte). *(Situação em 2026-10-16: o teto passou a 150 h, ver o Histórico de alterações.)*
- O objetivo da Seção 3 é coerente com o objetivo de negócio do Gate 1.
- Nenhuma premissa do `PLANO-COMERCIAL.md` foi contrariada (canal só PWA, custo em free tier, faseamento da Seção 6.4 mantido).
- Não houve necessidade de reabrir o `dono`.
- **Sem conflito não resolvido.**

---

### Histórico de alterações

| Data | Mudança | Motivo | Decidido por |
|---|---|---|---|
| 2026-10-16 | Teto da Fase 1 de 90 h para **150 h**, sem cortes. A lista de corte da Seção 5 vira reserva (usada só acima de 150 h, com aprovação do usuário). Atualizados: §1 Contexto, §3 M2, §4 Teto, §5 introdução, §6 A4 e R-P7 | A estimativa por tarefa do Coordenador (`TASK.md` §5) deu 150 h. O excedente vem de testes, CI, fidelidade visual e operação, e não de escopo novo (`TASK.md` §6.1 S-01). Escopo e regra de passagem (R-P7) não mudam. Não conflita com o `PLANO-COMERCIAL.md`: não muda custo, canal nem faseamento | Usuário (rodada 2 do Loop C); registro pelo Gestor (ressalva 1 do Gate 1, `CTO-REVIEW.md`) |
