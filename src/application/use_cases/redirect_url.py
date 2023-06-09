from src.domain.models import URL
from src.infrastructure.repositories.dynamodb_matching_table import DynamoDBMatchingTableRepository


class RedirectURLUseCase:
    def __init__(self) -> None:
        self.repository = DynamoDBMatchingTableRepository()

    def run(self, key: str) -> URL:
        try:
            url = self.repository.get_item(key)
            url.clicks += 1
            self.repository.update_item(url)
        except Exception as e:
            raise e
        else:
            return url
