import boto3

from src.configuration import config
from src.domain.models import URL


class DynamoDBMatchingTableRepository:
    def __init__(self) -> None:
        self.client = boto3.client("dynamodb")
        self.table_name = config.database_table_name

    def create_item(self, url: URL) -> dict:
        try:
            response = self.client.put_item(
                TableName=self.table_name,
                Item=self.convert_url_to_dynamodb_item(url),
            )
        except Exception as e:
            raise e
        else:
            return response

    def get_item(self, key: str) -> URL:
        try:
            response = self.client.query(
                TableName=self.table_name,
                KeyConditionExpression="url_key = :url_key",
                ExpressionAttributeValues={":url_key": {"S": key}},
            )
            url = self.convert_dynamodb_item_to_url(response["Items"][0])
        except Exception as e:
            raise e
        else:
            return url

    @staticmethod
    def convert_url_to_dynamodb_item(url: URL) -> dict:
        return {
            "id": {"S": url.id},
            "url_key": {"S": url.key},
            "secret_key": {"S": url.secret_key},
            "target_url": {"S": url.target_url},
            "is_active": {"BOOL": url.is_active},
            "clicks": {"N": str(url.clicks)},
        }

    @staticmethod
    def convert_dynamodb_item_to_url(item: dict) -> URL:
        return URL(
            id=item["id"]["S"],
            key=item["url_key"]["S"],
            secret_key=item["secret_key"]["S"],
            target_url=item["target_url"]["S"],
            is_active=item["is_active"]["BOOL"],
            clicks=int(item["clicks"]["N"]),
        )
