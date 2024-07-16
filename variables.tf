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

variable "server_name" {
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
  sensitive   = true

}


variable "docker_username" {
  type        = string
  description = "username"
  sensitive   = true

}

variable "docker_password" {
  type        = string
  description = "username"
  sensitive   = true

}


variable "password" {
  type        = string
  description = "password"
  sensitive   = true

}

variable "registry_url" {
  type        = string
  default     = "jenkins-master"
  description = "jenkins master container name"

}

variable "use_vm" {
  type        = bool
  default     = false
  description = "use vm instead of container"

}

variable "vm_size" {
  type        = string
  default     = "Standard_F2s_v2"
  description = "vm size"
}


variable "vm-username" {
  type        = string
  description = "vm username"
  default     = "jenkinsuser"

}


variable "public_key" {
  type        = string
  description = "public key for vm authentication"
  sensitive   = true

}


variable "create_dns_zone" {
  type        = bool
  default     = false
  description = "create new dns zone"

}

variable "dns-zone" {
  type        = string
  description = "dns zone name"
  default     = "expample.com"
}


variable "dns_resource_group" {
  type        = string
  description = "dns resource group name"
  default     = "mydnsrg"

}
