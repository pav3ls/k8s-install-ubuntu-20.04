# Install docker
# Get the Docker gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Kubernetes 
# Get the Kubernetes gpg key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add the Kubernetes repository
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update your packages
sudo apt-get update

# Install Docker, kubelet, kubeadm, and kubectl
sudo apt-get install -y docker-ce kubelet kubeadm kubectl

# Hold them at the current version
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

# Letting iptables see bridged traffic

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# Enable iptables immediately
sudo sysctl -p

# Disable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a


## Use "kubeadm join" command to join into cluster
## Generate new token: kubeadm token generate
## kubeadm token create <generated-token> --print-join-command --ttl=0