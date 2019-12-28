# -*- mode: ruby -*-
# vi: set ft=ruby :
#Vagrant.require_plugin "vagrant-reload"
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  NUM_WORKER_NODE = 2

  ############### ---------------------------------------------------- #############################

  config.vm.box = "hashicorp/bionic64"
  config.vm.box_check_update = false
  # Provision core-linux Node
  config.vm.define "master" do |node|
    node.vm.provider "hyperv" do |h|        
        h.memory = 2048
        h.cpus = 2
		h.vm_integration_services = {
			guest_service_interface: true			
		}
		h.vmname = "master"
    end
    node.vm.network "public_network", ip: "192.168.99.99", bridge: "k8s-Switch"
    node.vm.hostname = "master"    
    node.vm.network "forwarded_port", guest: 22, host: 2730
    node.vm.synced_folder ".", "/vagrant", disabled: true
    #node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
    #  s.args = ["enp0s8"]
    #end
    #node.vm.provision "shell", inline: "sudo rm /etc/netplan/1-netcfg.yaml -v"
    node.vm.provision "file", source: ".\\kubeadm\\01-netcfg.yaml", destination: "~/"
    node.vm.provision "file", source: ".\\kubeadm\\net.yaml", destination: "~/"
    node.vm.provision "shell", inline: "sudo mv -f /home/vagrant/01-netcfg.yaml /etc/netplan/ -v"
    node.vm.provision "shell", inline: "sudo netplan apply"    
    node.vm.provision :reload
    node.vm.provision "Running-Kubeadm", type: "shell", :path => "kubeadm/master.sh"  
    
    #node.vm.provision "shell", inline: "echo 'sudo kubectl apply -n kube-system -f /home/vagrant/net.yaml' | at now + 5 min"
    node.trigger.after :up do |trigger|          
          trigger.run = {inline: "scp -i .vagrant\\machines\\master\\hyperv\\private_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@192.168.99.99:/home/vagrant/joincluster.sh ./kubeadm/"}          
          trigger.run = {inline: "echo 'sudo kubectl apply -n kube-system -f /home/vagrant/net.yaml' | at now"}
    end
  end


  (1..NUM_WORKER_NODE).each do |i|
    
        config.vm.define "worker#{i}" do |node|
        IPADD = "\'sed 's/192.168.99.99/192.168.99.8#{i}/' ./kubeadm/01-netcfg.yaml \'"
        node.vm.provider "hyperv" do |h|        
            h.memory = 2048
            h.cpus = 2
        h.vm_integration_services = {
          guest_service_interface: true			
        }
        h.vmname = "worker#{i}"
        
        end
        node.trigger.before :up do |trigger|
          #trigger.run = {inline: "bash -c \'sed \'s\/192.168.99.99\/192.168.99.8#{i}\/\' ./kubeadm/01-netcfg.yaml > ./kubeadm-worker/01-netcfg.yaml\'"}
          trigger.run = {inline: "bash -c 'echo #{IPADD} | bash -c > ./kubeadm-worker/01-netcfg.yaml'"}
          #trigger.run = {inline: "#{IPADD}"}
        end
        node.vm.network "public_network", ip: "192.168.99.8#{i}", bridge: "k8s-Switch"
        node.vm.hostname = "worker#{i}"    
        node.vm.network "forwarded_port", guest: 22, host: "272#{i}"
        node.vm.synced_folder ".", "/vagrant", disabled: true
        node.vm.provision "file", source: ".\\kubeadm-worker\\01-netcfg.yaml", destination: "~/"
        node.vm.provision "shell", inline: "sudo mv -f /home/vagrant/01-netcfg.yaml /etc/netplan/ -v"
        node.vm.provision "shell", inline: "sudo netplan apply"    
        node.vm.provision "Running Worker#{i}", type: "shell", :path => "kubeadm-worker/worker.sh"
        node.vm.provision "Joining to cluster", type: "shell", :path => "kubeadm/joincluster.sh"          
      end
    end
  
end
