#!/bin/bash
set -e

echo "=========================================="
echo "🧪 ÉTAPE 6 : Tests de l'API"
echo "=========================================="

echo "Test 1 : Démarrage de l'instance..."
RESPONSE=$(curl -s -X POST $API_URL \
  -H "Content-Type: application/json" \
  -d "{\"action\": \"start\", \"instance_id\": \"$INSTANCE_ID\"}")
echo "Réponse API: $RESPONSE"

# Vérifier l'état
STATE=$(awslocal ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].State.Name' --output text)
echo "État après START: $STATE"

echo ""
echo "Test 2 : Arrêt de l'instance..."
RESPONSE=$(curl -s -X POST $API_URL \
  -H "Content-Type: application/json" \
  -d "{\"action\": \"stop\", \"instance_id\": \"$INSTANCE_ID\"}")
echo "Réponse API: $RESPONSE"

# Vérifier l'état
STATE=$(awslocal ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].State.Name' --output text)
echo "État après STOP: $STATE"

echo "✅ Tests API terminés."
