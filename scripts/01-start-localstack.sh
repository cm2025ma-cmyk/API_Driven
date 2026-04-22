#!/bin/bash
set -e

echo "=========================================="
echo "🚀 ÉTAPE 1 : Démarrage de LocalStack"
echo "=========================================="

# Démarrer LocalStack en arrière-plan
localstack start -d

# Attendre que LocalStack soit prêt
max_attempts=10
attempt=0
while [ $attempt -lt $max_attempts ]; do
  if curl -s http://localhost:4566/_localstack/health | grep -q '"running"'; then
    echo "✅ LocalStack est prêt !"
    break
  fi
  echo "Tentative $((attempt+1))/$max_attempts : En attente..."
  sleep 3
  attempt=$((attempt+1))
done

if [ $attempt -eq $max_attempts ]; then
  echo "❌ Échec : LocalStack n'est pas prêt."
  localstack logs --follow &
  sleep 5
  exit 1
fi

echo "LocalStack démarré avec succès."
