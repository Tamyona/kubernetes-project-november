#!/bin/bash

function destroy() {
    cd /home/ubuntu/kubernetes-project-november/helm
    terraform destroy --auto-approve

    cd ../cluster/terraform-cluster
    terraform destroy --auto-approve

    cd ../terraform
    terraform destroy --auto-approve
}

destroy