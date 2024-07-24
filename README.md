# Jenkins Server Deployment on Azure with Terraform

This project provisions and deploys a Jenkins server on Azure using Terraform. It supports both serverless deployment using Azure Container Instances (ACI) and deployment on an Azure Virtual Machine (VM). The project also configures Azure Storage for Jenkins data, uses Caddy for reverse proxy with Let's Encrypt, and includes a custom DNS module for DNS zone creation or configuration.

## Features

- **Serverless Deployment:** Deploy Jenkins on Azure Container Instances.
- **VM Deployment:** Option to deploy Jenkins on an Azure VM.
- **Azure Storage:** Persistent storage for Jenkins data.
- **Caddy Reverse Proxy:** Automatically configured with Let's Encrypt for HTTPS.
- **Custom DNS Module:** For DNS zone creation or configuration. [Custom DNS Module](https://github.com/ARMkiyas/terraform-az-dns-module)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed.
- An Azure account.

## Variables

| Variable Name             | Type    | Default                      | Description                                | Sensitive |
|---------------------------|---------|------------------------------|--------------------------------------------|-----------|
| `resGroup`                | string  | `jenkins_infra`              | Resource group name                        | No        |
| `location`                | string  | `eastus`                     | Location of the resource group             | No        |
| `env`                     | string  | `staging`                    | Environment of the resource group          | No        |
| `server_name`             | string  | `jenkins-master`             | Jenkins master container name              | No        |
| `storage_account_tier`    | string  | `Standard`                   | Storage account tier                       | No        |
| `storage_replication_type`| string  | `LRS`                        | Storage account replication type           | No        |
| `image`                   | string  | `armkiyas/jenkins-master:latest` | Container image                         | No        |
| `jenkins_admin_password`  | string  |                              | Jenkins admin password                     | Yes       |
| `password`                | string  |                              | Password                                   | Yes       |
| `use_vm`                  | bool    | `false`                      | Use VM instead of container                | No        |
| `vm_size`                 | string  | `Standard_F2s_v2`            | VM size                                    | No        |
| `vm-username`             | string  | `jenkinsuser`                | VM username                                | No        |
| `public_key`              | string  |                              | Public key for VM authentication           | Yes       |
| `create_dns_zone`         | bool    | `false`                      | Create new DNS zone                        | No        |
| `dns-zone`                | string  | `example.com`                | DNS zone name                              | No        |
| `dns_resource_group`      | string  | `mydnsrg`                    | DNS resource group name                    | No        |
| `subdomain`               | string  | `jenkins`                    | Subdomain name                             | No        |

## Usage

### Clone the repository

```bash
git clone https://github.com/ARMkiyas/terraform-jenkins-on-azure.git
cd terraform-jenkins-azure
```

### Backend Configuration

### Local Backend
By default, this project is set up to use the local backend for storing Terraform state files. This is suitable for initial development and testing on your local machine.

### Remote Backend
For collaboration and production use, it is recommended to use a remote backend such as Azure Storage, Amazon S3, or Terraform Cloud. Below are examples for configuring remote backends.

#### Azure Storage

1. Create an Azure Storage account and container.
2. Add the following backend configuration to your `provider.tf`:

    ```hcl
    terraform {
      backend "azurerm" {
        resource_group_name  = "your-resource-group"
        storage_account_name = "your-storage-account"
        container_name       = "your-container"
        key                  = "terraform.tfstate"
      }
    }
    ```

#### Amazon S3

1. Create an S3 bucket and DynamoDB table for state locking.
2. Add the following backend configuration to your `provider.tf`:

    ```hcl
    terraform {
      backend "s3" {
        bucket         = "your-s3-bucket"
        key            = "terraform.tfstate"
        region         = "your-region"
        dynamodb_table = "your-dynamodb-table"
        encrypt        = true
      }
    }
    ```

#### Terraform Cloud

1. Create a workspace in Terraform Cloud.
2. Add the following backend configuration to your `provider.tf`:

    ```hcl
    terraform {
      backend "remote" {
        organization = "your-organization"

        workspaces {
          name = "your-workspace"
        }
      }
    }
    ```


### Initialize Terraform 

```bash
terraform init
```

### Review and edit variables if needed:

Edit the `variables.tf` file to customize the deployment.

### Example Usage

To deploy a Jenkins server on Azure Container Instances with default settings, you can use the following commands:

```bash
terraform plan -var="jenkins_admin_password=yourpassword"
terraform apply -var="jenkins_admin_password=yourpassword"
```

To deploy a Jenkins server on an Azure VM with custom settings, use the following commands:

```bash
terraform plan -var="use_vm=true" -var="jenkins_admin_password=yourpassword" -var="public_key=yourpublickey"
terraform apply -var="use_vm=true" -var="jenkins_admin_password=yourpassword" -var="public_key=yourpublickey"
```

Alternatively, you can create a `terraform.tfvars` file to pass variables:

```hcl
resGroup                = "jenkins_infra"
location                = "eastus"
env                     = "staging"
server_name             = "jenkins-master"
storage_account_tier    = "Standard"
storage_replication_type= "LRS"
image                   = "armkiyas/jenkins-master:latest"
jenkins_admin_password  = "yourpassword"
password                = "yourpassword"
use_vm                  = false
vm_size                 = "Standard_F2s_v2"
vm-username             = "jenkinsuser"
public_key              = "yourpublickey"
create_dns_zone         = false
dns-zone                = "example.com"
dns_resource_group      = "mydnsrg"
subdomain               = "jenkins"
```

And then simply run:

```bash
terraform plan
terraform apply
```

## Important Notes

- Ensure you have the necessary permissions and credentials to deploy resources in your Azure account.
- Sensitive variables like passwords and keys are marked as `sensitive` in the Terraform configuration. Ensure these are handled securely.
## Contributing

We welcome contributions to enhance and improve this project! Please fork the repository and submit a pull request with your proposed changes. Ensure that your code adheres to the existing style and includes necessary documentation.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Terraform](https://www.terraform.io/)
- [Azure](https://azure.microsoft.com/)
- [Jenkins](https://www.jenkins.io/)
- [Caddy](https://caddyserver.com/)
- [Custom DNS Module](https://github.com/ARMkiyas/terraform-az-dns-module)

