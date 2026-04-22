#!/bin/bash
set -e

echo "=========================================="
echo "🔐 ÉTAPE 2 : Configuration IAM"
echo "=========================================="

# Créer le rôle IAM
awslocal iam create-role --role-name lambda-ec2-role --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [{"Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]
}' || echo "Rôle IAM existe déjà"

# Attacher la politique de permission
awslocal iam put-role-policy --role-name lambda-ec2-role --policy-name ec2-permissions --policy-document '{
  "Version": "2012-10-17",
  "Statement": [{"Effect": "Allow", "Action": ["ec2:*", "logs:*"], "Resource": "*"}]
}'

echo "✅ Rôle IAM configuré."
