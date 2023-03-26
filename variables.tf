variable "auth_url" {
  type        = string
  description = "OpenStack auth url obtained from OS_AUTH_URL variable"
}

variable "username" {
  type        = string
  description = "OpenStack username obtained from OS_USERNAME variable"
}

variable "token" {
  type        = string
  description = "OpenStack issued token obtained from token.json after issue"
}

variable "project_name" {
  type        = string
  description = "OpenStack project name obtained from OS_PROJECT_NAME variable"
}
