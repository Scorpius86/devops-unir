cd .\k8s\terraform
terraform init .\k8s\terraform
terraform apply --auto-approve
cd ..\..\

ssh -I .\k8s\terraform\id_rsa adminUser@vmip-configurator-host-publicip.westeurope.cloudapp.azure.com ansible-playbook -l all devops-unir/k8s/ansible/00-run-all.yaml

Set-Variable -Name "ipMaster" -Value $(az vm show -d -g kubernetes_rg_test -n k8s-c8-master --query publicIps -o tsv)
.\Set-HostsEntry -IPAddress $ipMaster -HostName "game.bar" -Path "C:\Windows\System32\drivers\etc\hosts"

ssh -I .\k8s\terraform\id_rsa adminUser@vmip-configurator-host-publicip.westeurope.cloudapp.azure.com 
