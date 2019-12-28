#!/bin/bash

echo "[TASK 1]Installing Docker on Master Node"
sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y docker.io curl apt-transport-https  > /dev/null 2>&1

echo "[TASK 2] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.99.99   master
192.168.99.81   worker1
192.168.99.82   worker2
EOF
sudo swapoff -a
sudo systemctl enable docker > /dev/null 2>&1
sudo systemctl start docker > /dev/null 2>&1

echo "[TASK 3]Installing Kubernetes on Master Node"
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
