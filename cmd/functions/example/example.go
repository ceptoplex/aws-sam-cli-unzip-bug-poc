package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"net/http"
)

type Request = events.APIGatewayProxyRequest
type Response = events.APIGatewayProxyResponse

func status(code int) (Response, error) {
	return Response{
		StatusCode: code,
		Body:       http.StatusText(code),
	}, nil
}

func handler(req Request) (Response, error) {
	return status(http.StatusOK)
}

func main() {
	lambda.Start(handler)
}
