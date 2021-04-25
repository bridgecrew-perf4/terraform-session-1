### Terraform frontend

Terraform is plugin based tool and all plugins are in ```.terraform``` folder, whenever you run ```terraform init``` it will initialize the working directory and install all needed plugins. Additional to ```.terraform``` folder ```.terraform.lock.hcl``` file gets created as well, which prevents from getting corrupted of your ```terraform.tfstate``` file.
