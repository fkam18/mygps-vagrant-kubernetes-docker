#!/bin/bash
# Bootstrap machine

ensure_netplan_apply() {
    # First node up assign dhcp IP for eth1, not base on netplan yml
    sleep 5
    sudo netplan apply
}

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

resolve_dns() {
    step "===== Create symlink to /run/systemd/resolve/resolv.conf ====="
    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

install_docker() {
    step "===== Installing docker ====="
    sudo apt update
#    sudo apt-get -y  remove docker docker-engine docker-compose docker.io containerd runc
    sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
#    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
#    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    if [ $? -ne 0 ]; then
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    fi
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update -y
#    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
#    sudo groupadd docker
#    sudo gpasswd -a $USER docker
#    sudo chmod 777 /var/run/docker.sock
    # Add vagrant to docker group
#    sudo groupadd docker
#    sudo gpasswd -a vagrant docker
    # Setup docker daemon host
    # Read more about docker daemon https://docs.docker.com/engine/reference/commandline/dockerd/
    sudo usermod -aG docker $USER && newgrp docker
#    sed -i 's/ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/192.168.121.210/g' /lib/systemd/system/docker.service
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

install_openssh() {
    step "===== Installing openssh ====="
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y openssh-server
    sudo systemctl enable ssh
}

install_tools() {
#    sudo apt install -y python-pip
#    sudo apt install -y default-jre
    sudo apt install -y net-tools
#	pip install kafka --user
#	pip install kafka-python --user
}

install_microk8s() {
  sudo snap install microk8s --classic --channel=1.23/stable
  sudo usermod -a -G microk8s vagrant
  sudo chown -f -R vagrant ~/.kube
}

setup_root_login() {
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    sudo echo "root:rootroot" | chpasswd
}

setup_welcome_msg() {
    sudo apt -y install cowsay
    version=$(cat /etc/os-release |grep VERSION= | cut -d'=' -f2 | sed 's/"//g')
    sudo echo -e "\necho \"Welcome to Vagrant Ubuntu Server ${version}\" | cowsay\n" >> /home/vagrant/.bashrc
    sudo ln -s /usr/games/cowsay /usr/local/bin/cowsay
}

upgrade_system() {
    sudo apt -y upgrade
}

main() {
    ensure_netplan_apply
    resolve_dns
    install_openssh
    setup_root_login
#    setup_welcome_msg
    install_tools
    install_docker
    install_microk8s
    upgrade_system 
}

main

