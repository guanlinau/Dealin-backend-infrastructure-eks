variable "secret_name" {
  description = "The friendly of the new secret."
  type        = string
  default     = null
}
variable "kms_key_id" {
  description = "The kms key id"
  type        = string
  default     = null
}

variable "app_name" {
  description = "The name of the app"
  type        = string
  default     = null
}
variable "secret_value" {
  description = "The secret value"
  type        = string
  default     = null
}

