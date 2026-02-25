# =====================================================
# VPC - Rede Virtual Privada
# =====================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# =====================================================
# Internet Gateway - Acesso à Internet
# =====================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# =====================================================
# Subnet Pública
# =====================================================

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet-publica"
  }
}

# =====================================================
# Tabela de Rotas - Roteamento para Internet
# =====================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-rt-publica"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# =====================================================
# Security Group - Firewall Virtual
# =====================================================

resource "aws_security_group" "app" {
  name        = "${var.project_name}-sg"
  description = "Security Group para a aplicacao DevOps Fase 1"
  vpc_id      = aws_vpc.main.id

  # SSH (porta 22)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP (porta 80)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Aplicação Node.js (porta 3000)
  ingress {
    description = "App Node.js"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tráfego de saída (todo permitido)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# =====================================================
# AMI - Imagem Ubuntu mais recente
# =====================================================

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# =====================================================
# EC2 Instance - Servidor da Aplicação
# =====================================================

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Atualizar pacotes
    apt-get update -y
    apt-get upgrade -y

    # Instalar Node.js 20
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs git

    # Criar diretório da aplicação
    mkdir -p /opt/app
    cd /opt/app

    # Clonar o repositório (substituir pelo seu repositório)
    # git clone https://github.com/SEU-USUARIO/devops-projeto-fase1.git .
    # npm install --production
    # npm start

    echo "Servidor provisionado com sucesso!" > /opt/app/status.txt
  EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}
