
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Change to your desired AMI ID
  instance_type = "t2.micro"  # Change to your desired instance type
  key_name      = "your_key_pair"  # Change to your key pair name
  tags = {
    Name = "example-instance"
  }
}

# Outputs the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.example.public_ip
}



---
- name: Example playbook
  hosts: all
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    # Add more tasks as needed


resource "null_resource" "ansible_provisioner" {
  depends_on = [aws_instance.example]
  
  connection {
    type        = "ssh"
    user        = "ubuntu"  # User for connecting to the EC2 instance
    private_key = file("~/.ssh/your_private_key.pem")  # Path to your private key
    host        = aws_instance.example.public_ip
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.example.public_ip},' -u ubuntu --private-key=~/.ssh/your_private_key.pem playbook.yml"
  }
}
