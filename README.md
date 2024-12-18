# Infraestrutura EKS e Online Boutique - Documentação Completa
## 1. Diagrama de Arquitetura
A arquitetura da solução é baseada na infraestrutura em AWS provisionada via Terraform e no deployment de microsserviços no Kubernetes (EKS).

### Componentes Principais
1. AWS EKS:

Cluster gerenciado para hospedar os microsserviços da aplicação Online Boutique.
* Configurado com integração com IAM para controle de acesso.

2. S3 Backend:

Utilizado para armazenar o estado do Terraform (remote state).
* Protegido com versionamento e prevent_destroy.

3. DynamoDB:

* Utilizado como lock table para evitar race conditions no estado do Terraform.

4. RDS PostgreSQL:

Banco de dados utilizado pela aplicação.
* Configurado em subnets privadas com backups automáticos.

5. AWS IAM:

* Controle de acesso configurado com políticas específicas para o EKS.

6. ArgoCD e CI/CD:

* Pipeline configurada no GitHub Actions para deploy automatizado.
* Suporte a rollback em caso de falha.

1.0 Estrutura de Diretórios
A estrutura do projeto está organizada conforme a seguinte hierarquia:


````
online-boutique-infra/
├── terraform/                           # Arquivos de Terraform para provisionamento da infraestrutura
│   ├── main.tf                          # Arquivo principal do Terraform
│   ├── variables.tf                     # Declaração de variáveis
│   ├── outputs.tf                       # Outputs dos recursos criados
│   ├── providers.tf                     # Configuração dos providers (AWS)
│   ├── backend.tf                       # Configuração do backend remoto
│   ├── tfplan                           # Arquivo gerado pelo terraform plan
│   ├── modules/                         # Módulos reutilizáveis do Terraform
│   │   ├── eks/                         # Módulo EKS
│   │   │   ├── main.tf                  # Código para provisionamento do EKS
│   │   │   ├── variables.tf             # Variáveis do módulo EKS
│   │   │   ├── outputs.tf               # Outputs do módulo EKS
│   │   ├── rds/                         # Módulo RDS
│   │   │   ├── main.tf                  # Código para provisionamento do RDS
│   │   │   ├── variables.tf             # Variáveis do módulo RDS
│   │   │   ├── outputs.tf               # Outputs do módulo RDS
│   │   ├── s3_backend/                  # Módulo S3 e DynamoDB para estado remoto
│   │   │   ├── main.tf                  # Código para provisionamento do S3 e DynamoDB
│   │   │   ├── variables.tf             # Variáveis do módulo
│   └── environments/                    # Variáveis para ambientes específicos (dev, staging, prod)
│       ├── dev.tfvars                   # Configurações para ambiente dev
│       ├── staging.tfvars               # Configurações para ambiente staging
│       └── prod.tfvars                  # Configurações para ambiente prod
├── kubernetes-manifests/                # Manifests Kubernetes
│   ├── deployment/                      # Configuração dos deployments
│   │   ├── frontend.yaml                # Deployment do frontend
│   │   ├── cartservice.yaml             # Deployment do cartservice
│   │   ├── recommendationservice.yaml   # Deployment do recommendationservice
│   │   └── ...                          # Outros serviços
│   ├── istio/                           # Configurações do Istio
│   │   ├── frontend-gateway.yaml        # Gateway do Istio
│   │   └── allow-egress-googleapis.yaml # Políticas de egress do Istio
│   ├── kustomization.yaml               # Configuração Kustomize
│   └── secrets/                         # Segredos para a aplicação
├── ci-cd/                               # Pipeline CI/CD
│   ├── github-actions/                  # Configurações do GitHub Actions
│   │   └── deploy.yaml                  # Pipeline para deploy no EKS
├── README.md                            # Documentação principal
└── diagrams/                            # Diagramas de arquitetura
    └── architecture-diagram.png         # Diagrama visual da solução
````
# 1. Guia de Operações

## 2.1 Deploy Completo da Infraestrutura

### Para realizar um deploy completo da infraestrutura, siga os passos abaixo:

Clone o Repositório:
````

git clone <seu-repositorio-git>
cd <diretorio-projeto>

````
Configurar Credenciais AWS:

````

aws configure
````
Inicializar o Terraform:

````

cd terraform
terraform init
````
Validar o Código:

````

terraform validate
````
Gerar e Aplicar o Plano:

````

terraform plan -out=tfplan
terraform apply tfplan
````
Atualizar Configuração do Kubeconfig:

````

aws eks update-kubeconfig --name online-boutique-eks --region us-west-2

````
Verificar o Cluster EKS:

````

kubectl get nodes
````
Aplicar os Manifests Kubernetes:

````

kubectl apply -k ./kubernetes-manifests
````
2.2 Rollback

Rollback de um Deployment no Kubernetes

Listar os Deployments e suas Revisões:

````

kubectl rollout history deployment frontend
````
Executar o Rollback:

````

kubectl rollout undo deployment frontend --to-revision=<REVISION>
````
Verificar o Status do Rollback:

````

kubectl get pods
````
## 2.3 Recuperação de Desastres

Cenário: Falha no RDS

1. Restaurar Backup:

* Acesse o console do AWS RDS.
* Identifique o snapshot mais recente e inicie a restauração.
2. Atualizar a Aplicação:

* Atualize a aplicação para apontar para o novo endpoint do banco.
* Execute os comandos necessários para garantir a integridade dos dados.
  3. Verificar a Aplicação:
   
   

## 3. Relatório de Segurança
### Medidas Implementadas

1. IAM com Least Privilege:

* Usuário IAM dev com permissões mínimas necessárias.
2. AWS S3 e DynamoDB:

* Versionamento ativado no S3 para proteção do estado do Terraform.
* prevent_destroy habilitado em recursos críticos.

3. RDS:

* Subnets privadas para evitar acesso público.
* Backups automáticos configurados.

4. EKS Security Groups:

* Regras de ingress configuradas com restrições IP.

5. Kubernetes RBAC:

* Controle de acesso configurado via aws-auth.

## 4. Possíveis Melhorias Futuras
1. Implementação de WAF:

* Proteger o tráfego HTTP/HTTPS.

2. Monitoramento Centralizado:

* Stack Prometheus e Grafana para monitoramento.

3. Segredos Centralizados:

* Implementar AWS Secrets Manager ou HashiCorp Vault.

4. Autoscaling Avançado:

* Configurar escalabilidade automática dos nós do EKS.

## 5. Conclusão
A infraestrutura foi provisionada de forma robusta, automatizada e segura, utilizando Terraform e AWS. O cluster EKS hospeda a aplicação Online Boutique, garantindo alta disponibilidade e escalabilidade com suporte a CI/CD.