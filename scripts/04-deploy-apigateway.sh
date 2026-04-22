#!/bin/bash
set -e

echo "=========================================="
echo "🌐 ÉTAPE 4 : Déploiement API Gateway"
echo "=========================================="

# Créer l'API
API_ID=$(awslocal apigateway create-rest-api --name ec2-api --description "API EC2 Controller" --query 'id' --output text)
echo "API ID: $API_ID"

# Récupérer l'ID de la ressource racine
ROOT_ID=$(awslocal apigateway get-resources --rest-api-id $API_ID --query 'items[0].id' --output text)

# Créer la ressource "/control"
RESOURCE_ID=$(awslocal apigateway create-resource --rest-api-id $API_ID --parent-id $ROOT_ID --path-part control --query 'id' --output text)

# Configurer la méthode POST
awslocal apigateway put-method \
  --rest-api-id $API_ID \
  --resource-id $RESOURCE_ID \
  --http-method POST \
  --authorization-type NONE \
  --request-in '{"application/json": ""}'

# Intégrer avec Lambda
awslocal apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $RESOURCE_ID \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:ec2-controller/invocations"

# Déployer l'API
awslocal apigateway create-deployment --rest-api-id $API_ID --stage-name dev

# Exporter les variables pour les étapes suivantes
echo "API_ID=$API_ID" >> $GITHUB_ENV
echo "API_URL=https://$API_ID.execute-api.us-east-1.localhost.localstack.cloud/dev/control" >> $GITHUB_ENV

echo "✅ API Gateway déployée à: $API_URL"
