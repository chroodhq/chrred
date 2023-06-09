from dataclasses import dataclass


@dataclass
class URLBase:
    target_url: str


@dataclass
class URL(URLBase):
    is_active: bool
    clicks: int


@dataclass
class URLInfo(URL):
    url: str
    admin_url: str
