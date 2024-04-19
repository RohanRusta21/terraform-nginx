provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

resource "aws_security_group" "web_sg1" {
  name        = "web-sg1"
  description = "Security group for web server"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "web-sg1"
  }
}

resource "aws_instance" "web1" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg1.name]
  
  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install -y nginx
            sudo systemctl enable nginx
            sudo systemctl start nginx
            
            echo '<html>
            <head>
            <title>Hello World</title>
            </head>
            <body>
            <h1>Hello World!</h1>
            </body>
            </html>' > /usr/share/nginx/html/index.html
            
            cat <<EOL | sudo tee /etc/nginx/sites-available/default
            server {
                listen 80 default_server;
                listen [::]:80 default_server;
                
                server_name _;

                location / {
                    root   /usr/share/nginx/html;
                    index  index.html;
                }
            }

            server {
                listen 443 ssl;
                listen [::]:443 ssl;
                
                ssl_certificate /etc/nginx/ssl/nginx.crt;
                ssl_certificate_key /etc/nginx/ssl/nginx.key;

                server_name _;

                location / {
                    root   /usr/share/nginx/html;
                    index  index.html;
                }
            }
            EOL
            
            sudo mkdir -p /etc/nginx/ssl
            sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"
            sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
            sudo systemctl restart nginx
            EOF
  
  tags = {
    Name = "web-server1"
  }
}
