#!/bin/bash
set -e

echo "=========================================="
echo "🧹 ÉTAPE 99 : Nettoyage"
echo "=========================================="

# Arrêter et supprimer l'instance EC2
awslocal ec2 terminate-instances --instance-ids $INSTANCE_ID 2>/dev/null || true

# Supprimer la fonction Lambda
awslocal lambda delete-function --function-name ec2-controller 2>/dev/null || true

# Supprimer l'API Gateway
awslocal apigateway delete-rest-api --rest-api-id $API_ID 2>/dev/null || true

# Supprimer le rôle IAM
awslocal iam delete-role --role-name lambda-ec2-role 2>/dev/null || true

# Arrêter LocalStack
localstack stop 2>/dev/null || true

echo "✅ Nettoyage terminé."
