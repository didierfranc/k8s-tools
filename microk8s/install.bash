# setup vm
multipass launch --name microk8s-vm --cpus 4 --mem 4G --disk 40G

# install k8s
multipass exec microk8s-vm -- sudo snap install microk8s --classic
multipass exec microk8s-vm -- sudo iptables -P FORWARD ACCEPT
multipass exec microk8s-vm -- sudo usermod -a -G microk8s ubuntu
multipass exec microk8s-vm -- sudo chown -f -R ubuntu ~/.kube

# install addons
multipass exec microk8s-vm -- /snap/bin/microk8s kubectl label namespace default istio-injection=enabled
multipass exec microk8s-vm -- /snap/bin/microk8s enable dns storage dashboard istio metrics-server registry helm3

# save kubectl config
[[ ! -d ~/.kube ]] && mkdir ~/.kube
[[ -f ~/.kube/config ]] && mv ~/.kube/config ~/.kube/config.$(date '+%F.%T')
multipass exec microk8s-vm -- sudo /snap/bin/microk8s.config > ~/.kube/config
