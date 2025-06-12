#!/usr/bin/env bash
set -euo pipefail

# 1) Destroy Terraform-managed infrastructure
cd infra
terraform destroy -auto-approve

# 2) Reset Ansible inventory placeholder
cd ../config
# Replace any IP or host entry with the __PUBLIC_IP__ placeholder
sed -i '2s/.*/__PUBLIC_IP__ ansible_user=ec2-user ansible_ssh_private_key_file=~\/\.ssh\/minecraft_key/' inventory.ini

echo "🧹 Infrastructure destroyed and inventory reset; ready for a fresh run."
