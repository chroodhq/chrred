from src.domain.models import URL
from src.infrastructure.repositories.dynamodb_matching_table import DynamoDBMatchingTableRepository


class RedirectURLUseCase:
    def __init__(self) -> None:
        self.repository = DynamoDBMatchingTableRepository()

    def run(self, key: str) -> URL:
        try:
            url = self.repository.get_item(key)
        except Exception as e:
            raise e
        else:
            return url
