import json
import validators

from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.event_handler import APIGatewayRestResolver, Response, CORSConfig
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext

from src.domain import schemas
from src.application.use_cases.create_url import CreateURLUseCase
from src.application.use_cases.redirect_url import RedirectURLUseCase


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


@app.post("/url")
@tracer.capture_method
def create_url() -> Response:
    body = json.loads(str(app.current_event.body))
    url: schemas.URLBase = schemas.URLBase(**body)

    if not validators.url(url.target_url):
        return Response(body="Bad Request! Your provided URL is not valid.", status_code=400)
    else:
        use_case = CreateURLUseCase()
        response = use_case.run(url)
        return Response(body=json.dumps(response.__dict__), status_code=200)


@app.get("/<key>")
@tracer.capture_method
def redirect(key: str) -> Response:
    try:
        use_case = RedirectURLUseCase()
        response = use_case.run(key)
    except Exception as e:
        return Response(body=str(e), status_code=404)
    else:
        return Response(
            status_code=301,
            headers={"Location": response.target_url},
        )


@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
@tracer.capture_lambda_handler
def lambda_handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event=event, context=context)
