ip=$1
hostname=$2
type=$3
user=$4
pass=$5
prompt=$hostname'-> '

echo $prompt'======================================================'
echo $prompt'Setting OS...'
echo $prompt'======================================================'

#echo $prompt'Update OS'
#sudo dnf update -y

echo $prompt'time synchronization'
sudo timedatectl set-timezone America/Lima
sudo dnf install chrony -y
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo timedatectl set-ntp true

echo $prompt'Disable SELinux'
sudo sed -i s/=enforcing/=disabled/g /etc/selinux/config

echo $prompt'Install nfs dependencies'
sudo dnf install nfs-utils nfs4-acl-tools wget -y
sudo yum install dnf-plugins-core -y

echo $prompt'Install Git'
sudo yum install git -y

echo $prompt'======================================================'
echo $prompt'Setting Machine' $hostname
echo $prompt'======================================================'
echo $hostname

echo $prompt'======================================================'
echo $prompt'Install Requeriments'
echo $prompt'======================================================'

echo $prompt'Authorize id_rsa'
sudo chmod 400 .ssh/id_rsa

echo $prompt'Install epel-release'
echo $pass | sudo -S yum install epel-release -y

echo $prompt'Install python 2'
sudo dnf install python2 -y

echo $prompt'Install python 3'
sudo dnf install -y python3 -y

echo $prompt'Install ansible'
sudo yum install ansible -y

echo $prompt'======================================================'
echo $prompt'Setting hosts...'
echo $prompt'======================================================'

echo $prompt'Configure /etc/hosts'
sudo -- sh -c "echo '
10.0.1.9   configurator-host      configurator-host
10.0.1.10   k8s-c8-master      k8s-c8-master
10.0.1.11   k8s-c8-node01      k8s-c8-node01
10.0.1.12   k8s-c8-node02      k8s-c8-node02
10.0.1.15   k8s-c8-nfs      k8s-c8-nfs
' >> /etc/hosts"

echo $prompt'======================================================'
echo $prompt'Setting SSH...'
echo $prompt'======================================================'

echo $prompt'Blank /root/.ssh/authorized_keys'
sudo -- sh -c "cat /dev/null > /root/.ssh/authorized_keys"

echo $prompt'Configure /root/.ssh/authorized_keys'
sudo -- sh -c "cat .ssh/id_rsa.pub >> /root/.ssh/authorized_keys"

echo $prompt'Configure ~/.ssh/authorized_keys'
sudo cat /home/$user/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo $prompt'Configure /etc/ssh/ssh_config'
sudo -- sh -c "echo '
Host *
    StrictHostKeyChecking no' >> /etc/ssh/ssh_config"

echo $prompt'======================================================'
echo $prompt'Setting Ansible...'
echo $prompt'======================================================'

echo $prompt'Configure /etc/ansible/hosts'
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

[cluster]
k8s-c8-master ansible_user=root
k8s-c8-node01 ansible_user=root
k8s-c8-node02 ansible_user=root
' >> /etc/ansible/hosts"

echo $prompt'======================================================'
echo $prompt'Get repo for ansible...'
echo $prompt'======================================================'

echo $prompt'Clone Repo'
git clone https://github.com/Scorpius86/devops-unir.git

echo $prompt'======================================================'
echo $prompt'Install and enable Firewall...'
echo $prompt'======================================================'

echo $prompt'Install firewalld'
sudo dnf install firewalld -y

echo $prompt'Enable firewalld'
sudo systemctl enable firewalld

echo $prompt'Start firewalld'
sudo systemctl start firewalld

echo $prompt'Check firewalld'
sudo firewall-cmd --state