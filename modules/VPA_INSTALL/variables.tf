variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = null
}
variable "region" {
  description = "The region of the cluster"
  type        = string
  default     = "ap-southeast-2"
}
variable "git_clone_command" {
  description = "The repo want to git clone here."
  type        = string
  default     = null
}

variable "install_vpa_path" {
  description = "the install_vpa_path"
  type        = string
  default     = null
}

variable "removed_folder" {
  description = "The folder want to remove."
  default     = null
}

variable "uninstall_vpa_path" {
  description = "uninstall_vpa_path"
  type        = string
  default     = null

}