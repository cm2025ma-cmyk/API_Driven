.PHONY: all start iam lambda apigateway ec2 test cleanup

all: start iam lambda apigateway ec2 test

start:
	./scripts/01-start-localstack.sh

iam:
	./scripts/02-setup-iam.sh

lambda:
	./scripts/03-deploy-lambda.sh

apigateway:
	./scripts/04-deploy-apigateway.sh

ec2:
	./scripts/05-create-ec2-instance.sh

test:
	./scripts/06-test-api.sh

cleanup:
	./scripts/99-cleanup.sh
