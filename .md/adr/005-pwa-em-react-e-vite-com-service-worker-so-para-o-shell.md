# ADR-005: O PWA é React + Vite, com um service worker que guarda só o "shell" do app e nunca dados nem marcações

- **Status:** Aceito (o usuário aprovou o B1 do Loop B em 2026-10-16)
- **Data:** 2026-10-16
- **Decisor:** Coordenador (chapéu Software Architect)
- **Requisitos ligados:** RF-23, RF-24, RNF-01, RNF-02, RNF-08, RNF-10, RNF-11, RNF-12; D-04, R-P5; ADR-001

## Contexto

- Distribuição só por PWA (sem TWA): Safari iOS 16.4+ instalado na Tela de Início e Chrome Android (RNF-01). Telas do Responsável também no navegador do computador.
- D-04: marcar exige conexão. Sem rede, o app abre e diz "Sem conexão" em vez de mostrar a página de erro do navegador (RNF-10).
- RNF-08: nenhum SDK, analytics, fonte ou recurso de terceiro.
- O usuário já trabalhou com React + Vite no projeto anterior. Familiaridade reduz risco num orçamento de ~85 h.

## Decisão

1. **React 19 + TypeScript + Vite**, como SPA estática. Roteamento no cliente com React Router (modo declarativo, sem carregadores de dados).
2. **Sem biblioteca de estado global.** Um cliente HTTP fino (`api.ts`) com os tipos do pacote `contrato`, e um gancho de leitura que busca de novo quando o app volta ao primeiro plano (`visibilitychange`). Isso cumpre o CA-18.2 sem tempo real.
3. **`vite-plugin-pwa`** gera o manifest e um service worker Workbox:
   - **pré-cache só do shell** (HTML, JS, CSS, ícones, avatares e fontes do próprio app);
   - chamadas `/api/*` em **network-only**, sem cache. Se falhar, a tela mostra o estado "Sem conexão" (UX-SPEC §4);
   - atualização automática: o service worker novo assume na próxima abertura. Além disso, a API devolve o cabeçalho `X-Versao-App`, e o app recarrega uma vez quando a versão difere da sua (SDD §6, RT-05).
4. **Manifest:** `name` "Tarefas da Casa", `display: standalone`, `start_url: "/"`, `scope: "/"`, `id: "/"`, ícones de 192 e 512 px (com variante maskable) e `apple-touch-icon` de 180 px. Os caminhos são relativos, então o build não contém o domínio (ADR-006).
5. **Tudo servido da própria origem:** fontes, ícones e avatares (conjunto fixo de SVG) ficam no bundle. Content-Security-Policy restrita a `'self'`.
6. **Detecção de instalação:** `navigator.standalone` (iOS) e `matchMedia('(display-mode: standalone)')` decidem se a tela de entrada mostra o aviso "instale antes de entrar" (UX-SPEC §7).

## Consequências

**Positivas**
- Stack conhecida, build rápido, deploy estático.
- Nenhum dado de família no aparelho além do cookie de sessão. Nada se perde se o iOS apagar o armazenamento (R-P5).
- O mesmo service worker é o lugar onde entra o push da Fase 3.

**Negativas**
- Sem rede, o app abre mas não mostra a lista do dia (nada é guardado). Aceito por D-04: o servidor é a fonte da verdade e a casa tem Wi-Fi.
- React é maior que alternativas como Preact. Com o shell em cache, isso pesa só no primeiro carregamento.
- O service worker Workbox é uma camada a entender quando algo ficar "preso" em versão antiga. Mitigação: o cabeçalho de versão do item 3.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Next.js / SSR | Servidor de renderização sem requisito que peça. Mais peças e mais acoplamento à Vercel |
| Preact / Svelte | Menores, mas o usuário não tem histórico com eles. O ganho de tamanho não compensa o aprendizado no orçamento |
| Service worker escrito à mão | Menos dependência, mas é fácil errar no ciclo de atualização. O plugin resolve isso com configuração |
| Cache de dados para leitura offline | Aumenta o risco de mostrar dado velho como verdade e não é pedido (D-04) |
| TanStack Query | Útil, mas a necessidade aqui (buscar ao abrir e ao voltar ao app) cabe num gancho de ~30 linhas |
