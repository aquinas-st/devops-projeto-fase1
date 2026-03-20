#!/bin/bash
set -e

APP_NAME="devops-app"
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="339712713340"
ECR_REPO="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-projeto-fase1"
IMAGE_NAME="$ECR_REPO:latest"
HEALTH_URL="http://localhost:3000/health"

echo "=== Iniciando deploy ==="

# 1. Login no ECR
echo "Fazendo login no ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# 2. Baixar imagem mais recente
echo "Baixando imagem..."
docker pull $IMAGE_NAME

# 3. Parar container antigo (se existir)
if docker ps -q -f name=$APP_NAME | grep -q .; then
    echo "Parando container antigo..."
    docker stop $APP_NAME
    docker rm $APP_NAME
fi

# 4. Iniciar novo container
echo "Iniciando novo container..."
docker run -d \
    --name $APP_NAME \
    -p 3000:3000 \
    -e NODE_ENV=production \
    --restart unless-stopped \
    $IMAGE_NAME

# 5. Health check
echo "Aguardando aplicação iniciar..."
sleep 5

for i in $(seq 1 5); do
    if wget --spider --quiet $HEALTH_URL 2>/dev/null; then
        echo "Deploy concluído com sucesso!"
        exit 0
    fi
    echo "Tentativa $i/5 - aguardando..."
    sleep 3
done

# 6. Rollback em caso de falha
echo "ERRO: Health check falhou. Realizando rollback..."
docker stop $APP_NAME
docker rm $APP_NAME
echo "Deploy falhou. Verifique os logs com: docker logs $APP_NAME"
exit 1