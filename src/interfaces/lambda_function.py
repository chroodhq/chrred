from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.event_handler import APIGatewayRestResolver, Response, CORSConfig
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext
import validators

from src.domain import models


tracer = Tracer()
logger = Logger()

cors_config = CORSConfig(allow_origin="*")
app = APIGatewayRestResolver(cors=cors_config)


@app.get("/health")
@tracer.capture_method
def welcome() -> Response:
    return Response(
        body="Welcome to Chrood's link shortener!", status_code=200, content_type="text/plain"
    )


@app.post("/<url>")
@tracer.capture_method
def create_url(url: models.URLBase) -> Response:
    if not validators.url(url.target_url):
        return Response(body="Bad Request! Your provided URL is not valid.", status_code=400)
    return Response(body=f"TODO: Create database entry for: {url.target_url}", status_code=200)


@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
@tracer.capture_lambda_handler
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event=event, context=context)
