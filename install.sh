#!/bin/bash
# =============================================================================
# Taco Obs - Instalador
#
# Uso remoto (one-liner):
#   curl -sSL https://raw.githubusercontent.com/tacoobs/agent/main/install.sh | sudo bash
#
# Uso local:
#   sudo ./install.sh
# =============================================================================

set -euo pipefail

REPO="tacoobs/agent"
BIN_PATH="/usr/local/bin/taco"
SBIN_LINK="/usr/sbin/taco"
GITHUB_RAW="https://raw.githubusercontent.com/${REPO}/main"

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

echo ""
echo -e "  ${BOLD}Taco Obs - Instalador${NC}"
echo -e "  ${DIM}──────────────────────────────────${NC}"
echo ""

# Verificar root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "  ${RED}ERRO: Execute com sudo${NC}"
  echo "  sudo bash install.sh"
  echo "  ou: curl -sSL ${GITHUB_RAW}/install.sh | sudo bash"
  exit 1
fi

# Verificar dependencias
for cmd in curl python3; do
  if ! command -v "$cmd" &>/dev/null; then
    echo -e "  ${RED}ERRO: '$cmd' nao encontrado. Instale antes de continuar.${NC}"
    exit 1
  fi
done

# Detectar se esta rodando local ou via pipe/curl
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/taco" ]; then
  echo -e "  ${DIM}Instalando a partir de arquivo local...${NC}"
  cp "$SCRIPT_DIR/taco" "$BIN_PATH"
else
  echo -e "  ${DIM}Baixando de github.com/${REPO}...${NC}"
  if ! curl -sSL "${GITHUB_RAW}/taco" -o "$BIN_PATH"; then
    echo -e "  ${RED}ERRO: Falha ao baixar. Verifique sua conexao e o repositorio.${NC}"
    exit 1
  fi
fi

chmod +x "$BIN_PATH"

# Criar link em /usr/sbin para funcionar com sudo
if [ ! -L "$SBIN_LINK" ] && [ ! -f "$SBIN_LINK" ]; then
  ln -s "$BIN_PATH" "$SBIN_LINK" 2>/dev/null || true
fi

# Verificar versao instalada
VERSION=$("$BIN_PATH" version 2>/dev/null || echo "unknown")

echo ""
echo -e "  ${GREEN}Instalado com sucesso!${NC}"
echo -e "  ${DIM}Versao:${NC}  ${BOLD}${VERSION}${NC}"
echo -e "  ${DIM}Binario:${NC} ${BIN_PATH}"
echo ""
echo -e "  Proximo passo: ${BOLD}sudo taco install${NC}"
echo ""
