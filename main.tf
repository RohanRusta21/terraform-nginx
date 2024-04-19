provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web server"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]
  
  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install -y nginx

            # Generate a self-signed SSL certificate for testing purposes
            sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"
            
            echo '<html>
            <head>
            <title>Hello World</title>
            </head>
            <body>
            <h1>Hello World!</h1>
            </body>
            </html>' | sudo tee /usr/share/nginx/html/index.html
            
            cat <<EOL | sudo tee /etc/nginx/sites-available/default
            server {
                listen 80 default_server;
                listen [::]:80 default_server;
                
                server_name _;

                location / {
                    return 301 https://\$host\$request_uri;
                }
            }

            server {
                listen 443 ssl default_server;
                listen [::]:443 ssl default_server;
                
                ssl_certificate /etc/nginx/ssl/nginx.crt;
                ssl_certificate_key /etc/nginx/ssl/nginx.key;
                
                root /usr/share/nginx/html;
                index index.html;

                location / {
                    try_files $uri $uri/ =404;
                }
            }
            EOL
            
            sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
            
            sudo systemctl restart nginx
            sudo systemctl enable nginx
            EOF
  
  tags = {
    Name = "web-server"
  }
}
