SHELL := /bin/bash
AWS_PROFILE := "default"

build-go:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -trimpath -o bin/functions/example cmd/functions/example/example.go
	pushd bin/functions && chmod 777 * && zip -r ../functions.zip * && popd

build-sam:
	sam build --beta-features --hook-name terraform

run:
	AWS_PROFILE=${AWS_PROFILE} sam local start-lambda --beta-features --hook-name terraform

invoke:
	AWS_PROFILE=${AWS_PROFILE} sam local invoke --beta-features --hook-name terraform -e events/example.json
