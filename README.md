# terraform-nginx

For this assignment, I utilized Terraform as the chosen configuration management tool. Terraform, developed by HashiCorp, is an open-source infrastructure as code (IaC) tool that uses HashiCorp Configuration Language (HCL) for its syntax.

The primary configuration file, main1.tf, orchestrates the provisioning of an Amazon EC2 instance. This instance is initialized with an Amazon Linux 2 AMI and subsequently configured to install and run Nginx. The content to be served by Nginx is embedded within the user_data field, ensuring that upon instance initialization, the desired HTML content is immediately available for web access.

To ensure security and accessibility, I've defined appropriate ingress rules in the associated security group. Specifically, ports 80 (HTTP) and 443 (HTTPS) are allowed for public access. Additionally, HTTP requests are automatically redirected to HTTPS to enforce secure communication. This redirection is achieved through the Nginx configuration specified within the user_data section, particularly in the default.conf file.



To Access The Web Server
```shell
https://44.202.19.255/
```

### Commands used to execute the terraform code

```shell
terraform init ## to initialise and install the dependencies used by the provider used

terraform validate ## to validate the syntax and other stuff of the tf file

terraform plan  ## to check the status and plan of infrastructure

terraform apply ## to apply the code and get the infra ready
```


### Images For References

<img width="1512" alt="Screenshot 2024-04-19 at 11 15 42 PM" src="https://github.com/RohanRusta21/terraform-nginx/assets/110477025/3dad9d43-b5fc-4453-886a-9dea07d7fdda">


<br>

![image](https://github.com/RohanRusta21/terraform-nginx/assets/110477025/41ef1b43-35ce-495d-98f7-009b4470ea96)
