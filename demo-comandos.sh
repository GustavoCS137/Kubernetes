#!/usr/bin/env bash
# ==============================================================================
# Cola de comandos para a Demo - Seminário Kubernetes (Slide 8)
# CC5SDT - Sistemas Distribuídos | Gustavo Cristian dos Santos
# ==============================================================================
# Dica: copie e cole bloco por bloco no terminal durante a apresentação.

# ------------------------------------------------------------------------------
# 0. Pré-check antes da apresentação (garantir que o cluster está de pé)
# ------------------------------------------------------------------------------
kubectl get nodes

# ------------------------------------------------------------------------------
# 1. Aplicar o estado desejado (Deployment com 3 réplicas + Service)
# ------------------------------------------------------------------------------
kubectl apply -f meu-site.yaml
kubectl get pods
kubectl get svc meu-site

# Acessar o painel web no navegador (abra em outro terminal e deixe rodando):
#   kubectl port-forward svc/meu-site 8080:80
#   Depois acesse http://localhost:8080 (você verá os Pods e o botão "Encerrar Pod")

# ------------------------------------------------------------------------------
# 2. Escalar para 5 réplicas
# ------------------------------------------------------------------------------
kubectl scale deployment meu-site --replicas=5
kubectl get pods

# ------------------------------------------------------------------------------
# 3. Autocorreção (apagar um Pod e ver o Kubernetes recriando sozinho)
# ------------------------------------------------------------------------------
# Opção A (manual - copie o nome de um pod do comando anterior):
# kubectl delete pod NOME_DO_POD

# Opção B (automático - apaga o primeiro pod da lista):
kubectl delete pod "$(kubectl get pods -l app=meu-site -o jsonpath='{.items[0].metadata.name}')"
kubectl get pods

# ------------------------------------------------------------------------------
# Extras (se sobrar tempo - Perguntas: Rolling Update e Rollback)
# ------------------------------------------------------------------------------
# Atualizar a versão sem derrubar o sistema (acompanhe no painel web e no terminal):
kubectl set env deployment/meu-site APP_VERSION=v2
kubectl rollout status deployment/meu-site

# Voltar para a versão anterior (rollback):
kubectl rollout undo deployment/meu-site
kubectl get pods

# ------------------------------------------------------------------------------
# Limpeza após a apresentação
# ------------------------------------------------------------------------------
kubectl delete -f meu-site.yaml
