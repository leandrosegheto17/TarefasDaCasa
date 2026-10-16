# ADR-004: A sessão é por aparelho, num cookie opaco HttpOnly validado no servidor; a criança entra por código de uso único e o Responsável por e-mail e senha

- **Status:** Aceito (rodada 2 do Loop B, 2026-10-16: o usuário aceitou o código de instalação no "Criar família", P-02)
- **Data:** 2026-10-16
- **Decisor:** Coordenador (chapéu Software Architect)
- **Requisitos ligados:** RF-01, RF-02, RF-03, RF-06, RF-07, RF-08, RN-18, RN-20, RNF-04, RNF-05, RNF-08, RNF-09; D-01, D-11, G-1, R-P4, R-P6; ADR-001

## Contexto

- D-01 (aceito): a criança não tem conta. O aparelho dela é vinculado por um código gerado por um Responsável e digitado **dentro do app instalado** (RN-18).
- RNF-05: a sessão não expira enquanto o app for usado ao menos 1 vez a cada 60 dias, e é revogável pelo servidor (RF-08).
- R-P4: no iOS, o app instalado tem armazenamento isolado do Safari. Link ou QR abertos fora do app não servem.
- RNF-08: não guardar mais do que apelido e avatar da criança; do adulto, apelido, e-mail e hash da senha.
- D-13 / RN-21: uma família por instalação. Quem chegar primeiro ao "Criar família" num domínio público vira dono. É preciso fechar essa porta.

## Decisão

1. **Sessão de aparelho**
   - Token aleatório de 32 bytes, enviado num cookie `HttpOnly; Secure; SameSite=Lax; Path=/`, host-only (sem atributo `Domain`), `Max-Age` de 400 dias (teto dos navegadores).
   - O banco guarda só o **hash SHA-256** do token, o membro, o rótulo do aparelho (sistema + navegador, sem o user-agent bruto), criação, último uso e revogação.
   - **Validade deslizante de 60 dias:** a sessão é válida se `ultimo_uso_em` tiver menos de 60 dias. `ultimo_uso_em` é atualizado no máximo 1 vez a cada 24 h, para não escrever a cada requisição.
   - Revogar = marcar `revogada_em`. A próxima requisição recebe 401 e o app vai para a entrada (CA-08.2). Sair (CA-08.3) revoga a própria sessão e apaga o cookie.
   - Nada da sessão fica em `localStorage` ou IndexedDB. Se o armazenamento local sumir, o servidor não perde nada (RNF-04).
2. **Código de vínculo (RN-18)**
   - 8 caracteres do alfabeto `23456789ABCDEFGHJKMNPQRSTUVWXYZ` (31 símbolos, sem 0/O, 1/I/L), sorteados com gerador criptográfico. Exibido como `ABCD-EFGH`; a entrada ignora hífen, espaço e caixa.
   - O banco guarda o hash, o membro, o tipo (Criança ou Responsável), quem gerou, a expiração (10 min), o uso e a invalidação. Gerar um novo código invalida o anterior não usado do mesmo membro (CA-06.2).
   - O uso é atômico: um único `UPDATE ... WHERE usado_em IS NULL AND expira_em > now()` consome o código e cria a sessão na mesma transação.
3. **Responsável**
   - E-mail (normalizado em minúsculas) e senha de 8+ caracteres. Hash com **`scrypt`** do próprio Node (`crypto.scrypt`, sal aleatório, parâmetros registrados junto do hash para poder subir o custo depois), sem dependência externa.
   - Mensagem genérica em credencial errada (CA-02.2).
   - O adulto convidado (RF-03) entra primeiro pelo código do tipo Responsável e então define e-mail e senha na mesma tela.
   - Sem recuperação por e-mail (D-11). Há um script de linha de comando, documentado no `DEPLOY.md`, para o desenvolvedor redefinir a senha (F6).
4. **Limites de tentativa** (tabela `tentativa_falha`, porque a função não guarda memória):
   - e-mail: 5 falhas seguidas → bloqueio de 15 min (CA-02.3);
   - código, por aparelho: 5 falhas seguidas → 10 min (CA-07.4). "Aparelho" = um cookie anônimo `tdc_aparelho` (id aleatório, HttpOnly), criado na primeira visita;
   - código e senha, por IP: 30 falhas por hora → bloqueio de 1 h. Protege contra quem apaga o cookie para burlar o limite.
5. **"Criar família" protegido por código de instalação**
   - A rota só funciona se ainda não houver família **e** se o pedido trouxer o `CODIGO_INSTALACAO`, um segredo definido numa variável de ambiente no deploy.
   - Depois que a família existe, a rota responde 404, e a tela de entrada nem mostra a opção (CA-01.3).
   - **Aceito pelo usuário (P-02, rodada 2):** o campo a mais complementa o CA-01.1 (UX-SPEC §7, C-01). A origem é um subdomínio público e previsível (`tarefas-da-casa-ljs.vercel.app`, ADR-006), então essa proteção é necessária.
6. **CSRF:** além do `SameSite=Lax`, toda requisição que altera dado precisa ter o cabeçalho `Origin` igual à origem pública configurada (ADR-006) e corpo JSON.

## Consequências

**Positivas**
- Sem conta, e-mail nem identificador pessoal para a criança (R-P6). O vazamento do banco não expõe tokens nem códigos (só hashes).
- Sessão longa sem refresh token nem JWT: um cookie e uma consulta.
- Revogação imediata e lista de aparelhos de graça (é a própria tabela de sessões).

**Negativas**
- Uma consulta ao banco por requisição para validar a sessão. Irrelevante no volume da família.
- **O "Criar família" ganha um campo a mais (o código de instalação)**, que o CA-01.1 não previa. O usuário aceitou (P-02) e digita esse código uma única vez. Está documentado no UX-SPEC §7, C-01.
- O limite por IP pode bloquear a casa inteira (mesmo IP do Wi-Fi) se alguém errar muito. Com 30 falhas por hora, isso só acontece em ataque ou brincadeira insistente.
- O limite por aparelho depende de um cookie que pode ser apagado. O limite por IP e o espaço de 31⁸ ≈ 8,5 × 10¹¹ códigos com validade de 10 min cobrem esse caso.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| JWT sem estado | Não dá para revogar sem lista de bloqueio, o que traz de volta o estado no servidor |
| Token em `localStorage` + cabeçalho `Authorization` | Exposto a XSS e sujeito à limpeza de armazenamento do iOS. O cookie HttpOnly não tem nenhum dos dois problemas |
| Link mágico ou QR com o código | Abre no Safari, cuja sessão não passa para o app instalado (R-P4, IR-05) |
| Argon2 / bcrypt por biblioteca | Funciona, mas traz dependência nativa. `scrypt` está no Node e é forte o bastante |
| Primeira família sem proteção | Qualquer pessoa que encontrar o domínio antes do usuário poderia criar a família e tomar a instalação |
