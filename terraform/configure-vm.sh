ip=$1
hostname=$2
type=$3
user=$4
pass=$5
promnt=$hostname'-> '

echo $promnt'======================================================'
echo $promnt'Setting OS...'
echo $promnt'======================================================'

echo $promnt'Update OS'
sudo dnf update -y

echo $promnt'time synchronization'
sudo timedatectl set-timezone America/Lima
sudo dnf install chrony -y
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo timedatectl set-ntp true

echo $promnt'Disable SELinux'
sudo sed -i s/=enforcing/=disabled/g /etc/selinux/config

echo $promnt'Install nfs dependencies'
sudo dnf install nfs-utils nfs4-acl-tools wget -y

sudo yum install dnf-plugins-core -y

echo $promnt'======================================================'
echo $promnt'Setting Machine' $hostname
echo $promnt'======================================================'
echo $hostname

echo $promnt'======================================================'
echo $promnt'Install Requeriments'
echo $promnt'======================================================'

echo $promnt'Authorize id_rsa'
sudo chmod 400 .ssh/id_rsa

echo $promnt'Install epel-release'
echo $pass | sudo -S yum install epel-release -y

echo $promnt'Install python 2'
sudo dnf install python2 -y

echo $promnt'Install python 3'
sudo dnf install -y python3 -y

echo $promnt'Install ansible'
sudo yum install ansible -y

echo $promnt'======================================================'
echo $promnt'Setting hosts...'
echo $promnt'======================================================'

echo $promnt'Configure /etc/hosts'
sudo -- sh -c "echo '
10.0.1.9   configurator-host      configurator-host
10.0.1.10   k8s-c8-master      k8s-c8-master
10.0.1.11   k8s-c8-node01      k8s-c8-node01
10.0.1.12   k8s-c8-node02      k8s-c8-node02
10.0.1.15   k8s-c8-nfs      k8s-c8-nfs
' >> /etc/hosts"

echo $promnt'======================================================'
echo $promnt'Setting SSH...'
echo $promnt'======================================================'

echo $promnt'Blank /root/.ssh/authorized_keys'
sudo -- sh -c "cat /dev/null > /root/.ssh/authorized_keys"

echo $promnt'Configure /root/.ssh/authorized_keys'
sudo -- sh -c "cat .ssh/id_rsa.pub >> /root/.ssh/authorized_keys"

echo $promnt'Configure ~/.ssh/authorized_keys'
sudo cat /home/$user/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo $promnt'Configure /etc/ssh/ssh_config'
sudo -- sh -c "echo '
Host *
    StrictHostKeyChecking no' >> /etc/ssh/ssh_config"

echo $promnt'======================================================'
echo $promnt'Setting Ansible...'
echo $promnt'======================================================'

echo $promnt'Configure /etc/ansible/hosts'
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

echo $promnt'======================================================'
echo $promnt'Get repo for ansible...'
echo $promnt'======================================================'

echo $promnt'Clone Repo'
Sudo git clone https://github.com/Scorpius86/devops-unir.git