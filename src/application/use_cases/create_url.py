import random
import string
import uuid

from src.domain.models import URL
from src.domain.schemas import URLBase, URLInfo
from src.infrastructure.repositories.dynamodb_matching_table import DynamoDBMatchingTableRepository


class CreateURLUseCase:
    def __init__(self) -> None:
        self.repository = DynamoDBMatchingTableRepository()

    def run(self, url_base: URLBase) -> URLInfo:
        try:
            url = URL(
                id=str(uuid.uuid4()),
                key="".join(random.choices(string.ascii_letters + string.digits, k=5)),
                secret_key="".join(random.choices(string.ascii_letters + string.digits, k=12)),
                target_url=url_base.target_url,
                is_active=True,
                clicks=0,
            )
            self.repository.create_item(url)
        except Exception as e:
            raise e
        else:
            return URLInfo(**url.__dict__)
