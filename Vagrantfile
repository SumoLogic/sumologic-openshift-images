# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/mantic64'
  config.disksize.size = '50GB'
  config.vm.box_check_update = false
  config.vm.host_name = 'sumologic-openshift-images'
  config.vm.network :private_network, ip: "192.168.78.71"

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.cpus = 8
    vb.memory = 16384
    vb.name = 'sumologic-openshift-images'
  end

  config.vm.provision 'shell', path: 'vagrant/provision.sh'
  config.vm.synced_folder ".", "/sumologic"
end
