# kubernetes-hyperv-vagrant
Install Kubernetes on Hyper-V using Vagrant

# Hardware Specs:
Make sure you have atleast 6GB RAM, To Run 1 Master and 2 Worker Nodes

# Pre-Requsites:
1) Make sure Hyper-V is enabled on your machine.
2) Make sure Powershell & GIT is installed on your machine
3) Make sure Vagrant Version: 2.2.6 is installed on your machine

# Step By Step Instructions:
1) Create a Folder <NewFolder>
2) git clone https://github.com/SundeepPaluru/kubernetes-hyperv-vagrant.git .
3) Run PowerShell as administrator
4) CD towards Cloned Folder
5) Run Deploy-K8s.ps1 Script
  Note: In case if you face script exectution error. Run following command Set-ExecutionPolicy -ExecutionPolicy Unrestricted, and than try running the script.
  
# Post VM Build
1) Login to Master Node using "Vagrant ssh master"
2) In shell prompt Run "sudo kubectl apply -n kube-system -f /home/vagrant/net.yaml' | at now"


# Network graph
                  +-------------------+
                  |    External       |
                  |  Network/Internet |
                  +-------------------+
                           |
                           |
             +-------------+--------------+
             |        Host Machine        |
             |     (Internet Connection)  |
             +-------------+--------------+
                           |
                           | NAT
             +-------------+--------------+
             |    K8s-NATNetwork          |
             |    192.168.99.0/24         |
             +-------------+--------------+
                           |
                           |
             +-------------+--------------+
             |     k8s-Switch (Internal)  |
             |       192.168.99.1/24      |
             +-------------+--------------+
                  |        |        |
                  |        |        |
          +-------+--+ +---+----+ +-+-------+
          |  Master  | | Worker | | Worker  |
          |   Node   | | Node 1 | | Node 2  |
          |192.168.99| |192.168.| |192.168. |
          |   .99    | | 99.81  | | 99.82   |
          +----------+ +--------+ +---------+
This network graph shows:

1. The host machine connected to the external network/internet.
2. The NAT network (K8s-NATNetwork) providing a bridge between the internal network and the external network.
3. The internal Hyper-V switch (k8s-Switch) connecting all the Kubernetes nodes.
4. The master node and two worker nodes, each with their specific IP addresses, all connected to the internal switch.