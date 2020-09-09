# required three input values $1 $2 $3
yum install docker -y
systemctl enable docker 
systemctl start docker 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet
systemctl start kubelet
hostnamectl set-hostname master-node
echo $1 >> /etc/hosts
echo $2 >> /etc/hosts
echo $3 >> /etc/hosts
#hostnamectl set-hostname slave1
#hostnamectl set-hostname slave2
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sed -i '/swap/d' /etc/fstab
swapoff -a
############## till above can be used for slave node ############
kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

