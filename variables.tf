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

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "storage account tier"
}


variable "storage_replication_type" {
  type        = string
  default     = "LRS"
  description = "storage account replication type"

}


variable "image" {
  
  type        = string
  default     = "armkiyas/jenkins-master:latest"
  description = "container image"
}


variable "jenkins_admin_password" {
  type        = string
  description = "jenkins admin password"
  sensitive = true
  
}


variable "username" {
  type        = string
  description = "username"
  sensitive = true
  
}

variable "password" {
  type        = string
  description = "password"
  sensitive = true
  
}

variable "registry_url" {
  type        = string
  default     = "jenkins-master"
  description = "jenkins master container name"

}