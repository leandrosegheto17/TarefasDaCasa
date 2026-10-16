# ADR-001: Um monólito único serve a API e o PWA na mesma origem, com o código em `backend/` e `frontend/` e um pacote de contrato próprio

- **Status:** Aceito (o usuário aprovou o B1 do Loop B em 2026-10-16)
- **Data:** 2026-10-16
- **Decisor:** Coordenador (chapéu Software Architect)
- **Requisitos ligados:** RNF-04, RNF-05, RNF-09, RNF-16, R-P4, R-P7; RF-01 a RF-26

## Contexto

- Uma família, de 4 a 6 pessoas, e um único desenvolvedor com ~85 h para a Fase 1 (RNF-16). O projeto anterior morreu de super-engenharia (R-P7).
- O volume é mínimo: dezenas de requisições por dia, alguns milhares de ocorrências por ano.
- A sessão do aparelho vive num cookie (ADR-004). No iOS, o Safari 16.4+ limita a 7 dias os cookies gravados por um servidor de **outro subdomínio** cujo IP não bate com o do site, e a sessão do app instalado já é isolada da sessão do Safari (R-P4). Página e API na **mesma origem** evitam as duas armadilhas e dispensam CORS.
- As regras de negócio (RN-01 a RN-21) são o coração do produto e precisam rodar num lugar só, o servidor (RNF-04).

## Decisão

1. **Um único deploy** entrega o PWA estático e a API HTTP sob a mesma origem (`https://<dominio>/` e `https://<dominio>/api/...`).
2. **Monólito modular** com três pacotes npm (workspaces):
   - `backend/contrato`: esquemas e tipos de requisição e resposta da API. Sem dependência de Node nem de banco.
   - `backend/api`: o servidor (domínio, casos de uso, rotas, acesso a dados).
   - `frontend`: o PWA. Depende só de `backend/contrato`, nunca de `backend/api`.
3. **A regra de negócio roda só no servidor.** A API devolve dados prontos para exibir (percentual já truncado, `podePular`, `podeDesfazer`, dias de atraso). A tela não recalcula regra.
4. Sem filas, sem workers, sem cache distribuído, sem WebSocket. Tudo é requisição e resposta.

## Consequências

**Positivas**
- Um deploy, um repositório, um lugar para depurar.
- Cookie host-only na mesma origem: sem CORS, sem limite de 7 dias por servidor de terceiro, CSRF simples (ADR-004).
- O pacote `contrato` impede que a tela e a API divirjam no formato dos dados, e a fronteira é garantida pela dependência, não por lint.

**Negativas**
- Front e API são publicados juntos. Um PWA antigo em cache pode falar com uma API nova. Mitigação: a API devolve a versão no cabeçalho e o app recarrega quando ela muda (SDD §6).
- A atualização da tela fica a cargo do usuário recarregar ou reabrir (sem tempo real entre aparelhos). Aceito: RF-18 pede reflexo "na próxima vez que a tela for exibida ou atualizada".

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Front e API em subdomínios separados | CORS, cookie cross-site e o limite de 7 dias do Safari para cookie de servidor com IP diferente. Nenhum ganho para uma família |
| BaaS (Supabase, Firebase) com regra no cliente ou em políticas | Supabase Free pausa (R-P8, descartado). Firebase traz SDK de terceiro (RNF-08) e espalha regra entre cliente e regras de segurança |
| Serviços separados (auth, tarefas, placar) | Custo operacional sem nenhum requisito que justifique |
