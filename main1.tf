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
            EOL
            
            sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
            sudo systemctl restart nginx
            EOF
  
  tags = {
    Name = "web-server"
  }
}
