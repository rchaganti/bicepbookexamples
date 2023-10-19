#!/bin/sh
USERNAME=$1
PLUGIN=$2
CIDR=$3

ADMINCONF=/etc/kubernetes/admin.conf

if [ -f "$ADMINCONF" ]; then
        echo "${ADMINCONF} exists"
else
        echo "${ADMINCONF} does not exist"
        exit 1
fi

# Configure kubeconfig for standard user
mkdir /home/$USERNAME/.kube
cp -f $ADMINCONF /home/$USERNAME/.kube/config
chown -v $(id -u $USERNAME):$(id -g $USERNAME) /home/$USERNAME/.kube/config

# install CNI plugin
case "$PLUGIN" in
        "calico") 
                echo "Downloading and installing Tigera operator and custom resource defintions ..."
                helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
                KUBECONFIG=$ADMINCONF kubectl create namespace tigera-operator
                KUBECONFIG=$ADMINCONF helm install calico projectcalico/tigera-operator --version v3.24.5 --namespace tigera-operator
                ;;
        *)
                echo "Nothing to install"
                ;;
esac