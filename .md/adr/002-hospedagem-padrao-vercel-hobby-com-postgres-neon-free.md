# ADR-002: A hospedagem é Vercel Hobby (estático + função Node) com PostgreSQL no Neon Free; a VM compartilhada do usuário fica como plano B, atrás da mesma origem

- **Status:** Aceito (escolha do usuário na rodada 2 do Loop B, 2026-10-16: P-01 e P-04 respondidas)
- **Data:** 2026-10-16 (rodada 1); revisado em 2026-10-16 (rodada 2, antes da aceitação)
- **Decisor:** Coordenador (chapéu Software Architect) propôs; **o usuário escolheu** manter Vercel + Neon mesmo com a VM disponível. D-05 delegou o "como" do RNF-07 ao Coordenador
- **Requisitos ligados:** RNF-07, RNF-12, RNF-13, RNF-14, RNF-06, RF-23; D-02, D-05, R-P3, R-P8; ADR-001, ADR-003, ADR-006

## Histórico de revisão

| Rodada | Mudança |
|---|---|
| 1 | Proposta: Vercel Hobby + Neon Free; VM do projeto anterior como pergunta P-01 |
| 2 | **P-01:** a VM compartilhada existe e aceita mais um app, mas o usuário mantém Vercel + Neon. A VM passa a ser **plano B** registrado (RT-02, RT-07), sem ADR próprio. **P-04:** o usuário já tem contas no GitHub, na Vercel e no Neon. **D-02:** a origem definitiva é um subdomínio da Vercel (ADR-006), então o plano B precisa preservar essa origem (item 5) |

## Contexto

- **RNF-07:** depois de 30 dias sem acesso, o app volta sozinho, sem intervenção manual e sem perder dados. O Supabase Free está descartado porque **pausa** o projeto e exige reativação manual.
- **RNF-14:** custo recorrente com teto de R$ 10/mês. Com o D-02 (subdomínio `vercel.app`), o custo-alvo passa a ser **R$ 0**.
- **RNF-12:** marcação em até 2 s e Hoje em até 3 s (p95), em 4G no Brasil.
- **ADR-004** precisa de hash de senha forte (`scrypt`), o que exige CPU de verdade. No plano gratuito do Cloudflare Workers, o limite é de 10 ms de CPU por requisição.
- **A VM do usuário existe** e aceita mais um app (P-01, rodada 2): é a VM compartilhada do projeto anterior, com proxy único e padrão de publicação próprio. O usuário preferiu não colocar o app nela agora.
- Fatos conferidos em 2026-10-16:
  - **Neon Free:**
    - 100 CU-h por projeto por mês e 0,5 GB de armazenamento;
    - scale-to-zero depois de 5 min parado, **sem opção de desligar**;
    - **reativação automática em algumas centenas de ms** na próxima consulta.
    - Fontes: [Neon, scale to zero](https://neon.com/docs/introduction/scale-to-zero); [Neon, free plan](https://neon.com/faqs/free-plan-limits-and-quotas).
  - **Vercel Hobby:**
    - funções em Fluid compute, com até 300 s e 2 GB / 1 vCPU;
    - cron no máximo 1 vez por dia;
    - logs de execução retidos por 1 h;
    - **rewrites para destino externo** permitidos, com tempo máximo de 120 s;
    - uso pessoal, não comercial.
    - Fontes: [Vercel, limits](https://vercel.com/docs/limits); [Vercel, cron](https://vercel.com/docs/cron-jobs/usage-and-pricing).

## Decisão

1. **Hospedagem:**
   - **Vercel Hobby** serve o PWA estático e a API como **uma função Node** (Node 24 LTS), na mesma origem (ADR-001).
   - Projeto Vercel **`tarefas-da-casa-ljs`**, cuja URL de produção é a origem definitiva (ADR-006).
   - Região da função: São Paulo (`gru1`), se o plano permitir escolher. Se não permitir, fica a região padrão, e a latência é medida no spike de infraestrutura.
2. **Banco:**
   - **Neon Free**, região `aws-sa-east-1`, PostgreSQL 17;
   - conexão pelo endpoint com pooler (modo transação);
   - computação fixa em 0,25 CU.
3. **Como isso cumpre o RNF-07:** nenhum dos dois componentes pausa de um jeito que exija ação humana.
   - A função não tem estado e sobe a cada requisição.
   - O banco dorme depois de 5 min e acorda sozinho na primeira consulta.
   - Depois de 30 dias parado, o primeiro acesso paga só o tempo de acordar. A estimativa é de 1 a 2 s a mais, a medir no spike.
4. **Portabilidade obrigatória:** o código da API não depende de nada específico da Vercel.
   - O ponto de entrada da Vercel (`entradas/vercel.ts`) é um arquivo de poucas linhas que adapta o app HTTP.
   - Um segundo ponto de entrada (`entradas/servidor-node.ts`) roda o mesmo app como processo comum. Ele serve ao desenvolvimento local e ao plano B.
5. **Plano B: a VM compartilhada do usuário, sem trocar a origem.**
   - **Quando acionar:**
     - (a) o spike ou o uso real mostra que a latência da primeira abertura do dia estoura o RNF-12 (RT-02);
     - (b) a Fase 3 precisa de agendador mais fino que o cron diário do Hobby (RT-07).
   - **Como, preservando a origem `tarefas-da-casa-ljs.vercel.app` (R-P3):**
     - a API passa a rodar como contêiner na VM, pelo `servidor-node.ts`, com o mesmo Neon;
     - o projeto Vercel continua servindo o PWA estático e ganha um **rewrite de `/api/*` para a VM**;
     - para o navegador, nada muda: mesma origem, mesmo cookie host-only, nenhuma reinstalação.
   - **No caso (b),** basta o agendador rodar na VM. A API pode continuar na Vercel.
   - **Custo:** o rewrite acrescenta um salto de rede (Vercel até a VM). Precisa ser medido se o plano B for acionado.
   - **Registro:** um novo ADR substitui este quando o plano B for acionado. Hoje não há ADR próprio para a VM, por decisão do usuário.
6. **Custo:** R$ 0. Vercel Hobby, Neon Free e GitHub são gratuitos, e não há domínio pago (ADR-006).

## Consequências

**Positivas**
- **Custo zero**, abaixo do alvo original de R$ 3,33/mês.
- Nenhum servidor para manter. O deploy é por `git push`.
- Existe uma saída concreta e já paga (a VM) para os dois riscos conhecidos, sem perder instalações.
- Sair do fornecedor de banco é simples: PostgreSQL padrão, exportado com `pg_dump`.

**Negativas**
- **Dois fornecedores** (Vercel e Neon), cada um com sua conta e seus limites.
- **Latência fria:** quando a função e o banco estão parados, a primeira requisição soma três tempos: o início da função, o acordar do banco e a abertura da conexão (RT-02).
- **A origem fica presa à Vercel** (ADR-006).
  - Trocar de provedor de front-end exige reinstalar e revincular todos os aparelhos.
  - Pelo plano B, só a API e o agendador podem sair da Vercel.
- **Cron só diário no Hobby.** Não afeta a Fase 1, que não usa agendador (ADR-003). Afeta a Fase 3, que tem a VM como saída.
- **Logs de execução por só 1 h.** A API grava os erros num log próprio, em tabela (SDD §2.7).
- **Termos do Hobby:** uso pessoal e não comercial. Atende hoje. Se um dia comercializar, a hospedagem e a origem precisam ser revistas.

## Alternativas consideradas

| Alternativa | Por que não (agora) |
|---|---|
| Supabase Free | Pausa por inatividade e exige reativação manual (RNF-07, R-P8). Descartado no Gate 1 |
| Cloudflare Workers + D1 (grátis) | O limite de 10 ms de CPU é apertado para o `scrypt`. Exige o DNS na Cloudflare |
| Render Free e outros serviços que "dormem" | Levam dezenas de segundos para acordar. Estouram o RNF-12 |
| Oracle Cloud Always Free | Pode recuperar instâncias ociosas (fere o RNF-07) e exige administrar o servidor |
| **VM compartilhada do usuário já como hospedagem principal** | **Disponível** (P-01). O usuário preferiu Vercel + Neon. Fica como plano B (item 5) |
| Plano pago (Vercel Pro, Neon Launch) | Acima do teto sem necessidade |
