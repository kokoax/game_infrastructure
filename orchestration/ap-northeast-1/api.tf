# create_rest_api
resource "aws_api_gateway_rest_api" "_game" {
  name = "instance_rest"
  description = "game server instance controll"
}

# create_resource
resource "aws_api_gateway_resource" "instance_up" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  parent_id   = aws_api_gateway_rest_api._game.root_resource_id
  path_part   = "instance_up"
}

resource "aws_api_gateway_resource" "instance_down" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  parent_id   = aws_api_gateway_rest_api._game.root_resource_id
  path_part   = "instance_down"
}

# put_method
resource "aws_api_gateway_method" "instance_up" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_up.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "instance_down" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_down.id
  http_method = "POST"
  authorization = "NONE"
}

#   put-intergration (register lambda to put method)
resource "aws_api_gateway_integration" "instance_up" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_up.id
  http_method = aws_api_gateway_method.instance_up.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.instance_up_lambda.arn}/invocations"

  request_templates = {
    "application/x-www-form-urlencoded" = <<TEMPLATE
{}
    TEMPLATE
  }
}

resource "aws_api_gateway_integration" "instance_down" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_down.id
  http_method = aws_api_gateway_method.instance_down.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.instance_down_lambda.arn}/invocations"

  request_templates = {
    "application/x-www-form-urlencoded" = <<TEMPLATE
{}
    TEMPLATE
  }
}

# put-method-response
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  parent_id   = aws_api_gateway_rest_api._game.root_resource_id
  path_part   = "{proxy+}"
}

resource "null_resource" "method-delay" {
  provisioner "local-exec" {
    command = "sleep 300"
  }
  triggers = {
    response = aws_api_gateway_resource.proxy.id
  }
}

resource "aws_api_gateway_method_response" "instance_up_200" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_up.id
  http_method = aws_api_gateway_method.instance_up.http_method
  status_code = "200"
  depends_on = [null_resource.method-delay]
}

resource "aws_api_gateway_method_response" "instance_up_500" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_up.id
  http_method = aws_api_gateway_method.instance_up.http_method
  status_code = "500"
  depends_on = [ aws_api_gateway_method_response.instance_up_200 ]
}

resource "aws_api_gateway_method_response" "instance_down_200" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_down.id
  http_method = aws_api_gateway_method.instance_down.http_method
  status_code = "200"
  depends_on = [null_resource.method-delay]
}

resource "aws_api_gateway_method_response" "instance_down_500" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_down.id
  http_method = aws_api_gateway_method.instance_down.http_method
  status_code = "500"
  depends_on = [ aws_api_gateway_method_response.instance_down_200 ]
}

# put-integration-response
resource "aws_api_gateway_integration_response" "_instance_up_post_200" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_up.id
  http_method = aws_api_gateway_method.instance_up.http_method
  status_code = aws_api_gateway_method_response.instance_up_200.status_code
  response_templates = {
    "application/json" = "$input.path('$')"
  }
}

resource "aws_api_gateway_integration_response" "_instance_up_post_500" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_up.id
  http_method = aws_api_gateway_method.instance_up.http_method
  status_code = aws_api_gateway_method_response.instance_up_500.status_code
  selection_pattern = "[^0-9](.|\n)*"
  response_templates = {
    "application/json" = "$input.path('$').errorMessage"
  }
  depends_on = [ aws_api_gateway_integration_response._instance_up_post_200 ]
}

resource "aws_api_gateway_integration_response" "_instance_down_post_200" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_down.id
  http_method = aws_api_gateway_method.instance_down.http_method
  status_code = aws_api_gateway_method_response.instance_down_200.status_code
  response_templates = {
    "application/json" = "$input.path('$')"
  }
}

resource "aws_api_gateway_integration_response" "_instance_down_post_500" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  resource_id = aws_api_gateway_resource.instance_down.id
  http_method = aws_api_gateway_method.instance_down.http_method
  status_code = aws_api_gateway_method_response.instance_down_500.status_code
  selection_pattern = "[^0-9](.|\n)*"
  response_templates = {
    "application/json" = "$input.path('$').errorMessage"
  }
  depends_on = [ aws_api_gateway_integration_response._instance_down_post_200 ]
}

# create_deployment
resource "aws_api_gateway_deployment" "game_deployment" {
  rest_api_id = aws_api_gateway_rest_api._game.id
  depends_on = [ aws_api_gateway_integration.instance_up ]
  stage_name = "prod"
  stage_description = "setting file hash = ${md5(file("api.tf"))}"
}

# add-permission
resource "aws_lambda_permission" "instance_up" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.instance_up_lambda.function_name
  principal = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "instance_down" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.instance_down_lambda.function_name
  principal = "apigateway.amazonaws.com"
}
