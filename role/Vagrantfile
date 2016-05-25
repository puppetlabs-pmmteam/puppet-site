# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-7.0-64-puppet"
  config.vm.hostname = "puppet"
  config.vm.synced_folder './', '/etc/puppet/modules/role'
  config.vm.network :private_network, type: "dhcp"
  config.vm.provision :shell, inline: 'iptables -F'
end
