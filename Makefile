virtualenv:
	pip install poetry

install:
	poetry install

unit-tests:
	poetry run pytest tests/unit -vv

integration-tests:
	poetry run pytest tests/integration -vv

lint: typecheck
	poetry run flake8 src

style:
	poetry run black src

typecheck:
	poetry run mypy -p src
	poetry run black --check src
