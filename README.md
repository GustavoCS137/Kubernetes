# Kubernetes — Demo do Seminário (CC5SDT)

Aplicação de demonstração para o seminário de **Kubernetes** da disciplina de **Sistemas Distribuídos (CC5SDT)** — **UTFPR Campus Santa Helena**, ministrada pelo **Prof. Rafael**.

**Integrantes:** Allan Finoketti e Gustavo Cristian dos Santos

---

## Arquivos do Projeto

- `meu-site.yaml`: Manifesto Kubernetes contendo:
  - **Deployment (`meu-site`)**: mantém `replicas: 3` com a imagem `nginx:1.27` (porta `80`).
  - **Service (`meu-site`)**: tipo `NodePort` (`30080`), expondo os Pods de forma estável por meio do seletor `app: meu-site`.
- `demo-comandos.sh`: Cola com todos os comandos da apresentação prontos para copiar e colar.

---

## Pré-requisitos (Cluster Local no Arch Linux)

Para rodar a demonstração localmente, você precisa de um runtime de contêineres (`docker`), do cliente `kubectl` e de uma ferramenta de cluster local (`kind` ou `minikube`).

### 1. Instalar as ferramentas

```bash
sudo pacman -S docker kubectl kind
# (alternativa ao kind: minikube)
```

### 2. Iniciar o Docker e criar o cluster

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
# (faça logout/login ou rode `newgrp docker` para usar o docker sem sudo)

kind create cluster --name seminario
kubectl get nodes
```

> **Dica:** Antes da apresentação, faça um pull prévio da imagem (`docker pull nginx:1.27` e `kind load docker-image nginx:1.27 --name seminario`) caso a internet da sala esteja lenta ou instável.

---

## Passo a Passo da Demo (Slide 8)

### 1. Aplicar o estado desejado (`replicas: 3`)

```bash
kubectl apply -f meu-site.yaml
kubectl get pods
```

### 2. Escalar para 5 réplicas

```bash
kubectl scale deployment meu-site --replicas=5
kubectl get pods
```

### 3. Demonstrar a autocorreção (loop de controle)

Apague um dos Pods listados e observe imediatamente o Kubernetes recriando outro para manter o estado desejado (`5` réplicas):

```bash
kubectl delete pod NOME_DO_POD
kubectl get pods
```

### 4. (Opcional) Acessar o Nginx via Service

```bash
kubectl port-forward svc/meu-site 8080:80
```

Acesse `http://localhost:8080` no navegador.

---

## Comandos Extras (Rolling Update e Rollback)

Para demonstrar atualização gradual sem derrubar a aplicação:

```bash
kubectl set image deployment/meu-site nginx=nginx:1.27-alpine
kubectl rollout status deployment/meu-site
kubectl rollout undo deployment/meu-site
```

---

## Limpeza

```bash
kubectl delete -f meu-site.yaml
# Para remover o cluster kind ao final:
# kind delete cluster --name seminario
```

---

## Referências

- Kubernetes: https://kubernetes.io/pt-br
- IBM. *O que é o Kubernetes?* https://www.ibm.com/br-pt/think/topics/kubernetes
- Netto et al. *Coordenação de Containers no Kubernetes*. SBRC, 2017
- AWS. *Documentação do EKS Anywhere*: https://anywhere.eks.amazonaws.com
- Burns et al. *Borg, Omega, and Kubernetes*. ACM Queue, 2016
