#cd .\k8s\terraform
#terraform init .\k8s\terraform
#terraform apply --auto-approve
#cd ..\..\

#ssh-keygen -R vmip-configurator-host-publicip.westeurope.cloudapp.azure.com
#ssh -o StrictHostKeyChecking=no -I .\k8s\terraform\id_rsa adminUser@vmip-configurator-host-publicip.westeurope.cloudapp.azure.com ansible-playbook -l all devops-unir/k8s/ansible/00-run-all.yaml

#echo "Configure ip master on host"
#Set-Variable -Name "ipMaster" -Value $(az vm show -d -g kubernetes_rg -n k8s-c8-master --query publicIps -o tsv)
#.\Set-HostsEntry -IPAddress $ipMaster -HostName "game.bar" -Path "C:\Windows\System32\drivers\etc\hosts"

Set-Variable -Name "nodePort" -Value $(ssh -o StrictHostKeyChecking=no -I .\k8s\terraform\id_rsa adminUser@vmip-configurator-host-publicip.westeurope.cloudapp.azure.com "kubectl get svc -n=haproxy-controller -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{""""\n""""}}{{end}}{{end}}{{end}}'").Split("\n")[0]
Set-Variable -Name "urlGame" -Value "http://game.bar:$nodePort"

echo "####################################################"
echo "## Test url = http://game.bar:$nodePort               ##"
echo "####################################################"