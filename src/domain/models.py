import uuid

from dataclasses import dataclass


@dataclass
class URL:
    id: uuid.UUID
    key: str
    secret_key: str
    target_url: str
    is_active: bool
    clicks: int
