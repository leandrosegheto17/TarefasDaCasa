#!/usr/bin/env bash
# Baixa as fontes auto-hospedadas do mockup (e do app) para esta pasta.
# Fonte: pacotes Fontsource 5.3.0 (SIL Open Font License 1.1), subconjunto latin.
# Uso (na raiz do projeto): bash .md/mockup/fontes/baixar-fontes.sh
set -euo pipefail
destino="$(cd "$(dirname "$0")" && pwd)"
base="https://cdn.jsdelivr.net/npm"
baixar() { echo "Baixando $2"; curl -fsSL "$1" -o "$destino/$2"; }
for p in 400 600 700 800; do
  baixar "$base/@fontsource/nunito@5.3.0/files/nunito-latin-$p-normal.woff2" "nunito-latin-$p-normal.woff2"
done
for p in 700 800; do
  baixar "$base/@fontsource/baloo-2@5.3.0/files/baloo-2-latin-$p-normal.woff2" "baloo-2-latin-$p-normal.woff2"
done
baixar "$base/@fontsource/nunito@5.3.0/LICENSE" "LICENCA-nunito-OFL.txt"
baixar "$base/@fontsource/baloo-2@5.3.0/LICENSE" "LICENCA-baloo-2-OFL.txt"
echo "Pronto: fontes em $destino"
