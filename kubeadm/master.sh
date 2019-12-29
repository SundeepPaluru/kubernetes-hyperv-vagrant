#!/bin/bash

echo "[Task1]Installing Docker on Master Node"
sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y docker.io curl apt-transport-https powerline > /dev/null 2>&1

echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.99.99   master
192.168.99.99   localhost
192.168.99.81   worker1
192.168.99.82   worker2
EOF
gpasswd -a vagrant root
sudo swapoff -a
sudo systemctl enable docker > /dev/null 2>&1
sudo systemctl start docker > /dev/null 2>&1

echo "[Task2]Installing Kubernetes on Master Node"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add > /dev/null 2>&1
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /dev/null 2>&1
sudo apt update > /dev/null 2>&1
sudo apt-get install -y kubeadm kubelet kubectl --allow-change-held-packages> /dev/null 2>&1
sudo apt-mark hold kubeadm kubelet kubectl > /dev/null 2>&1
sleep 5
sudo systemctl enable kubelet >/dev/null 2>&1
sudo echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' > sudo /usr/bin/kubelet
sudo systemctl start kubelet >/dev/null 2>&1
echo $(kubectl version --short --client)
echo "Waiting for 10 Sec's"
sleep 10

echo "[Task3]Initializing Kubernetes cluster on Master Node"
#sudo kubeadm init --apiserver-advertise-address 192.168.99.1 --service-dns-domain flyingspear.com --pod-network-cidr 10.244.0.0/16 --service-cidr 10.20.0.0/16 > /dev/null 2>&1
sudo kubeadm init --apiserver-advertise-address 192.168.99.99 --pod-network-cidr=10.244.0.0/16 --service-dns-domain flyingspear.com --ignore-preflight-errors=all >> /home/vagrant/kubeinit.log 2>&1
sleep 60
sudo mkdir -p /home/vagrant/.kube
sudo cp -i -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id vagrant -u):$(id vagrant -g) /home/vagrant/.kube/config
sudo swapoff -a
sleep 30
joinCommand=$(kubeadm token create --print-join-command 2>/dev/null)
echo "$joinCommand --ignore-preflight-errors=all" > /home/vagrant/joincluster.sh
