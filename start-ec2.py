import boto3

region = 'ap-southeast-1'     ### Don't forget to update region
instances = ['i-0bbd6dbd90c81d36b']  ### Dont forget to update instanceID
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('Started your instances: ' + str(instances))
