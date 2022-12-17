#!/bin/sh
IPADDR=$(hostname -I)
APISERVER=$(hostname -s)
NODENAME=$(hostname -s)

POD_NET=$1

echo "running kubeadm init --apiserver-advertise-address=$IPADDR \
                  --apiserver-cert-extra-sans=$APISERVER \
                  --pod-network-cidr=$POD_NET \
                  --node-name $NODENAME"

kubeadm init --apiserver-advertise-address=$IPADDR \
             --apiserver-cert-extra-sans=$APISERVER \
             --pod-network-cidr=$POD_NET \
             --node-name $NODENAME

