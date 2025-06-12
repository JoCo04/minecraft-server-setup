#!/usr/bin/env bash
set -euo pipefail

cd config
sed -i '2s/.*/__PUBLIC_IP__ ansible_user=ec2-user ansible_ssh_private_key_file=~\/\.ssh\/minecraft_key/' inventory.ini

# 1) Terraform
cd ../infra
terraform init
terraform apply -replace="aws_instance.minecraft" -auto-approve

# 2) Grab the new IP
IP=$(terraform output -raw public_ip)

# 3) Inject into Ansible inventory
cd ../config
sed -i "s/__PUBLIC_IP__/$IP/" inventory.ini
sed -i "s|\${var.key_name}|minecraft_key|" inventory.ini


# 4) Run Ansible
ansible-playbook -i inventory.ini playbook.yml

echo "🎉  Server is ready at $IP:25565"

