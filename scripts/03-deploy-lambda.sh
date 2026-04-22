#!/bin/bash
set -e

echo "=========================================="
echo "☁️ ÉTAPE 3 : Déploiement Lambda"
echo "=========================================="

# Créer le package ZIP
cd src
zip -r ../function.zip lambda_function.py
cd ..

# Déployer la fonction Lambda
awslocal lambda create-function \
  --function-name ec2-controller \
  --runtime python3.9 \
  --handler lambda_function.lambda_handler \
  --role arn:aws:iam::000000000000:role/lambda-ec2-role \
  --zip-file fileb://function.zip \
  --region us-east-1

echo "✅ Fonction Lambda déployée."
