# STATE

## Decisions

### AD-001 — Roteiro em 5 features (2026-10-27)

- **Decisão**: quebrar o escopo de [necessidade.md](produto/necessidade.md) em 5 features verticais, nesta ordem: `fundacao` → `conta-e-acesso` → `casa-e-membros` → `tarefas-e-historico` → `lembretes` (`.specs/projeto/roadmap.md`). A ordem segue a dependência: a infraestrutura destrava a conta, a conta destrava a casa, e a casa e o isolamento por `casa_id` (D-06) destravam as tarefas. Depois da feature 4 a família já consegue largar o papel; os lembretes vêm por último porque dependem das tarefas.
- **Incerteza puxada para a frente**: a `fundacao` confere quantos Cron Triggers a conta ainda tem livres (limite de 5 por conta, dividido com os outros apps LJS) e se o binding de rate limit existe no Free, antes de alguma feature depender disso.
- **Alternativa descartada**: uma feature única dividida em etapas (como no EvolucaoSegura_LJS). Foi descartada porque não tem ponto de validação e liberação no meio, e a família só usaria no fim.
- **Fora do roteiro por enquanto**: rodízio automático (D-03) e planos e cobrança (D-01). Entram como features novas, com novo AD, quando forem decididos.
