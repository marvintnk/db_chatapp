# Setze die Environment-Variablen für den Namen des S3-Buckets und der DynamoDB-Tabelle
export TF_STATE_S3_BUCKET="marvin-tfstate-20251213"
export TF_STATE_DYNAMODB_TABLE="tf-state-locks"

# 1️⃣ S3-Bucket für Terraform State erstellen
aws s3 mb s3://$TF_STATE_S3_BUCKET --region eu-central-1

# 2️⃣ Versioning aktivieren (optional, aber empfohlen)
aws s3api put-bucket-versioning \
    --bucket $TF_STATE_S3_BUCKET \
    --versioning-configuration Status=Enabled

# 3️⃣ DynamoDB-Tabelle für State Locks erstellen
aws dynamodb create-table \
    --table-name $TF_STATE_DYNAMODB_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region eu-central-1
