# Baixa as fontes auto-hospedadas do mockup (e do app) para esta pasta.
# Fonte: pacotes Fontsource 5.3.0 (SIL Open Font License 1.1), subconjunto latin.
# Uso (PowerShell, na raiz do projeto):
#   powershell -ExecutionPolicy Bypass -File .md/mockup/fontes/baixar-fontes.ps1
# Depois de rodar, os 6 arquivos .woff2 e as 2 licenças ficam versionados junto do mockup.
$ErrorActionPreference = "Stop"
$destino = Split-Path -Parent $MyInvocation.MyCommand.Path
$base = "https://cdn.jsdelivr.net/npm"
$arquivos = @(
  @{ url = "$base/@fontsource/nunito@5.3.0/files/nunito-latin-400-normal.woff2"; nome = "nunito-latin-400-normal.woff2" },
  @{ url = "$base/@fontsource/nunito@5.3.0/files/nunito-latin-600-normal.woff2"; nome = "nunito-latin-600-normal.woff2" },
  @{ url = "$base/@fontsource/nunito@5.3.0/files/nunito-latin-700-normal.woff2"; nome = "nunito-latin-700-normal.woff2" },
  @{ url = "$base/@fontsource/nunito@5.3.0/files/nunito-latin-800-normal.woff2"; nome = "nunito-latin-800-normal.woff2" },
  @{ url = "$base/@fontsource/baloo-2@5.3.0/files/baloo-2-latin-700-normal.woff2"; nome = "baloo-2-latin-700-normal.woff2" },
  @{ url = "$base/@fontsource/baloo-2@5.3.0/files/baloo-2-latin-800-normal.woff2"; nome = "baloo-2-latin-800-normal.woff2" },
  @{ url = "$base/@fontsource/nunito@5.3.0/LICENSE"; nome = "LICENCA-nunito-OFL.txt" },
  @{ url = "$base/@fontsource/baloo-2@5.3.0/LICENSE"; nome = "LICENCA-baloo-2-OFL.txt" }
)
foreach ($a in $arquivos) {
  $alvo = Join-Path $destino $a.nome
  Write-Host "Baixando $($a.nome)"
  Invoke-WebRequest -Uri $a.url -OutFile $alvo -UseBasicParsing
  if ((Get-Item $alvo).Length -lt 1000 -and $a.nome -like "*.woff2") { throw "Arquivo pequeno demais: $($a.nome)" }
}
Write-Host "Pronto: fontes em $destino"
