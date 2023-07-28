#!/bin/bash

# Get list of all instance IDs, state, public IP, private IP, and Name tag
instance_info=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, State.Name, PublicIpAddress, PrivateIpAddress, Tags[?Key==`Name`].Value | [0]]' --output text)

# Print the headers
printf "%-20s %-10s %-15s %-15s %-15s\n" "InstanceID" "State" "PublicIP" "PrivateIP" "Name"

# Print each instance's information
while IFS=$'\t' read -r -a myArray
do
    printf "%-20s %-10s %-15s %-15s %-15s\n" "${myArray[0]}" "${myArray[1]}" "${myArray[2]}" "${myArray[3]}" "${myArray[4]}"
done <<< "$instance_info"

echo "All instance information has been listed."



