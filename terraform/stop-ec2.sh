#!/bin/bash

[2;2R[3;1R[>77;30600;0c]10;rgb:bfbf/bfbf/bfbf]11;rgb:0000/0000/0000# Get list of all running instance IDs
instance_ids=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[State.Name, InstanceId]' --output text | grep running | awk '{print $2}')

# Loop through each instance ID and issue stop command
for id in $instance_ids
do
    echo "Stopping instance $id"
    aws ec2 stop-instances --instance-ids $id
done

echo "All running instances have been stopped."

