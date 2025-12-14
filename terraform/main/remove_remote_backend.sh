# Setze die Environment-Variablen für den Namen des S3-Buckets und der DynamoDB-Tabelle
export TF_STATE_S3_BUCKET="marvin-tfstate-20251213"
export TF_STATE_DYNAMODB_TABLE="tf-state-locks"

# 1️⃣ Alle Objekte im S3-Bucket löschen
aws s3 rm s3://$TF_STATE_S3_BUCKET --recursive

# 2️⃣ S3-Bucket löschen
aws s3 rb s3://$TF_STATE_S3_BUCKET

# 3️⃣ DynamoDB-Tabelle löschen
aws dynamodb delete-table --table-name $TF_STATE_DYNAMODB_TABLE
