import boto3

region = 'ap-southeast-1'     ### Don't forget to update region
instances = ['i-0bbd6dbd90c81d36b']    ### Don't forget to update instanceID
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('Stopped your instances: ' + str(instances))
