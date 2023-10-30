import json
import boto3

# Initialize dynamodb boto3 object
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    # Set up dynamodb table object
    table = dynamodb.Table('crc-backend-table')

    # Atomic update an item in table or add if doesn't exist
    ddbResponse = table.update_item(
        Key={
            "id": {
                "N": "0"
            }
        },

        ExpressionAttributeValues = {
            ':increase': {
                'N': 1,
            },
        },
        UpdateExpression = 'ADD count :increase',
        # UpdateExpression = 'ADD #usage :increase', 
        ReturnValues = 'UPDATED_NEW'
    )

    # Return dynamodb response object
    print(ddbResponse)
    return ddbResponse