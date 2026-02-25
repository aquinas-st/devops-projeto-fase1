# DevOps na Prática - Fase 1

**Configuração e Automação Inicial**

Projeto da disciplina de DevOps na Prática — PUCRS Online.

## Sobre o Projeto

API REST desenvolvida em Node.js/Express para demonstrar práticas de DevOps, incluindo Integração Contínua (CI) com GitHub Actions e Infraestrutura como Código (IaC) com Terraform na AWS.

## Tecnologias

| Tecnologia     | Finalidade                  |
|----------------|-----------------------------|
| Node.js 20     | Runtime da aplicação        |
| Express        | Framework web               |
| Jest           | Testes unitários            |
| ESLint         | Análise estática de código  |
| GitHub Actions | Pipeline de CI              |
| Terraform      | Infraestrutura como Código  |
| AWS            | Provedor de nuvem           |

## Estrutura do Projeto

```
devops-projeto-fase1/
├── .github/workflows/ci.yml   # Pipeline de CI
├── src/app.js                  # Aplicação Express
├── tests/app.test.js           # Testes unitários
├── terraform/
│   ├── provider.tf             # Configuração do provider AWS
│   ├── main.tf                 # Recursos (VPC, EC2, SG)
│   ├── variables.tf            # Variáveis de entrada
│   └── outputs.tf              # Outputs da infraestrutura
├── package.json
├── .eslintrc.js
├── .gitignore
└── README.md
```

## Como Executar Localmente

```bash
# Instalar dependências
npm install

# Iniciar o servidor
npm start

# Executar testes
npm test

# Executar lint
npm run lint
```

A aplicação estará disponível em `http://localhost:3000`.

## Endpoints da API

| Método | Rota          | Descrição                        |
|--------|---------------|----------------------------------|
| GET    | /             | Informações do projeto           |
| GET    | /health       | Health check                     |
| GET    | /info         | Tecnologias utilizadas           |
| GET    | /tarefas      | Lista todas as tarefas           |
| GET    | /tarefas/:id  | Busca tarefa por ID              |
| POST   | /tarefas      | Cria nova tarefa                 |

## Pipeline de CI

O pipeline é executado automaticamente a cada push na branch `main` ou abertura de Pull Request.

**Etapas:**
1. Checkout do código
2. Setup Node.js 20
3. Instalação de dependências (`npm ci`)
4. Lint (`eslint`)
5. Testes unitários (`jest`)
6. Build

## Infraestrutura (Terraform)

A infraestrutura na AWS inclui:

- **VPC** — Rede virtual isolada (10.0.0.0/16)
- **Subnet Pública** — Sub-rede com acesso à internet (10.0.1.0/24)
- **Internet Gateway** — Conectividade com a internet
- **Security Group** — Portas 22 (SSH), 80 (HTTP), 3000 (App)
- **EC2 Instance** — t2.micro com Ubuntu 24.04 LTS

### Como usar o Terraform

```bash
cd terraform

# Inicializar o Terraform
terraform init

# Ver o plano de execução
terraform plan

# Aplicar a infraestrutura
terraform apply

# Destruir a infraestrutura
terraform destroy
```

> **Importante:** Configure suas credenciais AWS antes de executar (`aws configure` ou variáveis de ambiente).

## Autor

[Seu Nome] — PUCRS Online — 2026
