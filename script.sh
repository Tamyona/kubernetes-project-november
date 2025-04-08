#!/bin/bash

function prep_bastion() {
  sudo apt update
  sudo apt install ansible -y
  if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]
  then 
  wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  fi
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform
}

function create_instances() {
  cd cluster/terraform
  terraform init
  terraform apply --auto-approve
}

function ansible() {
  cd ../ansible
  ansible-playbook main.yml 
}

function generate_cluster() {
  cd ../terraform-cluster/
  terraform init
  terraform apply --auto-approve

  cd ../terraform-cluster/
  sudo mkdir -p ~/.kube
  terraform output -raw kube_config > /tmp/kube_config_cluster.yml
  sudo mv /tmp/kube_config_cluster.yml ~/.kube/config
  kubectl get nodes
}

function create_local_storage() {
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
  kubectl patch storageclass local-path -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class":"true"}}}'
}

function install_helm() {
  cd ../../helm
  wget https://get.helm.sh/helm-v3.17.2-linux-amd64.tar.gz
  tar zxf helm-v3.17.2-linux-amd64.tar.gz
  sudo mv linux-amd64/helm /usr/local/bin
  rm -rf linux-amd64 helm-v3.17.2-linux-amd64.tar.gz 
}

function deploy_app() {
  terraform init
  terraform apply --auto-approve
}

prep_bastion
create_instances
sleep 15
ansible
generate_cluster
rke_up
create_local_storage
install_helm
deploy_app