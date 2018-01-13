#!/bin/sh

[ -e "dev.key" ] && exit 0

openssl genrsa -out dev.key 4096
openssl req -new -key dev.key -subj "/CN=dev/O=nixaid"

echo "Now sign your CSR with K8s's CA:"
echo "k8s-master# openssl x509 -req -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -days 1825"
