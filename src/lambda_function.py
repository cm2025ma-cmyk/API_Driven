import json
import boto3

def lambda_handler(event, context):
    try:
        body = json.loads(event.get('body', '{}'))
        action = body.get('action')
        instance_id = body.get('instance_id')
        
        if not instance_id:
            return {'statusCode': 400, 'body': json.dumps({'error': 'Instance ID manquant'})}

        ec2 = boto3.client('ec2', endpoint_url='http://localhost:4566', region_name='us-east-1')

        if action == 'start':
            ec2.start_instances(InstanceIds=[instance_id])
            msg = f"Instance {instance_id} démarrée."
        elif action == 'stop':
            ec2.stop_instances(InstanceIds=[instance_id])
            msg = f"Instance {instance_id} arrêtée."
        else:
            return {'statusCode': 400, 'body': json.dumps({'error': 'Action invalide'})}

        return {'statusCode': 200, 'body': json.dumps({'message': msg})}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'error': str(e)})}
