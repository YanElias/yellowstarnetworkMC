#!/usr/bin/env bash
set -euo pipefail

MC_VERSION="1.21.1"
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOBBY_DIR="${ROOT_DIR}/servers/lobby"
API_URL="https://api.papermc.io/v2/projects/paper/versions/${MC_VERSION}"

if ! command -v curl >/dev/null 2>&1; then
  echo "Erro: instale o curl primeiro."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Erro: instale o jq primeiro (no BigLinux: sudo pacman -S jq)."
  exit 1
fi

if [[ -f "${LOBBY_DIR}/server.jar" ]]; then
  echo "Já existe ${LOBBY_DIR}/server.jar. Não vou sobrescrever."
  exit 1
fi

mkdir -p "${LOBBY_DIR}"
echo "Consultando builds oficiais do Paper para Minecraft ${MC_VERSION}..."
BUILD="$(curl -fsSL "${API_URL}/builds" | jq -r '.builds[-1].build // empty')"

if [[ -z "${BUILD}" ]]; then
  echo "Não foi possível encontrar uma build. Verifique a versão e sua conexão."
  exit 1
fi

JAR_NAME="$(curl -fsSL "${API_URL}/builds/${BUILD}" | jq -r '.downloads.application.name')"
DOWNLOAD_URL="${API_URL}/builds/${BUILD}/downloads/${JAR_NAME}"

echo "Baixando Paper build ${BUILD}..."
curl -fL --progress-bar "${DOWNLOAD_URL}" -o "${LOBBY_DIR}/server.jar"

# Keep the EULA unaccepted until the owner reads and accepts it.
printf 'eula=false\n' > "${LOBBY_DIR}/eula.txt"

cat <<EOF

Paper foi baixado para:
  ${LOBBY_DIR}/server.jar

Próximo passo:
1. Leia o Minecraft EULA: https://www.minecraft.net/eula
2. Se concordar, altere eula=false para eula=true em:
   ${LOBBY_DIR}/eula.txt
3. Execute scripts/start-local.sh

Este script baixa apenas o servidor do lobby. Proxy e outros modos serão
adicionados depois que o lobby estiver testado.
EOF
