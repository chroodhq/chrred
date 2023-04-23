from dataclasses import dataclass


@dataclass
class URL:
    id: str
    key: str
    secret_key: str
    target_url: str
    is_active: bool
    clicks: int
