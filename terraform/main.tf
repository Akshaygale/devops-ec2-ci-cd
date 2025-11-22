resource "aws_security_group" "project_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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
}

resource "aws_instance" "frontend" {
  ami           = "ami-03bb6d83c60fc5f7c"   # Amazon Linux Mumbai
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.project_sg.name]

  user_data = <<EOF
#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Welcome to Frontend" > /var/www/html/index.html
EOF

  tags = {
    Name = "frontend-server"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-03bb6d83c60fc5f7c"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.project_sg.name]

  user_data = <<EOF
#!/bin/bash
yum install python3-pip -y
pip3 install flask
cat <<EOT > /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)
@app.route("/")
def home():
    return "Backend running successfully!"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOT
python3 /home/ec2-user/app.py &
EOF

  tags = {
    Name = "backend-server"
  }
}
