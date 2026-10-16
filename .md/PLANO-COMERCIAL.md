# PLANO-COMERCIAL.md

> **Veredito: Vale, condicionado, como projeto pessoal de uso familiar. Em tempo puro a conta NÃO se paga; ela só se justifica se a família adotar de verdade e o escopo for entregue em fases, com a Fase 1 em uso real antes de qualquer coisa a mais.**
> Leitura honesta: em dinheiro o projeto é quase de graça (custo-alvo de **~R$ 3,33/mês**, só o domínio, com o resto em free tier). O custo real é o **tempo**: **Fase 1 (MVP) ~85 h**, Fase 2 ~25 h, Fase 3 ~32 h, total **~142 h** (Seção 6.4). Nenhuma economia de tempo da família devolve isso em menos de ~3 a 5 anos (Seção 6.3). Logo, o retorno é **não monetário**: casa em dia, crianças participando, menos cobrança verbal. O projeto só vale se (a) a família, crianças incluídas, usar continuamente por 3 meses ou mais e (b) o escopo não repetir o projeto anterior, que morreu com 455 tarefas sem nunca ser publicado. Chance estimada de adoção por 3 meses ou mais: **~35%** (Seção 5). Subiu dos ~30% da rodada 2 porque cada criança tem celular próprio, os aparelhos são iOS 16.4+ e o escopo foi faseado.
> Rodada: 3 (respostas do usuário Q-F1 a Q-F6 incorporadas; faseamento criado) | Última rodada: 2026-10-16

**Mudança de enquadramento em relação à rodada 1:** o usuário definiu que o app é para **uso da própria família**, sem negócio, sem meta de receita, distribuído **só como PWA** (sem TWA e sem Google Play), com foco em **família com filhos**, e que ele mesmo vai desenvolver. A pergunta do plano deixa de ser "dá retorno?" e passa a ser "**vale o tempo e o custo para a família?**". O critério de sucesso é **adoção real**. As análises comerciais da rodada 1 não se aplicam agora e ficaram preservadas no **Anexo A, "Se um dia comercializar"**.

**Critério de sucesso (mensurável), mantido como referência:** o usuário considerou indiferente por ser uso pessoal, então não exige ratificação. depois de 12 semanas de uso, **todos os membros**, crianças incluídas, marcaram pelo menos 1 tarefa por semana em pelo menos 10 das 12 semanas, e as crianças marcam **sozinhas**, sem um adulto lembrar.

---

## 1. Proposta de Valor e Modelo de Venda

**Proposta de valor para a família (uma frase):**
"A casa em dia sem cobrança verbal: cada um marca o que fez, as crianças veem o próprio esforço contar, e no fim da semana o percentual congelado mostra quanto da casa foi cuidado, sem apontar culpados."

**Modelo de venda e preço: N/A (uso familiar).** Não há cobrança. A hipótese de preço da rodada 1 (R$ 9,90/mês ou R$ 79,90/ano) está guardada no Anexo A.

**As 8 ideias do usuário, registradas como proposta de valor e diferenciais.** Vêm do projeto antigo `C:\Leandro\Projetos\TarefasEmCasa_bkp`, usado só como referência conceitual. O usuário decidiu incluir todas. A definição de produto (o que entra em qual release, regra exata, UX) é do Gestor. Aqui está registrado **por que cada uma tem valor para a família**:

| # | Ideia (decisão do usuário) | Valor para a família | Status |
|---|---|---|---|
| I1 | **Pular/cancelar com regras:** a tarefa pulada não pontua e não conta como atraso. A não feita fica "Atrasada" até ser concluída ou pulada, e a próxima ocorrência é gerada mesmo assim | Resolve o caso original do stakeholder ("não tinha roupa para pendurar") sem punir ninguém, e não deixa a fila travar | Ativa |
| I2 | **Período fechado nunca é recalculado:** o % da semana encerrada fica congelado | O número da semana vira um fato combinado, sem discussão retroativa. Dá confiança no placar | Ativa |
| I3 | **O crédito vai para quem concluiu**, mesmo que a tarefa fosse de outra pessoa | Incentiva a ajuda entre membros e reflete o esforço real | Ativa |
| I4 | **Rodízio automático entre membros** e recorrência **"N dias depois da última conclusão"** | Tira do adulto a tarefa mental de redistribuir. A recorrência relativa evita acumular, por exemplo, "regar planta" | Ativa |
| I5 | **Peso de esforço de 1 a 3 por tarefa**, ponderando o % | "Lavar o banheiro" vale mais que "guardar o controle". A percepção de justiça melhora | Ativa |
| I6 | **Linguagem neutra no painel**, sem culpar ninguém | Protege a adesão das crianças e evita que o app vire instrumento de briga (P3, Seção 5) | Ativa |
| I7 | **Corte do plano grátis:** o grátis nunca mostra a divisão por pessoa | **Dormente:** só se aplica se um dia comercializar (Anexo A). Não foi descartada | Dormente |
| I8 | **Lembretes com horário de silêncio** (22h às 07h) e **no máximo um aviso de atraso agrupado por dia** | Evita fadiga de notificação, a principal causa de alguém desativar o push e abandonar o app | Ativa |

---

## 2. Público-Alvo Comercial

**Público-alvo comercial: N/A (uso familiar).** O ICP de mercado da rodada 1 está guardado no Anexo A.

**Público real, os usuários:** a própria família do usuário, com filhos.

| Papel | Quem | O que precisa para adotar `[PREMISSA]` |
|---|---|---|
| Administrador | Adulto que cadastra a família e as tarefas (o usuário) | Configuração rápida e manutenção quase zero. Se o cadastro der trabalho, ele abandona (A2) |
| Adultos executores | Demais adultos da casa | Marcar a conclusão em poucos segundos e lembrete sem incômodo |
| Crianças | Filhos com idade para usar o app sozinhos (~7 anos ou mais). **Premissa confirmada de forma genérica** pelo usuário (Q-F1: "Ok"), sem número de filhos nem idades exatas informados. **Cada criança tem celular próprio** (Q-F2) | Ver o próprio esforço contar, com sessão própria no próprio aparelho, identificada só por apelido e avatar. Como dar sessão própria sem criar conta para a criança é questão em aberto para o Gestor (G-1, Seção 7.2) |

**Aparelhos da família (Q-F3):** todos recentes, com iOS 16.4 ou superior nos iPhones. Informado pelo usuário.

---

## 3. Canais de Publicação e Distribuição

**Canal único: PWA instalado a partir do navegador** (decisão do usuário). Não há TWA, Google Play nem App Store.

| Aspecto | Situação | Fonte/premissa |
|---|---|---|
| Distribuição | O usuário passa o link para cada membro e faz a instalação ("Adicionar à Tela de Início") em cada aparelho | `[PREMISSA]` |
| Android | Instalação de PWA pelo Chrome, com push funcionando | `[NÃO VERIFICADO nesta rodada]`: comportamento amplamente documentado |
| iPhone/iPad | Instalação **manual** pelo Safari. **Push só funciona com o app instalado na Tela de Início e no iOS/iPadOS 16.4 ou superior**, e a permissão só pode ser pedida a partir de um toque do usuário | [WebKit: Web Push for Web Apps on iOS and iPadOS](https://webkit.org/?p=13878) |
| Custo de aquisição | **N/A (uso familiar)**: zero, porque a família é cadastrada pelo próprio usuário | — |

Canais pagos, ASO e conteúdo orgânico: **N/A (uso familiar)**, guardados no Anexo A.

---

## 4. Concorrentes e Diferenciação

No uso familiar, o "concorrente" é **a alternativa que a família usaria em vez de construir o app**. O projeto só se justifica se for melhor que a alternativa gratuita para **esta** família.

| Alternativa | Custo em R$ | Custo em tempo | O que ela não faz frente às 8 ideias | Fonte |
|---|---|---|---|---|
| **Papel/quadro na geladeira** | ~R$ 0 a 30 (uma vez) | ~1 h para montar | Não calcula o % ponderado (I5), não faz rodízio (I4) nem lembrete (I8). Por outro lado, tem **atrito mínimo** e está sempre visível. É o rival real em adesão (A3) | `[PREMISSA]` |
| **Grupo de WhatsApp da família** | R$ 0 | ~0 | Sem placar, histórico ou periodicidade. Tende a virar cobrança verbal por escrito (contrário a I6) | `[PREMISSA]` |
| **OurHome** | R$ 0 (gratuito) | ~1 a 2 h para configurar | Tem pontos e recompensas para filhos. Até onde a pesquisa mostrou, não tem I1, I2 nem I5 com as regras definidas pelo usuário `[NÃO VERIFICADO funcionalmente]`. Interface em inglês `[NÃO VERIFICADO]` | [iPhoneLife](https://iphonelife.com/content/best-free-cleaning-apps-spotless-home); [Top10.com](https://top10.com/household-chore-apps/reviews/home-routines) |
| Sweepy, Tody, Homey, Nipto (pagos) | US$ 20 a 50/ano; Nipto R$ 69,90/ano | ~1 a 2 h | Ver Anexo A | Anexo A |

**Diferenciais desta construção para a família:** as 8 ideias da Seção 1, principalmente I1 (pular sem punir), I2 (placar congelado), I3 (crédito para quem fez), I5 (peso de esforço) e I6 (linguagem neutra). Juntas, elas desenham um placar **justo e não acusatório**, coisa que nenhuma alternativa gratuita entrega por inteiro `[PREMISSA, verificação funcional não feita]`. O usuário também ganha controle total, privacidade (dados da família fora de terceiros) e aprendizado técnico.

**Pré-teste com papel ou OurHome: opcional, não é condição.** O usuário decidiu construir de qualquer forma. Fica como sugestão barata: 2 semanas com papel em paralelo ao desenvolvimento da Fase 1 dariam um sinal antecipado de A1 (engajamento das crianças) sem atrasar nada. O percentual da Seção 5 **não** considera esse ganho.

---

## 5. Hipótese de Viabilidade

**Percentual comercial: N/A (uso familiar).** No lugar dele:

**Percentual de "a família adota e usa por 3 meses ou mais" (critério de sucesso do topo): ~35%.**
Nesta rodada não há ganho por pré-teste: o pré-teste com papel ou OurHome é opcional e não entra no cálculo (Seção 4). O valor da rodada 2 era ~30%.

| # | Premissa crítica | Confiança (rodada 2 → 3) | Evidência atual | O que a derruba (fato observável) | Como validar barato |
|---|---|---|---|---|---|
| A1 | **As crianças engajam** além da novidade (semana 3 em diante) e marcam sozinhas | ~45% → **~55%** | As crianças têm idade para usar o app sozinhas (~7+, confirmação genérica do usuário) e **cada uma tem celular próprio**, então marcam no próprio aparelho, sem depender de um adulto. Não há evidência de engajamento real | Na semana 3, as crianças só marcam quando um adulto pede, ou deixam de marcar | Olhar as marcações por membro nas semanas 1 a 3 da Fase 1 (gatilho de reordenação: Seção 6.4) |
| A2 | **O adulto administrador não abandona** o cadastro e o registro (configuração e manutenção baixas) | ~60% (sem mudança) | O usuário é o próprio desenvolvedor e tem motivação alta. O histórico do projeto anterior mostra risco de energia gasta em construir, não em usar. Na Fase 1, sem rodízio (I4), a atribuição é manual e pesa um pouco mais | O administrador deixa de ajustar tarefas ou de marcar as próprias por 2 semanas seguidas | Medir quanto tempo leva para cadastrar a família inteira (meta: ≤ 15 min) e quantos ajustes/semana são necessários depois |
| A3 | **O app tem menos atrito que o papel:** marcar uma tarefa leva ≤ 10 s, e cada membro tem **sessão própria e persistente no próprio aparelho** | ~55% → **~60%** | O celular próprio permite sessão individual sem troca de usuário. Ainda há instalação manual no iOS (R-P2) e login duplo (R-P4), e a forma de vincular o aparelho da criança sem conta está em aberto (G-1) | Algum membro volta ao papel ou ao WhatsApp porque "é mais rápido", ou o vínculo/instalação trava alguém | Cronometrar o fluxo "abrir → marcar" em cada aparelho da família na primeira semana |
| A4 | **A Fase 1 chega a uso real** (publicada e instalada em todos os aparelhos) em ≤ 8 semanas e ≤ ~90 h, sem super-engenharia | ~50% → **~55%** | O faseamento (Seção 6.4) separa o MVP de ~85 h do resto. Evidência **contrária** que continua valendo: o projeto anterior morreu com 455 tarefas e nunca foi publicado | A Fase 1 passa de ~110 h, ou 8 semanas passam sem a família usando | O Gestor congela o escopo da Fase 1. Data-limite de uso real definida antes de começar |
| A5 | **A plataforma não sabota:** instalação, push e armazenamento funcionam em todos os aparelhos | ~70% → **~80%** | Os aparelhos são recentes e todos os iPhones têm iOS 16.4+ (usuário), então o push em web app instalado é suportado ([WebKit](https://webkit.org/?p=13878)). Restam R-P4 e R-P5, além de R-P3, que é irreversível | Um aparelho perde a sessão ou os dados locais, e o membro para de usar | Testar a instalação e a sessão em todos os aparelhos na primeira semana da Fase 1 |

**Derivação:** as premissas estão em série (todas precisam valer). O produto ingênuo dá ~9% (0,55 × 0,60 × 0,60 × 0,55 × 0,80), mas elas são **positivamente correlacionadas**: uma Fase 1 enxuta (A4) tende a ter pouco atrito (A3), e pouco atrito, com cada um no próprio celular, sustenta o engajamento das crianças (A1) e do adulto (A2). Por isso o agregado fica em **~35%**, abaixo das premissas mais fracas (A1 e A4, ~55%).

**Leitura honesta:** o maior risco continua sendo **(A4) o projeto não chegar ao uso**, como o anterior, seguido de **(A1) as crianças não engajarem** depois da novidade. O celular próprio e os aparelhos recentes melhoraram A1, A3 e A5, mas não tocam em A4. O que mais protege A4 é a disciplina do faseamento: a Fase 1 em uso real antes de qualquer linha da Fase 2.

---

## 6. Break-even

**Break-even em número de vendas: N/A (uso familiar).** Os números da rodada 1 estão no Anexo A. Aqui o break-even é de **custo pessoal**: quanto a família gasta com o app comparado à alternativa gratuita.

### 6.1 Custo em dinheiro (custo-alvo mensal de infraestrutura)

| Item | Custo | Fonte/premissa |
|---|---|---|
| Domínio `.com.br` (Registro.br) | R$ 40/ano = **R$ 3,33/mês** | [Teletime / NIC.br](https://teletime.com.br/14/10/2026/br-6-milhoes/); [tudosobrehospedagemdesites](https://tudosobrehospedagemdesites.com.br/registro-de-dominio/) |
| Hospedagem do front-end PWA (estático) | **R$ 0** (free tier) | `[PREMISSA][NÃO VERIFICADO]`: há hospedagens estáticas gratuitas. A escolha de stack é do Coordenador |
| Banco/back-end | **R$ 0** (free tier) | Exemplo de referência: o Supabase Free oferece 500 MB de banco, mas **pausa projetos com baixa atividade por 7 dias** e exige reativação manual ([Supabase docs](https://supabase.com/docs/guides/platform/free-project-pausing); [Jetadmin](https://www.jetadmin.io/blog/supabase-pricing-2026-guide-to-plans-limits-and-real-world-costs/)). Isso é risco em férias da família (R-P8). A stack é decisão do Coordenador, e este é só um exemplo de que o custo zero é plausível |
| Web Push (envio) | **R$ 0** | `[PREMISSA][NÃO VERIFICADO]`: o protocolo padrão de Web Push não cobra por mensagem |
| Contador, CNPJ, comissão de loja | **R$ 0, N/A** (sem cobrança, sem loja) | Ver Anexo A |
| **Custo-alvo mensal** | **≈ R$ 3,33/mês (~R$ 40/ano)**. Teto de referência: **≤ R$ 10/mês** | Referência, sem exigência de ratificação (o usuário considerou indiferente em uso pessoal) |

### 6.2 Custo em tempo

| Item | Horas | Fonte/premissa |
|---|---|---|
| Fase 1 (MVP) | **~85 h** (faixa de 70 a 110) | `[PREMISSA do Dono]`: estimativa grosseira, detalhada na Seção 6.4. A estimativa oficial é do Coordenador (`effort-estimation`) |
| Fase 2 | **~25 h** (faixa de 18 a 35) | `[PREMISSA do Dono]` |
| Fase 3 | **~32 h** (faixa de 24 a 45) | `[PREMISSA do Dono]` |
| **Total das fases 1 a 3** | **~142 h** (faixa de 112 a 190) | Coerente com os ~150 h da rodada 2 |
| Manutenção depois da adoção | ~2 h/mês | `[PREMISSA]` |
| Valor de referência da hora (só para comparar) | R$ 60/h, ou seja, Fase 1 ≈ R$ 5.100 e total ≈ R$ 8.500 de custo de oportunidade | `[PREMISSA]` da rodada 1. É custo de oportunidade, não desembolso |

### 6.3 A conta explícita: app próprio contra a alternativa gratuita

| | App próprio (PWA) | Papel / WhatsApp / OurHome |
|---|---|---|
| Desembolso | **R$ 40/ano** | **R$ 0 a 30** |
| Diferença de caixa | **+R$ 40/ano**, ou seja, **≈ R$ 3,33/mês a mais** que a alternativa gratuita | — |
| Tempo de construção | ~85 h (Fase 1) a ~142 h (fases 1 a 3) | ~1 a 2 h para configurar |
| Tempo de manutenção | ~24 h/ano | ~0 a 6 h/ano (refazer o quadro, ajustar o app) |

**Payback em tempo, se o único ganho for economia de tempo:**
- Hipótese otimista: o app economiza **30 min/semana** do adulto em coordenação e cobrança (~26 h/ano). Descontada a manutenção (~24 h/ano), o ganho líquido fica em **~2 h/ano**. Na prática, **não se paga**.
- Hipótese muito otimista: economiza **1 h/semana** (~52 h/ano). Descontada a manutenção, sobram ~28 h/ano, e o payback da Fase 1 (85 h) leva **~3,0 anos**. Com as fases 1 a 3 (142 h), leva **~5,1 anos**.

**Veredito do break-even pessoal:**
- **Em dinheiro, fecha trivialmente:** R$ 3,33/mês é desprezível para uma família.
- **Em tempo, NÃO fecha:** as horas de construção não voltam como horas economizadas num horizonte razoável.
- **Logo, o projeto se justifica só por valor não monetário:** adoção pelas crianças, menos conflito, placar justo, o gosto e aprendizado do usuário em construir. Isso é legítimo, mas deve ser uma escolha consciente.
- **Variável mais sensível: escopo (horas).** Cada ideia além da Fase 1 aumenta o custo sem garantir a adoção. A forma de reduzir o risco é o faseamento abaixo: publicar a Fase 1 (~85 h), medir a adoção e só então seguir para as fases 2 e 3.

### 6.4 Faseamento do investimento (pedido do usuário; proposta do Dono para o Gestor)

Este faseamento é uma **proposta de sequência de investimento de tempo**, feita a pedido do usuário. O escopo funcional exato, os requisitos e o recorte de release são do **Gestor** (PRD.md), e as horas oficiais são do **Coordenador**. As horas abaixo são estimativas grosseiras do Dono `[PREMISSA]`.

**Regra de passagem entre fases (critério do Dono):** só começar a Fase N+1 quando a fase anterior estiver **em uso real por toda a família há pelo menos 2 semanas**. Isso protege A4 e R-P7.

#### Fase 1: MVP (~85 h, teto de ~90 h)

| Bloco | Ideias | Horas `[PREMISSA]` |
|---|---|---|
| Base do projeto: domínio definitivo (R-P3), PWA instalável, deploy | — | ~10 h |
| Família: adultos (com login) e crianças (apelido e avatar) | — | ~15 h |
| Vínculo do celular de cada criança à família, sem conta para a criança (forma a decidir pelo Gestor, G-1) | — | ~8 h |
| Tarefas com periodicidade básica (por exemplo diária, semanal ou dias da semana; o recorte exato é do Gestor), com atribuição manual | — | ~15 h |
| Ocorrências: concluir, pular/cancelar com regras, "Atrasada" até concluir ou pular, próxima ocorrência gerada mesmo assim. Crédito para quem concluiu | **I1, I3** | ~12 h |
| % do período, com o período fechado congelado | **I2** | ~10 h |
| Painel com linguagem neutra | **I6** | ~5 h |
| Instalação e teste em todos os aparelhos da família, ajustes | — | ~10 h |
| **Total** | | **~85 h** |

**Por que I1, I2, I3 e I6 estão na Fase 1:** juntas, elas definem um **placar justo e não acusatório**, que é a proposta de valor (Seção 1) e o motor de A1.
- **I1** é o caso original do stakeholder ("não tinha roupa para pendurar"). Sem ela, o % pune quem não teve o que fazer, e a criança deixa de confiar no placar.
- **I3** sem crédito para quem concluiu, ajudar um irmão não conta, e o incentivo à colaboração some.
- **I2** se o % muda depois de a semana fechar, o número vira motivo de discussão.
- **I6** custa pouco (~5 h) e protege diretamente a adesão das crianças.

O custo marginal das quatro é baixo (~27 h), porque elas mexem no mesmo núcleo de ocorrência e cálculo. Deixá-las para depois obrigaria a refazer esse núcleo.

#### Fase 2: justiça refinada e menos trabalho do administrador (~25 h)

| Bloco | Ideias | Horas `[PREMISSA]` |
|---|---|---|
| Peso de esforço de 1 a 3 por tarefa, ponderando o % | **I5** | ~7 h |
| Rodízio automático entre membros | **I4** | ~9 h |
| Recorrência "N dias depois da última conclusão" | **I4** | ~7 h |
| Ajustes | — | ~2 h |
| **Total** | | **~25 h** |

**Por que I5 e I4 ficam na Fase 2:**
- **I5:** o % sem peso já funciona na Fase 1. O peso só gera valor depois que a família perceber que algumas tarefas "valem mais", e essa percepção é melhor observada no uso real que adivinhada. Interação com I2, ponto para o Gestor: quando o peso entrar, os períodos já fechados **não** são recalculados.
- **I4:** o rodízio poupa o administrador (A2), mas a atribuição manual funciona no MVP para uma família pequena. A recorrência relativa exige outra lógica de geração de ocorrências. Adiá-la mantém a Fase 1 dentro do teto e evita a super-engenharia (R-P7).

#### Fase 3: lembretes (~32 h)

| Bloco | Ideias | Horas `[PREMISSA]` |
|---|---|---|
| Push: inscrição por aparelho, pedido de permissão por gesto (iOS), agendamento no servidor | **I8** | ~18 h |
| Horário de silêncio (22h às 07h) e no máximo um aviso de atraso agrupado por dia | **I8** | ~8 h |
| Testes em iOS e Android | — | ~6 h |
| **Total** | | **~32 h** |

**Por que I8 fica na Fase 3:** é o bloco **mais caro e de maior risco de plataforma** (R-P1, R-P3, R-P4). Também é o único que traz dependência de agendamento no servidor. Colocá-lo no MVP estouraria o teto de ~90 h. A Fase 1 testa primeiro se o placar sozinho, visível no celular de cada um, sustenta o hábito.

**Gatilho de reordenação (recomendação do Dono):** se nas semanas 2 e 3 da Fase 1 as crianças **esquecem** de marcar, mas marcam quando lembradas (A1 falhando por esquecimento, não por desinteresse), **inverter as fases 2 e 3**. Nesse caso o lembrete vale mais para a adoção que o peso ou o rodízio.

#### Dormente

| Ideia | Situação |
|---|---|
| **I7**: corte do plano grátis (o grátis nunca mostra a divisão por pessoa) | Fora de qualquer fase. Só se aplica se um dia comercializar (Anexo A). Não foi descartada |

---

## 7. Premissas e Riscos Comerciais em Aberto

### 7.1 Premissas de adoção (espelho da Seção 5)

| ID | Premissa | O que validar | Como e quem |
|---|---|---|---|
| A1 | As crianças (~7+, cada uma com celular próprio) engajam além da novidade e marcam sozinhas | Marcações por membro nas semanas 1 a 3 da Fase 1 | Usuário mede no uso real. O pré-teste com papel é opcional. Esquecimento aciona o gatilho de reordenação (Seção 6.4) |
| A2 | O adulto administrador não abandona o cadastro | Cadastro em ≤ 15 min; ajustes semanais baixos | Medir na Fase 1 (usuário) |
| A3 | Menos atrito que o papel (≤ 10 s para marcar; sessão própria e persistente no celular de cada um) | Fluxo "abrir → marcar" cronometrado em cada aparelho | Gestor (requisito) + usuário (medição) |
| A4 | Fase 1 em uso real em ≤ 8 semanas e ≤ ~90 h | Escopo da Fase 1 congelado, com data-limite | **Gestor** (escopo) + Coordenador (estimativa) |
| A5 | Instalação, sessão e armazenamento funcionam em todos os aparelhos (todos recentes, iOS 16.4+) | Teste em todos os aparelhos na primeira semana da Fase 1 | Usuário |
| C1 | Custo-alvo ≈ R$ 3,33/mês (teto de referência ≤ R$ 10/mês) com free tiers | Limites e comportamento de pausa dos free tiers escolhidos | **Coordenador** (stack; não é decisão do Dono) |
| C2 | Estimativas de Fase 1 ~85 h, Fase 2 ~25 h, Fase 3 ~32 h | Estimativa técnica real | **Coordenador** (`effort-estimation`) |
| — | Respostas do usuário que viraram premissas confirmadas: crianças com idade para usar sozinhas (genérico, sem números); cada criança com celular próprio; aparelhos recentes com iOS 16.4+ | — | Confirmado pelo usuário na rodada 3 |

### 7.2 Riscos e restrições do contexto PWA + filhos (para o Gestor considerar)

| ID | Risco / restrição | Impacto | O que precisa ser validado/decidido | Fonte |
|---|---|---|---|---|
| R-P1 | **Push no iOS só com o app instalado na Tela de Início e no iOS/iPadOS 16.4+**. A permissão exige gesto do usuário | **Mitigado:** todos os aparelhos são recentes e têm iOS 16.4+ (usuário). Resta garantir a instalação na Tela de Início e o pedido de permissão por gesto, ambos na Fase 3 | Fluxo de pedido de permissão (Gestor/Coordenador, Fase 3) | [WebKit](https://webkit.org/?p=13878) |
| R-P2 | **Instalação manual no iPhone** (Safari → Compartilhar → Adicionar à Tela de Início). Criança ou adulto pouco técnico pode não conseguir sozinho | Médio (A3) | O usuário instala pessoalmente em cada aparelho? Há instruções no app? | `[PREMISSA]` |
| R-P3 | **O domínio é definitivo:** instalação, IndexedDB e inscrição de push ficam presos à origem. Trocar de domínio depois obriga a reinstalar em todos os aparelhos e perde os dados locais e as inscrições | Alto (irreversível) | Escolher e registrar o domínio **antes** da primeira instalação real | Informado pelo usuário/coordenador. Comportamento padrão de origem web `[NÃO VERIFICADO nesta rodada]` |
| R-P4 | **Login duas vezes no iOS:** Safari e app instalado não compartilham a sessão | Médio (A3) | Fluxo de login pensado para isso (Gestor/Coordenador) | Informado pelo usuário/coordenador `[NÃO VERIFICADO nesta rodada]` |
| R-P5 | **Possível perda do armazenamento local no iOS** (o sistema pode limpar dados de sites e web apps) | Médio a alto se o dado viver só no aparelho | O dado da família não pode depender só do armazenamento local (Coordenador) | Informado pelo usuário/coordenador. A política exata de remoção do WebKit não foi verificada nesta rodada |
| R-P6 | **Dados de menores, mesmo em uso privado:** LGPD art. 14 (dados de crianças e adolescentes no melhor interesse, com consentimento de um dos pais para crianças) e **ECA Digital (Lei 15.211/2025, em vigor desde 17/03/2026)**. Diretriz: **minimizar** (apelido e avatar, **sem conta para a criança**, sem e-mail, foto ou data de nascimento) | Médio: o risco jurídico é baixo em uso estritamente familiar e privado, mas cresce muito se um dia virar produto (Anexo A) | O Gestor registra a minimização como requisito. Se comercializar, refazer a análise | [Machado Meyer: ECA Digital em vigor em 17/03/2026](https://www.machadomeyer.com.br/pt/inteligencia-juridica/publicacoes-ij/direito-digital/estatuto-digital-da-crianca-e-do-adolescente-lei-n-15-211-2025-entra-em-vigor-em-17-de-marco-de-2026); [Mattos Filho](https://www.mattosfilho.com.br/unico/eca-digital-sancionada-lei/). LGPD art. 14 citado pelo usuário/coordenador. O texto não foi relido nesta rodada |
| G-1 | **Questão em aberto para o Gestor, sem decisão do Dono:** há uma tensão entre "cada criança tem sessão própria no próprio celular" (Q-F2) e R-P6 ("sem conta para a criança, só apelido e avatar"). Exemplo de caminho possível, não uma decisão: vínculo do aparelho por convite ou QR gerado pelo adulto, sem e-mail nem conta Google da criança | Alto para A3 e R-P6 (afeta a Fase 1, ~8 h reservadas) | Como a sessão da criança é criada, mantida e revogada sem identificador pessoal | Gestor (requisito) + Coordenador (solução) |
| R-P7 | **Risco de super-engenharia:** o projeto anterior morreu com 455 tarefas e nunca foi publicado | **Crítico** (A4). **Mitigação proposta:** faseamento (Seção 6.4), com a Fase 1 em ~85 h e a regra de só passar de fase depois de 2 semanas de uso real | O Gestor congela o escopo da Fase 1 com data-limite | Histórico informado pelo usuário |
| R-P8 | **Free tier com pausa por inatividade** (ex.: Supabase pausa depois de 7 dias de baixa atividade). Férias da família podem pausar o back-end | Baixo a médio | Coordenador escolhe uma stack sem pausa ou com reativação automática, ou aceita pagar caso o custo-alvo permita | [Supabase docs](https://supabase.com/docs/guides/platform/free-project-pausing) |
| ~~R-P9~~ | ~~Crianças sem celular próprio~~ | **Resolvido na rodada 3:** cada criança tem celular próprio (Q-F2). A consequência foi para G-1 | — | Usuário |

### 7.3 Perguntas ao usuário

As 6 perguntas da rodada 2 foram respondidas na rodada 3:

| Pergunta | Resposta | Efeito no plano |
|---|---|---|
| Q-F1: filhos e idades | "Ok", lido como "idade para usar sozinhos (~7+)" | Premissa confirmada de forma genérica; critério de sucesso mantido |
| Q-F2: acesso das crianças | Celular próprio | R-P9 resolvido; A1 e A3 sobem; G-1 aberto para o Gestor |
| Q-F3: aparelhos | Recentes, iOS 16.4+ | R-P1 mitigado; A5 sobe para ~80% |
| Q-F4: pré-teste | Indiferente | Pré-teste opcional e fora do percentual |
| Q-F5: critério e teto | Indiferente | Mantidos como referência |
| Q-F6: fases | Dividir em fases, MVP na Fase 1 | Seção 6.4 criada |

**Não restam perguntas bloqueantes ao usuário.** Uma pergunta opcional, que não muda o veredito: o gatilho de reordenação (inverter as fases 2 e 3 se as crianças esquecerem de marcar) está de acordo?

---

## Anexo A: Se um dia comercializar (preservado da rodada 1, dormente)

> Nada aqui se aplica ao enquadramento atual. Está guardado para que uma eventual virada para produto não comece do zero. Se isso acontecer, é preciso **refazer** a rodada comercial completa, porque os números são da rodada 1 (2026-10-16) e envelhecem.

- **Modelo e preço:** freemium com assinatura por casa, **R$ 9,90/mês ou R$ 79,90/ano**. Âncora: Sweepy US$ 19,99/ano, Tody ~US$ 30/ano, Cozi Gold US$ 39/ano, FamilyWall US$ 44,99/ano, Homey US$ 49,99/ano. **Nipto: R$ 69,90/ano.** Fonte: `PLANO-COMERCIAL.md` do projeto antigo (`C:\Leandro\Projetos\TarefasEmCasa_bkp`, Seção 4.1). Não veio do usuário, como a rodada 2 afirmou por engano. É um dado de segunda mão, sem data de coleta conhecida, e não foi reverificado pelo Dono nesta análise. A App Store confirma o modelo freemium com compras no app, a listagem indica disponibilidade só para iPhone, e a origem brasileira também não foi verificada ([App Store: Nipto](https://apps.apple.com/us/app/id1504877473); [Croma review](https://croma.com/unboxed/nipto-app-review)). Com o Nipto como âncora local, R$ 79,90 fica **acima** do concorrente mais próximo, e o preço precisaria ser revisto (ex.: ≤ R$ 59,90/ano).
- **I7 (corte do grátis):** o plano grátis nunca mostra a divisão por pessoa. É a alavanca de conversão já desenhada pelo usuário.
- **ICP:** quem carrega a carga mental da casa, tipicamente mulher de 28 a 45 anos, classes B/C, Android, em casa urbana com 3 ou mais moradores. TAM de ~77,3 mi de domicílios (IBGE/PNAD 2024), SAM de ~3,5 a 4 mi, SOM em 24 meses de 500 a 1.500 casas pagantes.
- **Canal:** Google Play via **TWA**, com **Google Play Billing obrigatório e 15% de comissão** ([Chrome TWA billing](https://developer.chrome.com/docs/android/trusted-web-activity/billing); [AppleInsider](https://appleinsider.com/articles/21/10/21/google-play-drops-all-subscription-commissions-to-15-from-day-one)). Taxa de cadastro de US$ 25. Mídia paga inviável: CAC ~R$ 175 contra LTV ~R$ 84.
- **Break-even (rodada 1):**
  - Cenário projeto paralelo: **~120 casas pagantes** até o mês 24.
  - Cenário negócio: **~970 casas pagantes** (~48,5 mil downloads).
  - Receita líquida de ~R$ 6/casa/mês.
  - **Ajuste da rodada 2: contador de ~R$ 300/mês, necessário se houver cobrança.** Na rodada 1 a conta usou R$ 200. Com R$ 300, o caixa mensal sobe para R$ 450 e o cenário projeto paralelo passa de ~120 para **~155 casas pagantes** no mês 24 (R$ 335 + 24 × R$ 450 = R$ 11.135; ÷ R$ 6 ≈ 1.856 casa-meses; ÷ 12 ≈ 155).
- **Concorrentes mapeados:** Sweepy, Tody, OurHome (grátis), Homey, Cozi, FamilyWall, Nipto, apps infantis (NeatKid, GoKids, BrightSteps), além dos substitutos WhatsApp, papel e Keep/To Do.
- **Pergunta crítica antes de qualquer virada comercial:** **"Se 5 ou mais apps já existem, por que nenhum tem tração?"** Hipóteses a investigar, não verificadas:
  - famílias não pagam por isso, porque o papel e o WhatsApp bastam;
  - o engajamento decai depois da novidade, o mesmo risco de A1 e A2;
  - as crianças perdem o interesse;
  - a categoria é fragmentada e de baixo valor percebido.

  A resposta a essa pergunta vale mais que qualquer número deste anexo. Os dados de adoção desta família (Seção 5) seriam a primeira evidência real.
- **Dados de menores:** se comercializar, o ECA Digital (em vigor desde 17/03/2026) passa a impor deveres de verificação etária e supervisão parental a serviços com acesso provável por crianças. É preciso reanálise jurídica (R-P6).
- **Riscos herdados da rodada 1:** P1 a P5 e R1 a R9 da versão anterior deste arquivo (histórico no git).

---

## Critérios de Pronto (dono.md), ajustados ao enquadramento de uso familiar

- [x] **Proposta de valor em uma frase:** atendido (Seção 1, para a família). Modelo de receita e preço: **N/A (uso familiar)**, porque não há cobrança. A hipótese da rodada 1 está guardada no Anexo A
- [x] **Público-alvo nomeado:** atendido na forma adaptada (a própria família, por papel: administrador, adultos, crianças). Tamanho de mercado e disposição a pagar: **N/A (uso familiar)**, guardados no Anexo A
- [x] **Canais listados com canal principal justificado:** atendido (PWA, por decisão do usuário, com as restrições de iOS). Custo de aquisição: **N/A (uso familiar)**
- [x] **Concorrentes com preço, diferencial e fonte:** atendido. As alternativas gratuitas que a família usaria estão na Seção 4, e os concorrentes comerciais no Anexo A, com fonte ou marca de não verificado. O preço do Nipto vem do plano do projeto antigo, é de segunda mão e não foi reverificado
- [x] **Percentual com premissas e o que derruba cada uma:** atendido, com o percentual substituído por adoção por 3 meses ou mais (**~35%**, sem ganho de pré-teste) e as premissas A1 a A5 atualizadas
- [x] **Conta de break-even fechada:** atendido como break-even de custo pessoal (R$ 3,33/mês contra R$ 0; payback em tempo de ~3,0 anos para a Fase 1 e ~5,1 anos para as fases 1 a 3, na hipótese mais otimista). Número de vendas: **N/A (uso familiar)**, guardado no Anexo A
- [x] **Toda premissa e risco com o que validar na Seção 7:** atendido (A1 a A5, C1, C2, G-1, R-P1 a R-P8; R-P9 resolvido)
- [x] **Se a conta não fecha, dito explicitamente com o que mudar:** atendido. Em tempo puro a conta **não fecha** (Seção 6.3), e a alavanca é o escopo, endereçado pelo faseamento (Seção 6.4)
