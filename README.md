# mygps-vagrant-kubernetes-docker
mygps implementation on vagrant, kubernetes and docker <br>
The mygps app is at  https://www.github.com/fkam18/mygps <br>
The docker container build is at https://www.github.com/fkam18/mygps-docker <br>
This build is for microk8s on local baremetals (tested on ubuntu 20.04 libvirt KVM environment) <br>
Topology is one master node and 2 x worker nodes <br>
Vagrantfile - vagrant deploy 3 VM's <br>
bootstrap.sh - VM setup <br>
mygps.yaml - for node1 to deploy the mygps app containers with microk8s <br>
nginx-lb.yaml - load balancer to expose a public IP for the mygps service <br>
setup-step1 - run after Vagrant build <br>
setup-step2 - run after manually microk8s add-node (both node2/node3) <br>
setup-step3 - run after step2 <br>
<br>
At step2, the add-node is still manual as fix-dns only works after the Kubernetes cluster is formed <br>
It seems it is still a bug or not implemented in Kubernetes coredns to auto add node2/node3/node1 DNS to core dns or I missed something <br>
After all is run, http://192.168.121.3 should reach the mygps app page. <br>
<br>
On AWS EKS, eksctl does similar setup with less details.  <br>



