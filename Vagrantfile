# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

(1..3).each do |i|
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.provider :libvirt do |libvirt|
        libvirt.driver = "kvm"
        libvirt.memory = 8192
        libvirt.cpus = 4
    end
    config.vm.box = "generic/ubuntu2004"
    config.vm.box_version = "3.6.8"
    config.vm.provision:shell, inline: <<-SHELL
        sudo timedatectl set-timezone Europe/London
    SHELL

    config.vm.define "node#{i}" do |ubuntu|
        ubuntu.vm.hostname = "node#{i}"
    end

    config.vm.provision:shell, path: "bootstrap.sh"
end
end
