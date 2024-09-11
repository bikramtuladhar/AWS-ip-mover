#!/bin/bash

# Input variables
OLD_INSTANCE_ID=$1
NEW_INSTANCE_ID=$2
ELASTIC_IP=$3

# Check if all arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <old_instance_id> <new_instance_id> <elastic_ip>"
  exit 1
fi

# Get the Allocation ID of the Elastic IP
ALLOCATION_ID=$(aws ec2 describe-addresses --query "Addresses[?PublicIp=='$ELASTIC_IP'].AllocationId" --output text)

# Check if the Elastic IP is currently associated
ASSOCIATION_ID=$(aws ec2 describe-addresses --query "Addresses[?PublicIp=='$ELASTIC_IP'].AssociationId" --output text)

if [ "$ASSOCIATION_ID" != "None" ]; then
  # Disassociate the Elastic IP from the old instance
  echo "Disassociating Elastic IP $ELASTIC_IP from instance $OLD_INSTANCE_ID..."
  aws ec2 disassociate-address --association-id $ASSOCIATION_ID

  echo "Elastic IP $ELASTIC_IP disassociated from instance $OLD_INSTANCE_ID."
else
  echo "Elastic IP $ELASTIC_IP is not associated with any instance."
fi

# Associate the Elastic IP with the new instance
echo "Associating Elastic IP $ELASTIC_IP with instance $NEW_INSTANCE_ID..."
aws ec2 associate-address --instance-id $NEW_INSTANCE_ID --allocation-id $ALLOCATION_ID

echo "Elastic IP $ELASTIC_IP associated with instance $NEW_INSTANCE_ID."

