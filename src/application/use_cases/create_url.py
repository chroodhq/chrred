import random
import string
import uuid

from src.domain.models import URL
from src.domain.schemas import URLBase


class CreateURLUseCase:
    def __init__(self) -> None:
        pass

    def run(self, url: URLBase) -> URL:
        return URL(
            id=uuid.uuid4(),
            key=''.join(random.choices(string.ascii_letters + string.digits, k=5)),
            secret_key=''.join(random.choices(string.ascii_letters + string.digits, k=12)),
            target_url=url.target_url,
            is_active=True,
            clicks=0,
        )
