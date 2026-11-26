#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================================"
echo " MecâniQA Automotive Tech — OAT 4 (API + Prometheus + Grafana)"
echo "============================================================"
echo ""
echo "[1/3] Subindo containers (API Django, Prometheus e Grafana)..."
docker compose up -d --build

echo ""
echo "[2/3] Aguardando a API Django ficar disponível em http://localhost:8000/health/ ..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:8000/health/ > /dev/null 2>&1; then
    echo "      API disponível!"
    break
  fi
  if [ "$i" -eq 30 ]; then
    echo "[ERRO] A API não respondeu após 30 tentativas. Verifique 'docker compose logs api'."
    exit 1
  fi
  sleep 1
done

echo ""
echo "Serviços ativos:"
echo "  - API Django (endpoint):  http://localhost:8000/api/manutencoes/"
echo "  - Métricas Prometheus:    http://localhost:8000/metrics"
echo "  - Prometheus UI:          http://localhost:9090"
echo "  - Grafana UI:             http://localhost:3000  (usuário: admin | senha: admin)"
echo ""
echo "[3/3] Iniciando gerador contínuo de tráfego (2xx, 4xx e 5xx)..."
echo "      (Pressione Ctrl+C para parar o gerador; os containers continuarão rodando.)"
echo ""

python3 scripts/gerar_trafego.py --url http://localhost:8000
