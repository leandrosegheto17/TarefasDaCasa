# TASKPLAN — ordem de execução e estado das tarefas

Gerado por `/organizar` (`python .claude/scripts/taskplan.py gerar`) e mantido pelo `/executar`,
que troca o estado da linha a cada etapa. O Status oficial continua no `TASK.md` (bloqueios `BK-`: no
arquivo do bloqueio); o detalhe de cada tarefa está em `.md/.taskplan/<ID>.md`. A ordem respeita as
dependências. Agente: `executor` (TP/RTP) ou `coordenador` (BK/SPK, com o usuário).

Atualizado: 2026-10-16 21:00

Resumo: Não executada 99 · total 99

Estados: Não executada → Em execução → Executada (aguarda teste) → Em teste → Testada (aguarda segurança) → Em validação de segurança → Aprovada (e, à parte, Bloqueada, Dividida e Despriorizada — esta fica sempre no fim da lista e é ignorada por /executar, /testar e /validar). `Aprovada` = QA ✔ e Sec ✔ (tarefas antigas só `Concluída` aparecem como Aprovada).

| # | Tarefa | Agente | Plano | Título | Lote | Dep | Estado |
|---|---|---|---|---|---|---|---|
| 1 | TP-0001 | executor | ✔ | Monorepo pnpm com os pacotes backend/contrato, backend/api e frontend | Lote 1 | — | Não executada |
| 2 | TP-0002 | executor | ✔ | CI base no GitHub Actions | Lote 1 | TP-0001 | Não executada |
| 3 | TP-0003 | executor | ✔ | Esqueleto da API: configuração, conexão, app Hono, entradas e rota mínima de situação | Lote 1 | TP-0001 | Não executada |
| 4 | TP-0004 | executor | ✔ | **Spike** RT-01/RT-02: publicação na Vercel + Neon, URL exata, 308, previews, gru1 e la... | Lote 1 | TP-0001, TP-0003 | Não executada |
| 5 | TP-0005 | executor | ✔ | Script de migração, trava de host local e guarda de migração aditiva | Lote 2 | TP-0002, TP-0003 | Não executada |
| 6 | TP-0006 | executor | ✔ | Migração 001: tabelas de família e acesso | Lote 2 | TP-0005 | Não executada |
| 7 | TP-0007 | executor | ✔ | Migração 002: tarefas e ocorrências | Lote 2 | TP-0005, TP-0006 | Não executada |
| 8 | TP-0008 | executor | ✔ | Migração 003: semanas fechadas e registro de erro | Lote 2 | TP-0005, TP-0006 | Não executada |
| 9 | TP-0009 | executor | ✔ | Infra de teste de integração: Postgres local, banco de teste, fábricas e teste de schema | Lote 2 | TP-0001, TP-0002, TP-0005, TP-0006, TP-0007, TP-0008 | Não executada |
| 10 | TP-0010 | executor | ✔ | Lint de fronteiras de camada, relógio e pacotes | Lote 2 | TP-0001, TP-0002, TP-0003 | Não executada |
| 11 | TP-0011 | executor | ✔ | dominio/relogio: hoje, semana e atraso no fuso da família | Lote 3 | TP-0001 | Não executada |
| 12 | TP-0012 | executor | ✔ | dominio/geracao: datas previstas por dias da semana | Lote 3 | TP-0011 | Não executada |
| 13 | TP-0013 | executor | ✔ | **[H11]** Estratégia semanal flexível em dominio/geracao | Lote 3 | TP-0011, TP-0012 | Não executada |
| 14 | TP-0014 | executor | ✔ | dominio/placar: cálculo do % e contagens do fechamento | Lote 3 | TP-0011 | Não executada |
| 15 | TP-0015 | executor | ✔ | dominio/estados: transições da ocorrência e desfazer | Lote 3 | TP-0011 | Não executada |
| 16 | TP-0016 | executor | ✔ | dominio/permissoes: quem pode pular, desfazer e gerenciar | Lote 3 | TP-0001 | Não executada |
| 17 | TP-0017 | executor | ✔ | Contrato base: erro, ids, enums e limites | Lote 4 | TP-0001 | Não executada |
| 18 | TP-0018 | executor | ✔ | Contrato de acesso: situação, entrada, membros, códigos e aparelhos | Lote 4 | TP-0017 | Não executada |
| 19 | TP-0019 | executor | ✔ | Contrato de rotina: tarefas, Hoje e marcação | Lote 4 | TP-0017 | Não executada |
| 20 | TP-0020 | executor | ✔ | Contrato de placar: casa, semanas, contribuições e atividade | Lote 4 | TP-0017 | Não executada |
| 21 | TP-0021 | executor | ✔ | Segredos: hash de senha, token de sessão e gerador de código | Lote 5 | TP-0001, TP-0017 | Não executada |
| 22 | TP-0022 | executor | ✔ | Middleware de borda: cabeçalhos, CSRF, 308 por host, versão e tratador de erro | Lote 5 | TP-0003, TP-0004, TP-0008, TP-0009, TP-0017 | Não executada |
| 23 | TP-0023 | executor | ✔ | Middleware de sessão de aparelho | Lote 5 | TP-0003, TP-0006, TP-0009, TP-0017, TP-0021 | Não executada |
| 24 | TP-0024 | executor | ✔ | Caso de uso compartilhado criarSessaoAparelho | Lote 5 | TP-0021, TP-0023 | Não executada |
| 25 | TP-0025 | executor | ✔ | Limite de tentativas por e-mail, aparelho e IP | Lote 5 | TP-0006, TP-0009, TP-0011 | Não executada |
| 26 | TP-0026 | executor | ✔ | Módulo de dados dos códigos de vínculo | Lote 5 | TP-0006, TP-0009, TP-0021 | Não executada |
| 27 | TP-0027 | executor | ✔ | Endpoint GET /api/situacao completo | Lote 6 | TP-0003, TP-0006, TP-0018, TP-0023 | Não executada |
| 28 | TP-0028 | executor | ✔ | Endpoint POST /api/familia | Lote 6 | TP-0003, TP-0009, TP-0018, TP-0021, TP-0022, TP-0024, TP-0027 | Não executada |
| 29 | TP-0029 | executor | ✔ | Endpoint POST /api/entrar/email | Lote 6 | TP-0018, TP-0021, TP-0024, TP-0025, TP-0028 | Não executada |
| 30 | TP-0030 | executor | ✔ | Endpoint POST /api/entrar/codigo | Lote 6 | TP-0018, TP-0024, TP-0025, TP-0026 | Não executada |
| 31 | TP-0031 | executor | ✔ | Endpoint POST /api/entrar/codigo/credenciais | Lote 6 | TP-0018, TP-0021, TP-0023, TP-0028 | Não executada |
| 32 | TP-0032 | executor | ✔ | Endpoint POST /api/sair | Lote 6 | TP-0023 | Não executada |
| 33 | TP-0033 | executor | ✔ | Módulo de dados de tarefas e ocorrências | Lote 7 | TP-0007, TP-0009 | Não executada |
| 34 | TP-0034 | executor | ✔ | Caso de uso compartilhado gerarOcorrencias | Lote 7 | TP-0012, TP-0033 | Não executada |
| 35 | TP-0035 | executor | ✔ | garantirEmDia: gerar ocorrências e fechar semanas sob demanda | Lote 7 | TP-0003, TP-0008, TP-0011, TP-0014, TP-0023, TP-0027, TP-0033, TP-0034 | Não executada |
| 36 | TP-0036 | executor | ✔ | Retenção diária dentro do garantirEmDia | Lote 7 | TP-0022, TP-0025, TP-0026, TP-0035 | Não executada |
| 37 | TP-0037 | executor | ✔ | Caso de uso compartilhado percentualParcial | Lote 7 | TP-0011, TP-0014, TP-0033 | Não executada |
| 38 | TP-0038 | executor | ✔ | Caso de uso compartilhado montarHoje | Lote 7 | TP-0011, TP-0015, TP-0016, TP-0019, TP-0033, TP-0037 | Não executada |
| 39 | TP-0039 | executor | ✔ | Endpoint GET /api/tarefas | Lote 8 | TP-0016, TP-0019, TP-0023, TP-0033 | Não executada |
| 40 | TP-0040 | executor | ✔ | Endpoint POST /api/tarefas | Lote 8 | TP-0016, TP-0019, TP-0023, TP-0033, TP-0034 | Não executada |
| 41 | TP-0041 | executor | ✔ | Endpoint PATCH /api/tarefas/{id} (edição, RN-14) | Lote 8 | TP-0003, TP-0016, TP-0019, TP-0023, TP-0033, TP-0034 | Não executada |
| 42 | TP-0042 | executor | ✔ | Endpoint POST /api/tarefas/{id}/arquivar (RN-15) | Lote 8 | TP-0003, TP-0016, TP-0019, TP-0023, TP-0033 | Não executada |
| 43 | TP-0043 | executor | ✔ | Endpoint POST /api/tarefas/{id}/reativar | Lote 8 | TP-0016, TP-0023, TP-0033, TP-0034 | Não executada |
| 44 | TP-0044 | executor | ✔ | Endpoint GET /api/membros | Lote 9 | TP-0016, TP-0018, TP-0023, TP-0028 | Não executada |
| 45 | TP-0045 | executor | ✔ | Endpoint POST /api/membros (Criança ou adulto) | Lote 9 | TP-0016, TP-0018, TP-0023, TP-0028 | Não executada |
| 46 | TP-0046 | executor | ✔ | Endpoint PATCH /api/membros/{id} | Lote 9 | TP-0016, TP-0018, TP-0023, TP-0028 | Não executada |
| 47 | TP-0047 | executor | ✔ | Endpoint DELETE /api/membros/{id} (RN-16) | Lote 9 | TP-0003, TP-0016, TP-0023, TP-0028, TP-0033 | Não executada |
| 48 | TP-0048 | executor | ✔ | Endpoint POST /api/membros/{id}/codigos | Lote 10 | TP-0016, TP-0018, TP-0021, TP-0023, TP-0026, TP-0028 | Não executada |
| 49 | TP-0049 | executor | ✔ | Endpoint GET /api/membros/{id}/aparelhos | Lote 10 | TP-0016, TP-0018, TP-0023 | Não executada |
| 50 | TP-0050 | executor | ✔ | Endpoint DELETE /api/aparelhos/{id} | Lote 10 | TP-0016, TP-0023 | Não executada |
| 51 | TP-0051 | executor | ✔ | Endpoint POST /api/erros (relato do PWA) | Lote 10 | TP-0017, TP-0022, TP-0023, TP-0025 | Não executada |
| 52 | TP-0052 | executor | ✔ | Endpoint GET /api/hoje | Lote 11 | TP-0023, TP-0035, TP-0038 | Não executada |
| 53 | TP-0053 | executor | ✔ | Endpoint POST /api/ocorrencias/{id}/concluir | Lote 11 | TP-0015, TP-0019, TP-0023, TP-0033, TP-0035, TP-0038 | Não executada |
| 54 | TP-0054 | executor | ✔ | **[Could]** "Feito por…": creditoMembroId no concluir (RF-25) | Lote 11 | TP-0016, TP-0028, TP-0053 | Não executada |
| 55 | TP-0055 | executor | ✔ | Endpoint POST /api/ocorrencias/{id}/pular | Lote 11 | TP-0015, TP-0016, TP-0019, TP-0023, TP-0033, TP-0035, TP-0038 | Não executada |
| 56 | TP-0056 | executor | ✔ | **[H10]** Endpoint POST /api/ocorrencias/{id}/desfazer | Lote 11 | TP-0015, TP-0016, TP-0023, TP-0033, TP-0035, TP-0038 | Não executada |
| 57 | TP-0057 | executor | ✔ | **[H12]** Endpoint POST /api/tarefas/{id}/pendencias-antigas/pular | Lote 11 | TP-0003, TP-0016, TP-0023, TP-0033, TP-0038 | Não executada |
| 58 | TP-0058 | executor | ✔ | Endpoint GET /api/casa | Lote 12 | TP-0020, TP-0023, TP-0033, TP-0035, TP-0037 | Não executada |
| 59 | TP-0059 | executor | ✔ | **[H13]** Endpoint GET /api/semanas | Lote 12 | TP-0020, TP-0023, TP-0035 | Não executada |
| 60 | TP-0060 | executor | ✔ | Endpoint GET /api/eu/contribuicoes | Lote 12 | TP-0011, TP-0020, TP-0023, TP-0033 | Não executada |
| 61 | TP-0061 | executor | ✔ | **[H9]** Endpoint GET /api/atividade | Lote 12 | TP-0011, TP-0016, TP-0020, TP-0023, TP-0028, TP-0033 | Não executada |
| 62 | TP-0062 | executor | ✔ | Base visual: tokens, estilos, fontes, avatares e comparação visual rodando | Lote 13 | TP-0001 | Não executada |
| 63 | TP-0063 | executor | ✔ | Cliente HTTP tipado e ganchos de dados | Lote 13 | TP-0001, TP-0018, TP-0019, TP-0020 | Não executada |
| 64 | TP-0064 | executor | ✔ | Textos pt-BR e formatação de datas e rótulos de tempo | Lote 13 | TP-0001 | Não executada |
| 65 | TP-0065 | executor | ✔ | PWA instalável: manifest, service worker do shell e detecção de plataforma | Lote 13 | TP-0001, TP-0017, TP-0062 | Não executada |
| 66 | TP-0066 | executor | ✔ | Componentes de estado, aviso e avatar | Lote 14 | TP-0062, TP-0064 | Não executada |
| 67 | TP-0067 | executor | ✔ | Componentes de formulário e diálogo | Lote 14 | TP-0062, TP-0064 | Não executada |
| 68 | TP-0068 | executor | ✔ | Componentes de painel: botão grande, cartão de número, link com seta, lista de semanas... | Lote 14 | TP-0062, TP-0064, TP-0066 | Não executada |
| 69 | TP-0069 | executor | ✔ | Componentes de gestão: linha de lista, seletor de membro e zona de perigo | Lote 14 | TP-0062, TP-0064, TP-0066 | Não executada |
| 70 | TP-0070 | executor | ✔ | Shell do app: rotas, guarda de sessão, navegação, cabeçalho e faixa de ambiente de teste | Lote 14 | TP-0062, TP-0063, TP-0064, TP-0065, TP-0066 | Não executada |
| 71 | TP-0071 | executor | ✔ | Guardas de CI do front: palavras proibidas, bundle sem domínio externo e comparação visual | Lote 14 | TP-0002, TP-0062, TP-0064, TP-0065 | Não executada |
| 72 | TP-0072 | executor | ✔ | Tela T01 Entrada (com G2 e aviso de instalação) | Lote 15 | TP-0062, TP-0063, TP-0064, TP-0065, TP-0066, TP-0067, TP-0068, TP-0070 | Não executada |
| 73 | TP-0073 | executor | ✔ | Tela T02 Criar família | Lote 15 | TP-0062, TP-0063, TP-0064, TP-0067, TP-0070 | Não executada |
| 74 | TP-0074 | executor | ✔ | Tela T03 Entrar com e-mail | Lote 15 | TP-0062, TP-0063, TP-0064, TP-0067, TP-0070 | Não executada |
| 75 | TP-0075 | executor | ✔ | Tela T04 Entrar com código | Lote 15 | TP-0062, TP-0063, TP-0064, TP-0067, TP-0070 | Não executada |
| 76 | TP-0076 | executor | ✔ | Tela T05 Criar acesso do adulto | Lote 15 | TP-0062, TP-0063, TP-0064, TP-0067, TP-0068, TP-0070 | Não executada |
| 77 | TP-0077 | executor | ✔ | Tela T06 Hoje: exibição e estados | Lote 16 | TP-0062, TP-0063, TP-0064, TP-0066, TP-0067, TP-0070 | Não executada |
| 78 | TP-0078 | executor | ✔ | Ação "Feito" no Hoje | Lote 16 | TP-0063, TP-0066, TP-0077 | Não executada |
| 79 | TP-0079 | executor | ✔ | **[H10]** Ação "Desfazer" no Hoje | Lote 16 | TP-0063, TP-0066, TP-0077 | Não executada |
| 80 | TP-0080 | executor | ✔ | **[H12]** Pendências de semanas anteriores no Hoje | Lote 16 | TP-0062, TP-0063, TP-0066, TP-0067, TP-0077, TP-0078 | Não executada |
| 81 | TP-0081 | executor | ✔ | Tela T07 Opções da ocorrência ("Não precisou") | Lote 16 | TP-0062, TP-0063, TP-0066, TP-0067, TP-0077 | Não executada |
| 82 | TP-0082 | executor | ✔ | **[Could]** "Feito por…" na T07 | Lote 16 | TP-0062, TP-0069, TP-0078, TP-0081 | Não executada |
| 83 | TP-0083 | executor | ✔ | Tela T08 Casa | Lote 17 | TP-0062, TP-0063, TP-0064, TP-0066, TP-0068, TP-0070 | Não executada |
| 84 | TP-0084 | executor | ✔ | **[H13]** Tela T09 Semanas anteriores | Lote 17 | TP-0062, TP-0063, TP-0064, TP-0066, TP-0068, TP-0070 | Não executada |
| 85 | TP-0085 | executor | ✔ | Tela T10 Eu (contribuições e sair) | Lote 17 | TP-0062, TP-0063, TP-0064, TP-0065, TP-0066, TP-0067, TP-0068, TP-0070 | Não executada |
| 86 | TP-0086 | executor | ✔ | **[Could]** Tela T18 Como instalar | Lote 17 | TP-0062, TP-0064, TP-0065, TP-0066, TP-0067, TP-0070 | Não executada |
| 87 | TP-0087 | executor | ✔ | Tela T11 Gerenciar | Lote 18 | TP-0062, TP-0063, TP-0066, TP-0068, TP-0070 | Não executada |
| 88 | TP-0088 | executor | ✔ | Tela T12 Tarefas (ativas e arquivadas) | Lote 18 | TP-0062, TP-0063, TP-0066, TP-0067, TP-0069, TP-0070 | Não executada |
| 89 | TP-0089 | executor | ✔ | Tela T13 Tarefa (criar, editar e arquivar) | Lote 18 | TP-0062, TP-0063, TP-0066, TP-0067, TP-0069, TP-0070 | Não executada |
| 90 | TP-0090 | executor | ✔ | Tela T14 Família | Lote 19 | TP-0062, TP-0063, TP-0066, TP-0067, TP-0069, TP-0070 | Não executada |
| 91 | TP-0091 | executor | ✔ | Tela T15 Membro: criar e editar | Lote 19 | TP-0062, TP-0063, TP-0066, TP-0067, TP-0070 | Não executada |
| 92 | TP-0092 | executor | ✔ | Tela T15 Membro: aparelhos, revogar e remover | Lote 19 | TP-0062, TP-0063, TP-0064, TP-0066, TP-0067, TP-0069, TP-0091 | Não executada |
| 93 | TP-0093 | executor | ✔ | Tela T16 Código de vínculo | Lote 19 | TP-0062, TP-0063, TP-0064, TP-0066, TP-0067, TP-0070 | Não executada |
| 94 | TP-0094 | executor | ✔ | **[H9]** Tela T17 Atividade da família | Lote 19 | TP-0062, TP-0063, TP-0064, TP-0066, TP-0067, TP-0068, TP-0070 | Não executada |
| 95 | TP-0095 | executor | ✔ | Script redefinir-senha (F6) | Lote 20 | TP-0005, TP-0021, TP-0028 | Não executada |
| 96 | TP-0096 | executor | ✔ | Backup diário criptografado e restauração ensaiada (sessão [U] no GitHub) | Lote 20 | TP-0004 | Não executada |
| 97 | TP-0097 | executor | ✔ | Publicação de produção: conferência de ambiente e workflow de deploy com migração | Lote 20 | TP-0003, TP-0004, TP-0005, TP-0096 | Não executada |
| 98 | TP-0098 | executor | ✔ | Testes ponta a ponta (Playwright): vincular, marcar e desfazer | Lote 20 | TP-0003, TP-0009, TP-0030, TP-0048, TP-0053, TP-0056, TP-0062, TP-0075, TP-0078, TP-0079, TP-0093 | Não executada |
| 99 | TP-0099 | executor | ✔ | Instalação real em todos os aparelhos da família (B8, sessão [U] com o usuário) | Lote 20 | TP-0013, TP-0027, TP-0028, TP-0029, TP-0031, TP-0032, TP-0036, TP-0039, TP-0040, TP-0041, TP-0042, TP-0043, TP-0044, TP-0045, TP-0046, TP-0047, TP-0049, TP-0050, TP-0051, TP-0052, TP-0054, TP-0055, TP-0057, TP-0058, TP-0059, TP-0060, TP-0061, TP-0065, TP-0071, TP-0072, TP-0073, TP-0074, TP-0076, TP-0080, TP-0081, TP-0082, TP-0083, TP-0084, TP-0085, TP-0086, TP-0087, TP-0088, TP-0089, TP-0090, TP-0092, TP-0094, TP-0095, TP-0096, TP-0097, TP-0098 | Não executada |
