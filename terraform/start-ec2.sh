#!/bin/bash

# Get list of all stopped instance IDs
instance_ids=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[State.Name, InstanceId]' --output text | grep stopped | awk '{print $2}')

# Loop through each instance ID and issue start command
for id in $instance_ids
do
    echo "Starting instance $id"
    aws ec2 start-instances --instance-ids $id
done

echo "All stopped instances have been started."

