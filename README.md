# Minecraft Server Setup Automation

This repository provides a fully automated pipeline to provision, configure, and deploy a Minecraft server on AWS using Terraform and Ansible. The goal is to run **one command** and have:

- A new VPC and Security Group
- An EC2 instance (Amazon Linux 2023)
- Java 21 (Amazon Corretto) installed
- Latest Minecraft server JAR downloaded and configured
- A systemd service to manage auto‑start and graceful shutdown

All infrastructure and configuration is defined as code under `infra/` (Terraform) and `config/` (Ansible), and orchestrated via `scripts/run_all.sh`.

---

## Table of Contents

- [Background](#background)
- [Requirements](#requirements)
- [Architecture Diagram](#architecture-diagram)
- [Usage](#usage)
- [Connecting to the Server](#connecting-to-the-server)
- [Cleanup](#cleanup)
- [Repository Structure](#repository-structure)
- [Resources](#resources)

---

## Background

Employees at Acme Corp need a reliable Minecraft server for team‑building exercises. This pipeline:

1. Provisions AWS resources (networking, compute) via Terraform.
2. Configures the instance (Java, Minecraft) via Ansible.
3. Exposes the server on port 25565, configured for auto‑restart on reboot or failure.

---

## Requirements

Before running the pipeline, install and configure:

- **AWS CLI v2**: configured with temporary credentials or profile in `~/.aws/credentials`
- **Terraform v1.0+**
- **Ansible 2.9+**
- **jq** and **curl** (for dynamic Minecraft version lookup)
- **SSH keypair**:
  - Private key at `~/.ssh/minecraft_key`
  - Public key imported into AWS (Terraform will create it if not present)

---

## Terraform Variables

This project uses `infra/terraform.tfvars` to override default variables like `key_name` and `public_key_path`. We provide a template `infra/terraform.tfvars.example` that you should copy and customize before running:

```bash
cp infra/terraform.tfvars.example infra/terraform.tfvars
# Then edit infra/terraform.tfvars with your values
```

Do **not** commit your personal `terraform.tfvars` file; it is already included in `.gitignore` to protect your private settings.

---

## Architecture Diagram

```
[scripts/run_all.sh]                      
        |                                 
        v                                 
[infra/main.tf]       ->   AWS VPC, Security Group, EC2 instance
        |                                 
        v                                 
[outputs.tf]     <--- Public IP ----------
        |                                 
        v                                 
[config/playbook.yml] -> SSH into EC2, install Java, download server.jar, configure systemd
        |                                 
        v                                 
     Minecraft Server running on port 25565
```

---

## Usage

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/minecraft-server-setup.git
   cd minecraft-server-setup
   ```

2. **Set environment variables** (replace with your values):

   ```bash
   export TF_VAR_key_name="minecraft_key"
   export TF_VAR_public_key_path="$HOME/.ssh/minecraft_key.pub"
   export AWS_ACCESS_KEY_ID="ASIA..."
   export AWS_SECRET_ACCESS_KEY="..."
   export AWS_SESSION_TOKEN="..."
   ```

3. **Run the automation**:

   ```bash
   ./scripts/run_all.sh
   ```

   - Terraform will create or update the VPC, Security Group, EC2 instance, and key pair.
   - The script captures the new public IP and injects it into `config/inventory.ini`.
   - Ansible configures the instance and starts the Minecraft service.

4. **Monitor output** for a final message:

   ```
   🎉  Server is ready at <PUBLIC_IP>:25565
   ```

---

## Connecting to the Server

- **Verify port**:
  ```bash
  nmap -sV -Pn -p25565 <PUBLIC_IP>
  ```
- **Minecraft client**: 
   - Open Minecraft
   - Select Multiplayer
   - Select Add Server
   - Input <PUBLIC_IP>:25565 into Server Address
   - Play on the Server

---

## Cleanup

To destroy all AWS resources and prepare for next run.:

   ```bash
   ./scripts/destroy_all.sh
   ```

---

## Repository Structure

```
/infra          Terraform code (main.tf, variables.tf, outputs.tf, terraform.tfvars)
/config         Ansible inventory & playbook (inventory.ini, playbook.yml)
/scripts        Orchestration & Destruction script (run_all.sh, destroy_all.sh)
/.gitignore     Files to ignore (state, keys, logs)
README.md       This documentation
```

---

## Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)
- [Minecraft Version Manifest API](https://launchermeta.mojang.com/mc/game/version_manifest.json)
- [AWS CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/)

