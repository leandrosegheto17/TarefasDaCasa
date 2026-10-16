# ADR-003: Ocorrências e fechamento de semana são materializados sob demanda, na própria requisição, sem agendador; o estado Atrasada é derivado da data

- **Status:** Aceito (o usuário aprovou o B1 do Loop B em 2026-10-16)
- **Data:** 2026-10-16
- **Decisor:** Coordenador (chapéu Software Architect)
- **Requisitos ligados:** RF-11, RF-15, RF-17, RF-18, RF-19, RN-02 a RN-05, RN-08 a RN-11, RN-13 a RN-15, RNF-07, RNF-15; IR-07; ADR-002

## Contexto

- CA-11.2 exige que as ocorrências do dia **já existam** quando alguém abre a tela Hoje, mesmo que ninguém tenha aberto o app nos dias anteriores.
- CA-19.3 e IR-07: o % congelado da semana tem que ser o mesmo, seja calculado no instante do fim do período, seja depois. O conteúdo define o resultado, não o momento.
- A hospedagem padrão (ADR-002) não tem processo sempre ligado e o cron do Hobby é só diário. Um agendador seria mais uma peça para falhar em silêncio, justamente nas férias (RNF-07).
- RNF-15: todas as regras de data usam `America/Sao_Paulo`, nunca o fuso do aparelho.

## Decisão

1. **Rotina única "pôr em dia"** (`garantirEmDia`), chamada no início de toda requisição autenticada que lê dados da família (Hoje, Casa, histórico, contribuições, atividade, marcação). Numa transação, ela:
   1. **gera ocorrências** de cada tarefa ativa do dia seguinte ao `gerado_ate` da tarefa até o **domingo da semana corrente**, com `INSERT ... ON CONFLICT DO NOTHING` sobre a chave única `(tarefa, data_prevista)`. A semanal flexível gera uma ocorrência por semana, com data prevista no domingo (RN-04). A geração nunca começa antes do dia de criação ou reativação (RN-13);
   2. **fecha as semanas vencidas:** para cada semana terminada sem linha em `semana_fechada`, calcula e grava as contagens e o % considerando **somente marcações com instante ≤ fim do período** (RN-09a), com `ON CONFLICT DO NOTHING`.
   - Atalho barato: a família guarda `em_dia_ate` (data). Se já for o domingo corrente e não houver semana a fechar, a rotina custa uma leitura.
2. **Estado Atrasada não é gravado.** O banco guarda só `pendente`, `concluida` e `pulada`. "Atrasada" = `pendente` com `data_prevista` < hoje no fuso da família. Nenhum processo precisa virar o estado à meia-noite (RN-04).
3. **A marcação vive na própria ocorrência:** quem recebe o crédito, quem registrou (RF-25), instante e motivo do pulo. Desfazer limpa esses campos (RN-11). Não há tabela de eventos.
4. **Por que o fechamento tardio é determinístico:** depois do fim do período, nada que ainda é permitido muda o resultado. Conclusões tardias têm instante > fim e ficam fora (RN-10). Desfazer uma marcação de período fechado é proibido (RN-11). Edição e arquivamento só mexem de hoje ou amanhã em diante (RN-14, RN-15). A remoção de membro não muda contagem (RN-16). Testes automáticos cobrem cada um desses casos.
5. **Relógio e fuso num só lugar:** um módulo `relogio` do domínio converte o instante do servidor em "hoje", "início e fim da semana" em `America/Sao_Paulo` com `Intl`, sem fixar o deslocamento (o Brasil pode voltar a ter horário de verão). Os testes injetam o relógio.

## Consequências

**Positivas**
- Zero agendador na Fase 1: nada para falhar em silêncio, e cumpre o RNF-07 por construção.
- Concorrência resolvida pelas chaves únicas: dois aparelhos abrindo ao mesmo tempo produzem o mesmo resultado.
- O mesmo gerador é o ponto de extensão da Fase 2 (peso, rodízio, recorrência relativa).

**Negativas**
- A primeira requisição depois de muitos dias parado faz mais trabalho (gerar semanas de ocorrências e fechar várias semanas). Volume pequeno: 20 tarefas × 30 dias ≈ 600 linhas. Aceito.
- Toda leitura passa pela rotina. Um erro nela derruba a leitura. Mitigação: é a parte mais testada do domínio (SDD §6).
- O % congelado depende de o histórico de marcação não ser apagado. Regra: ocorrência marcada nunca é apagada (GUARDRAILS).

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Cron diário (Vercel) gerando ocorrências e fechando a semana | Mais uma peça, com precisão de 1 h no Hobby. Falha silenciosa quebra o CA-11.2. A rotina sob demanda já resolve |
| Gerar ocorrências de vários meses de uma vez | Complica RN-14 (regenerar o futuro) e o arquivamento. Gerar até o domingo corrente basta |
| Gravar o estado Atrasada | Exigiria um processo à meia-noite. Derivar é mais simples e sempre correto |
| Tabela de eventos de marcação (event sourcing) | Poder demais para uma família. Os requisitos se resolvem com os campos na ocorrência |
