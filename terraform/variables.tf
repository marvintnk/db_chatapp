variable "aws_region" {
  default = "eu-central-1"
}

# Bestehende DB-Vars
variable "db_username" {
  default = "app_user"
}

variable "db_name" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

# Azure ChatGPT / Microsoft Foundry Vars
variable "azure_openai_api_key" {
  type      = string
  sensitive = true
}

variable "azure_openai_api_version" {
  type    = string
  default = "2024-02-01"
}

variable "azure_openai_api_endpoint" {
  type      = string
  sensitive = true
}

variable "azure_openai_api_model_name" {
  type    = string
  default = "gpt-4.1-nano"
}

variable "azure_openai_api_deployment" {
  type = string
}

# Unlock Password
variable "unlock_password" {
  type      = string
  sensitive = true
}

# Speech (optional)
variable "azure_speech_key" {
  type      = string
  sensitive = true
}

variable "azure_speech_region" {
  type = string
}
