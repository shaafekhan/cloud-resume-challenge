import boto3

def lambda_handler(event, context):
    # Set up dynamodb table object
    dynamodbClient = boto3.client('dynamodb', region_name='eu-west-1')

    # Atomic update an item in table or add if doesn't exist
    ddbResponse = dynamodbClient.update_item(
        TableName='crc-backend-table',
        Key={'id': {'N': '0'}},
        UpdateExpression="SET #countValue = #countValue + :increment",
        ExpressionAttributeNames={'#countValue': 'countValue'},
        ExpressionAttributeValues={':increment': {'N': '1'}},
        ReturnValues = 'UPDATED_NEW'
    )

    # Return dynamodb response object
    print(ddbResponse)
    return ddbResponse