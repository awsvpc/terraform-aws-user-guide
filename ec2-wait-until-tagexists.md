<pre>
  ## bash script
  #!/bin/bash

instance_id=$1
timeout=1800  # 30 minutes
interval=300  # 5 minutes
early_exit_timeout=120  # 2 minutes

# Check if instance ID is null
if [ -z "$instance_id" ]; then
    echo "Instance ID is null. Exiting."
    exit 1
fi

# Check if instance exists
instance_exists=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[*].Instances[*].InstanceId" --output text)
if [ -z "$instance_exists" ]; then
    echo "Instance ID not found. Exiting."
    exit 1
fi

start_time=$(date +%s)
end_time=$((start_time + timeout))
early_exit_time=$((start_time + early_exit_timeout))

while [ $(date +%s) -lt $end_time ]; do
    # Check if tags exist on the instance
    tags=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" --query 'Tags[?Key==`deploy` && Value==`complete`]' --output text)
    
    if [ -n "$tags" ]; then
        echo "Tags found: $tags"
        exit 0
    fi
    
    current_time=$(date +%s)
    
    if [ $current_time -lt $early_exit_time ]; then
        sleep $interval
    else
        echo "Tags not found within 2 minutes. Exiting early."
        exit 1
    fi
done

echo "Timeout exceeded, tags not found."
exit 1


  ## tf code
  provider "aws" {
  region = "your_aws_region"
}

resource "aws_instance" "example" {
  ami           = "your_ami_id"
  instance_type = "t2.micro"

  tags = {
    Name        = "ExampleInstance"
    Environment = "Production"
    // Add more tags as needed
  }

  provisioner "local-exec" {
    command = "INSTANCE_ID=${self.id} ./check_tags.sh"
    interpreter = ["bash", "-c"]
  }
}

</pre>
