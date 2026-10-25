#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="${ROOT_DIR}/servers"

if [[ ! -d "${SERVER_DIR}" ]]; then
  echo "Ainda não existem servidores instalados em: ${SERVER_DIR}"
  echo "Consulte NETWORK_PLAN.md. Este script não baixa JARs automaticamente."
  exit 1
fi

if [[ ! -f "${SERVER_DIR}/lobby/server.jar" ]]; then
  echo "Servidor do lobby não encontrado: ${SERVER_DIR}/lobby/server.jar"
  echo "A instalação dos servidores será configurada na próxima etapa."
  exit 1
fi

cd "${SERVER_DIR}/lobby"
exec java -Xms512M -Xmx2G -jar server.jar nogui
