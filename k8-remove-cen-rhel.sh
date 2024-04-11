#completely remove kubernetes in  centos/RHEL
#!/bin/sh
# Kube Admin Reset
kubeadm reset 
sudo yum remove -y kubeadm kubectl kubelet kubernetes-cni kube* 
sudo rm -rf ~/.kube
sudo rm $(which kubectl)

#----------------------------------------------------------------------------------------------

# Remove docker containers/ images ( optional if using docker)
sudo systemctl stop docker
sudo systemctl disable docker
sudo yum remove -y docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker

#---------------------------------------------------------------------------------------------------------------------

# Removing Containerd
sudo systemctl stop containerd
sudo systemctl disable containerd
sudo yum remove -y containerd.io
sudo rm -rf /etc/containerd

#------------------------------------------------------------------------------------------------------------------
# Remove parts

sudo yum autoremove -y
# Delete docker group (optional)
sudo groupdel docker

# Clear the iptables
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X
iptables -t raw -F &&
