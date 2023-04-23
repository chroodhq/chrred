import os

from dataclasses import dataclass


@dataclass
class __Configuration:
    @property
    def environment(self) -> str:
        return os.environ["ENVIRONMENT"]

    @property
    def base_url(self) -> str:
        return os.environ["BASE_URL"]

    @property
    def database_table_name(self) -> str:
        return os.environ["MATCHING_TABLE_DB_TABLE_NAME"]


config = __Configuration()
