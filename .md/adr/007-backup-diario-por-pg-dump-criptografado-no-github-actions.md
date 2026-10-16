# ADR-007: O backup é um `pg_dump` diário, criptografado com `age` e guardado como artefato do GitHub Actions por 30 dias

- **Status:** Aceito (rodada 2 do Loop B, 2026-10-16: o usuário aceitou o artefato do GitHub e fica com a chave privada `age`, P-03)
- **Data:** 2026-10-16
- **Decisor:** Coordenador (chapéu Software Architect)
- **Requisitos ligados:** RNF-13 (Should), RNF-04, RNF-08, RNF-14; R-P5; ADR-002

## Contexto

- RNF-13: cópia recuperável com no máximo 7 dias de defasagem, e procedimento de restauração documentado no `DEPLOY.md`.
- O Neon Free tem restauração a um ponto no tempo só numa janela curta (horas). Isso não cobre um erro descoberto dias depois.
- O banco é pequeno (alguns MB) e contém e-mails e hashes de senha dos adultos e apelidos das crianças.
- Custo zero: repositório no GitHub com Actions gratuitas.

## Decisão

1. Workflow agendado `.github/workflows/backup.yml`, **diário** às 03:00 de Brasília, mais disparo manual.
2. Roda `pg_dump -Fc` com um papel só de leitura, criptografa o arquivo com **`age`** usando uma chave pública versionada no repositório e publica o resultado como **artefato do workflow, com retenção de 30 dias**.
3. A **chave privada fica com o usuário**, fora do GitHub. Ele aceitou essa guarda (P-03). Guarde uma segunda cópia offline, por exemplo num gerenciador de senhas.
4. O `DEPLOY.md` documenta a restauração: baixar o artefato, descriptografar, `pg_restore` num banco novo (um branch do Neon ou um Postgres local), conferir e trocar a `DATABASE_URL`.
5. **Ensaio de restauração** uma vez antes da primeira instalação real (B8). Depois, a cada 6 meses.
6. O job falha (e o GitHub avisa o usuário por e-mail) se o dump vier vazio ou se o `pg_dump` der erro.

## Consequências

**Positivas**
- Defasagem de no máximo ~24 h, bem abaixo dos 7 dias do RNF-13.
- Custo zero e independente do Neon (sair do fornecedor é restaurar o dump em qualquer Postgres 17).
- Dado em repouso criptografado fora do banco. Quem tiver acesso ao repositório não lê o backup.

**Negativas**
- Se a chave privada se perder, os backups ficam inúteis. O dono da chave é o usuário.
- Os artefatos dependem da conta do GitHub. Se o repositório for apagado, os backups vão junto.
- O workflow acorda o banco uma vez por dia. Gasta poucos minutos de computação, desprezível perto da cota de 100 CU-h.
- Uma credencial a mais (papel só de leitura) nos segredos do GitHub.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Só a restauração a um ponto no tempo do Neon | Janela curta demais para o RNF-13 |
| Bucket de objetos (R2, S3) | Mais uma conta e uma credencial. O artefato do Actions basta para alguns MB |
| Backup semanal | Cumpre o RNF-13, mas o diário custa o mesmo e reduz a perda |
| Backup sem criptografia | Expõe e-mails e hashes a quem tiver acesso ao repositório |
