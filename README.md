# AWS SAM CLI Unzip Bug PoC

## Reproduce

1. ~$ sam build --beta-features --hook-name terraform
2. ~$ sam local start-lambda --beta-features --hook-name terraform
3. ~$ sam local invoke --beta-features --hook-name terraform -e events/example.json

Now, you will experience an error like this:
```
fork/exec /var/task/example: permission denied
```

You can manually set the correct file permissions to make it work:
```
~$ chmod a+x .aws-sam/build/AwsLambdaFunctionThis.../example
```
