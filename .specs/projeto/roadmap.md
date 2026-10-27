# Roadmap

Roteiro aprovado em 2026-10-27 (decisão AD-001 em `.specs/STATE.md`). Origem: [necessidade.md](../produto/necessidade.md). Os requisitos de cada feature ganham IDs na spec dela (prefixo da coluna **Requisitos**).

| # | Feature | Situação | Tamanho | Depende de | Requisitos | Entrega (o que o usuário vê) |
|---|---|---|---|---|---|---|
| 1 | `fundacao` | Em andamento | M | n/a | FUN-* | O app abre em `tarefasdacasa.ljssoftware.com.br`, instalável no celular; CI verde, deploy único e backup diário com restauração testada |
| 2 | `conta-e-acesso` | Não começada | G | 1 | ACE-* | Um adulto cria a conta, confirma o e-mail, entra, recupera a senha e exclui a conta; landing, termos e privacidade |
| 3 | `casa-e-membros` | Não começada | M | 2 | CAS-* | O adulto cria a casa, convida os outros adultos e cadastra os perfis das crianças; ninguém de fora vê a casa |
| 4 | `tarefas-e-historico` | Não começada | G | 3 | TAR-* | A família cadastra tarefas com responsável e recorrência, vê as do dia, marca como feita e consulta quem fez o quê na semana |
| 5 | `lembretes` | Não começada | M | 4 | LEM-* | Cada adulto recebe no celular o lembrete das tarefas do dia (dele e dos perfis sem login de que cuida) |
