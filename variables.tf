variable "resGroup" {
  type        = string
  default     = "cloudcareinfra"
  description = "resource group name"

}

variable "locaion" {
  type        = string
  default     = "eastus"
  description = "location of the resource group"
}


variable "env" {
  type        = string
  default     = "staging"
  description = "environment of the resource group"

}

variable "container_group_name" {
  type        = string
  default     = "jenkins-master"
  description = "jenkins master container name"
  
}