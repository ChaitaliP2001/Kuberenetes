#completely remove kubernetes in ubuntu
#!/bin/sh
# Kube Admin Reset
kubeadm reset 
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube* 
apt remove -y kubeadm kubectl kubelet kubernetes-cni 
sudo apt-get autoremove
sudo rm -rf ~/.kube
sudo rm $(which kubectl)

#----------------------------------------------------------------------------------------------

# Remove docker containers/ images ( optional if using docker)
sudo systemctl stop docker
sudo systemctl disable docker
sudo apt-get remove --purge -y docker docker.io docker-ce docker-ce-cli
docker image prune -a
systemctl restart docker
apt purge -y docker-engine docker docker.io docker-ce docker-ce-cli containerd containerd.io runc --allow-change-held-packages

#---------------------------------------------------------------------------------------------------------------------

#Removing Containerd
sudo systemctl stop containerd
sudo systemctl disable containerd
sudo apt-get remove --purge containerd
sudo apt-get purge containerd -y 
sudo rm -rf /etc/containerd
sudo apt-get update -y 
sudo rm $(which containerd)
#------------------------------------------------------------------------------------------------------------------
# Remove parts

apt autoremove -y
# Delete docker group (optional)
groupdel docker

# Clear the iptables
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X
iptables -t raw -F && iptables -t raw -X
iptables -t mangle -F && iptables -t mangle -X