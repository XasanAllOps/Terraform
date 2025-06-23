    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install epel -y
    sudo yum install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "Hello World from $(hostname -f)" > /usr/share/nginx/html/index.html