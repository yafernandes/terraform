### secret-datadog.json
```json
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::464622532012:root"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
          "StringEquals": {
            "sts:ExternalId": "<YOUR_DD_EXTERNAL_ID>"
          }
        }
      }
    ]
  }
```

https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions#datadog-aws-iam-policy
https://docs.datadoghq.com/integrations/amazon_lambda/#metric-collection
