ip=$1
hostname=$2
type=$3
user=$4
pass=$5

echo '======================================================'
echo 'Setting Machine' $hostname
echo '======================================================'
echo $hostname

echo '======================================================'
echo 'Install Requeriments'
echo '======================================================'

sudo chmod 400 .ssh/id_rsa
echo $pass | sudo -S yum install epel-release -y
sudo dnf install python2 -y
sudo dnf install -y python3 -y
sudo yum install ansible -y

echo '======================================================'
echo 'Setting hosts...'
echo '======================================================'

sudo -- sh -c "echo '
10.0.1.9   configurator-host      configurator-host
10.0.1.10   k8s-c8-master      k8s-c8-master
10.0.1.11   k8s-c8-node01      k8s-c8-node01
10.0.1.12   k8s-c8-node02      k8s-c8-node02
10.0.1.15   k8s-c8-nfs      k8s-c8-nfs
' >> /etc/hosts"

echo '======================================================'
echo 'Setting SSH...'
echo '======================================================'

sudo -- sh -c "cat /dev/null > /root/.ssh/authorized_keys"
sudo -- sh -c "cat .ssh/id_rsa.pub >> /root/.ssh/authorized_keys"

sudo cat /home/$user/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo -- sh -c "echo '
Host *
    StrictHostKeyChecking no' >> /etc/ssh/ssh_config"

echo '======================================================'
echo 'Setting Ansible...'
echo '======================================================'

sudo -- sh -c "sudo echo '
[configurator-host]
configurator-host ansible_user=root

[k8s-c8-master]
k8s-c8-master ansible_user=root

[k8s-c8-node01]
k8s-c8-node01 ansible_user=root

[k8s-c8-node02]
k8s-c8-node02 ansible_user=root

[haproxy]
k8s-c8-master ansible_user=root

[nfs]
k8s-c8-nfs ansible_user=root

[master]
k8s-c8-master ansible_user=root

[node]
k8s-c8-node01 ansible_user=root
k8s-c8-node02 ansible_user=root
' >> /etc/ansible/hosts"