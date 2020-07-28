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
