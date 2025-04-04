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
  #install kubectl
  	sudo apt-get update
  # apt-transport-https may be a dummy package; if so, you can skip that package
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
  # If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
  # sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
  # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
  sudo apt-get update
  sudo apt-get install -y kubectl
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

# Review
function generate_cluster() {
  cd ../terraform-cluster/
  terraform init
  terraform apply --auto-approve -var-file=aws_output.json
}

# Review
function rke_up() {
  
  cd ../terraform-cluster/
  sudo mkdir -p ~/.kube
  terraform output -raw kube_config > /tmp/kube_config_cluster.yml
  sudo mv /tmp/kube_config_cluster.yml ~/.kube/config
  kubectl get nodes
}

function create_local_storage() {
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
}

function install_helm() {
  cd ../../helm
  wget https://get.helm.sh/helm-v3.17.2-linux-amd64.tar.gz
  tar zxf helm-v3.17.2-linux-amd64.tar.gz
  cd linux-amd64
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
deploy_app