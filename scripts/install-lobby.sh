#!/usr/bin/env bash
set -euo pipefail

MC_VERSION="1.21.1"
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOBBY_DIR="${ROOT_DIR}/servers/lobby"
API_URL="https://fill.papermc.io/v3/projects/paper/versions/${MC_VERSION}/builds"
USER_AGENT="YellowStarNetworkMC/0.1 (https://github.com/YanElias/yellowstarnetworkMC)"

for command in curl jq sha256sum; do
  if ! command -v "${command}" >/dev/null 2>&1; then
    echo "Erro: falta o comando '${command}'. No BigLinux, instale com: sudo pacman -S curl jq coreutils"
    exit 1
  fi
done

if [[ -f "${LOBBY_DIR}/server.jar" ]]; then
  echo "Já existe ${LOBBY_DIR}/server.jar. Não vou sobrescrever."
  exit 1
fi

mkdir -p "${LOBBY_DIR}"
echo "Consultando builds estáveis oficiais do Paper para Minecraft ${MC_VERSION}..."

BUILDS_JSON="$(curl -fsSL -H "User-Agent: ${USER_AGENT}" "${API_URL}")"
DOWNLOAD_URL="$(jq -er 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].url) // empty' <<< "${BUILDS_JSON}")"
JAR_NAME="$(jq -er 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].name) // empty' <<< "${BUILDS_JSON}")"
EXPECTED_SHA256="$(jq -er 'first(.[] | select(.channel == "STABLE") | .downloads["server:default"].checksums.sha256) // empty' <<< "${BUILDS_JSON}")"

if [[ -z "${DOWNLOAD_URL}" || -z "${JAR_NAME}" || -z "${EXPECTED_SHA256}" ]]; then
  echo "Não foi encontrada uma build estável para Paper ${MC_VERSION}."
  exit 1
fi

TEMP_JAR="$(mktemp "${LOBBY_DIR}/server.jar.part.XXXXXX")"
cleanup() {
  rm -f "${TEMP_JAR}"
}
trap cleanup EXIT

echo "Baixando ${JAR_NAME} do serviço oficial PaperMC..."
curl -fL --retry 3 --retry-delay 2 -H "User-Agent: ${USER_AGENT}" "${DOWNLOAD_URL}" -o "${TEMP_JAR}"

ACTUAL_SHA256="$(sha256sum "${TEMP_JAR}" | awk '{print $1}')"
if [[ "${ACTUAL_SHA256}" != "${EXPECTED_SHA256}" ]]; then
  echo "Erro: o SHA-256 do arquivo baixado não confere. O arquivo não será instalado."
  exit 1
fi

mv "${TEMP_JAR}" "${LOBBY_DIR}/server.jar"
trap - EXIT

# The owner must review and accept the Minecraft EULA personally.
if [[ ! -f "${LOBBY_DIR}/eula.txt" ]]; then
  printf 'eula=false\n' > "${LOBBY_DIR}/eula.txt"
fi

cat <<EOF

Paper ${MC_VERSION} foi instalado e a verificação SHA-256 passou:
  ${LOBBY_DIR}/server.jar

Próximo passo:
1. Leia o Minecraft EULA: https://www.minecraft.net/eula
2. Se concordar, altere eula=false para eula=true em:
   ${LOBBY_DIR}/eula.txt
3. Execute: bash scripts/start-local.sh

Este script instala apenas o lobby. O proxy e os outros modos serão
adicionados depois que o lobby estiver testado.
EOF
