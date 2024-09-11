# README for Elastic IP Reassociation Script

## Overview

This Bash script is used to reassign an Elastic IP from one AWS EC2 instance to another. It automates the disassociation of an Elastic IP from an old instance and associates it with a new one. This can be useful when you need to transfer the IP between instances during scaling or instance replacements.

## Prerequisites

- AWS CLI must be installed and configured with appropriate credentials.
- The user running the script should have sufficient permissions to perform the following actions:
  - Describe EC2 addresses
  - Disassociate an Elastic IP
  - Associate an Elastic IP with an instance
- Ensure the EC2 instances and Elastic IP are in the same AWS region configured for the AWS CLI.

## Usage

```bash
./script.sh <old_instance_id> <new_instance_id> <elastic_ip>
```

- `<old_instance_id>`: The EC2 instance ID that currently holds the Elastic IP.
- `<new_instance_id>`: The EC2 instance ID you want to reassign the Elastic IP to.
- `<elastic_ip>`: The Elastic IP address you wish to transfer.

### Example

```bash
./script.sh i-01234abcd5678efgh i-0a1b2c3d4e5f67890 198.51.100.25
```

## How It Works

1. **Input Validation**: The script first checks whether all three arguments (old instance ID, new instance ID, and Elastic IP) are provided. If any argument is missing, the script exits with a usage message.

2. **Retrieve Elastic IP Allocation and Association IDs**:
    - The script retrieves the `Allocation ID` of the Elastic IP using the AWS CLI.
    - It also checks whether the Elastic IP is currently associated with any instance by fetching the `Association ID`.

3. **Disassociation**:
    - If the Elastic IP is currently associated with the old instance, the script disassociates it from that instance using the `disassociate-address` command.
  
4. **Association**:
    - The script then associates the Elastic IP with the new instance using the `associate-address` command.

## Error Handling

- If the Elastic IP is not associated with any instance, the script notifies the user and skips the disassociation step.
- The script will exit if any of the required input arguments are missing.

## Requirements

- AWS CLI version 1.16 or higher.
- Bash shell (Linux/macOS) or Git Bash (Windows).

## Notes

- Ensure that the provided instance IDs and Elastic IP are correct to avoid misconfigurations.
- If using this script for production environments, test it in a staging environment first.
