variable "AWS_REGION" {
  default = "eu-central-1"
}

# Bestehende DB-Vars
variable "DB_USERNAME" {
  default = "app_user"
}

variable "DB_NAME" {
  type      = string
  sensitive = true
}

variable "DB_PASSWORD" {
  type      = string
  sensitive = true
}

# Azure ChatGPT / Microsoft Foundry Vars
variable "AZURE_OPENAI_API_KEY" {
  type      = string
  sensitive = true
}

variable "AZURE_OPENAI_API_VERSION" {
  type    = string
  default = "2024-02-01"
}

variable "AZURE_OPENAI_API_ENDPOINT" {
  type      = string
  sensitive = true
}

variable "AZURE_OPENAI_API_MODEL_NAME" {
  type    = string
  default = "gpt-4.1-nano"
}

variable "AZURE_OPENAI_API_DEPLOYMENT" {
  type = string
}

# Unlock Password
variable "UNLOCK_PASSWORD" {
  type      = string
  sensitive = true
}

# Speech (optional)
variable "AZURE_SPEECH_KEY" {
  type      = string
  sensitive = true
}

variable "AZURE_SPEECH_REGION" {
  type = string
}
