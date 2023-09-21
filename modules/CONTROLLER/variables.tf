variable "controller_repo_url" {
  description = "The repo url of controller repo"
  type        = string
  default     = null
}

variable "chart_name" {
  description = "The chart name in the repo to be used."
  type        = string
  default     = null
}

variable "namespace" {
  description = "The namespace to be deployed in k8s."
  type        = string
  default     = "default"
}

variable "set_values_list" {
  description = "The values list should be overwrited into the values.yaml of helm chart."
  type = list(object({
    name  = string
    value = string
  }))

}