#!/bin/bash

# Update and Upgrade CentOS
sudo yum update -y
sudo yum upgrade -y

# Disable Swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Add Kernel Parameters
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload the changes
sudo sysctl --system

# Install Containerd Runtime
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y containerd.io

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Install Kubernetes Components: Add the Kubernetes signing key and repository.
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://pkgs.k8s.io/core/stable/v1.29/kubernetes.repo

# Update the package list and install kubelet, kubeadm, and kubectl.
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

# On each worker node, use the join command you got from the master node’s init output.

#kubeadm join "--"


