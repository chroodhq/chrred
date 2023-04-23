resource "random_password" "api_auth_token" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_api_gateway_rest_api" "monolith" {
  name        = local.resource_prefix
  description = "Shortens links to Chrood's services and other offerings"
}

resource "aws_api_gateway_resource" "root_proxy" {
  rest_api_id = aws_api_gateway_rest_api.monolith.id
  parent_id   = aws_api_gateway_rest_api.monolith.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "root_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.monolith.id
  resource_id   = aws_api_gateway_resource.root_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "root_proxy_any_200" {
  rest_api_id = aws_api_gateway_rest_api.monolith.id
  resource_id = aws_api_gateway_resource.root_proxy.id
  http_method = aws_api_gateway_method.root_proxy_any.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = false
  }
}

resource "aws_api_gateway_integration" "root_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.monolith.id
  resource_id             = aws_api_gateway_resource.root_proxy.id
  http_method             = aws_api_gateway_method.root_proxy_any.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.monolith.invoke_arn
}

resource "aws_api_gateway_integration_response" "root_proxy_any_200" {
  depends_on = [aws_api_gateway_integration.root_proxy]

  rest_api_id = aws_api_gateway_rest_api.monolith.id
  resource_id = aws_api_gateway_resource.root_proxy.id
  http_method = aws_api_gateway_method.root_proxy_any.http_method
  status_code = aws_api_gateway_method_response.root_proxy_any_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  }
}

resource "aws_api_gateway_method" "root_proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.monolith.id
  resource_id   = aws_api_gateway_resource.root_proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "root_proxy_options_200" {
  rest_api_id = aws_api_gateway_rest_api.monolith.id
  resource_id = aws_api_gateway_resource.root_proxy.id
  http_method = aws_api_gateway_method.root_proxy_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = false
  }
}

resource "aws_api_gateway_integration_response" "root_proxy_options_200" {

  rest_api_id = aws_api_gateway_rest_api.monolith.id
  resource_id = aws_api_gateway_resource.root_proxy.id
  http_method = aws_api_gateway_method.root_proxy_options.http_method
  status_code = aws_api_gateway_method_response.root_proxy_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  }
}

resource "aws_api_gateway_integration" "root_proxy_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.monolith.id
  resource_id = aws_api_gateway_resource.root_proxy.id
  http_method = aws_api_gateway_method.root_proxy_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      "statusCode" : 200
    })
  }
}

resource "aws_api_gateway_integration_response" "root_proxy_options_mock" {
  depends_on = [aws_api_gateway_integration.root_proxy_options_mock]

  rest_api_id = aws_api_gateway_rest_api.monolith.id
  resource_id = aws_api_gateway_resource.root_proxy.id
  http_method = aws_api_gateway_method.root_proxy_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
  }
}

resource "aws_api_gateway_deployment" "monolith" {
  rest_api_id = aws_api_gateway_rest_api.monolith.id

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_api_gateway_integration.root_proxy),
      jsonencode(aws_api_gateway_integration.root_proxy_options_mock),
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "monolith" {
  rest_api_id   = aws_api_gateway_rest_api.monolith.id
  stage_name    = "v1"
  deployment_id = aws_api_gateway_deployment.monolith.id
}

resource "aws_api_gateway_domain_name" "stack_root_domain" {
  certificate_arn = aws_acm_certificate_validation.public_domain.certificate_arn
  domain_name     = local.domain
}
