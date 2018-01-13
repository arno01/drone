# Create K8s env and register the user

## WARNING:

Never ever use "dev" namespace, since whatever you ping that ends on ``.dev``, e.g. ``blabla.dev`` - will return ``127.0.53.53`` address!

```
kubectl -n devns apply -f .
./newuser.sh
```

```
kubectl -n devns create secret docker-registry regsecret --docker-server="docker.nixaid.com:5010" --docker-username=nixaid-docker --docker-password=REDACTED --docker-email arno@nixaid.com
kubectl -n devns patch serviceaccount default -p '{"imagePullSecrets": [{"name": "regsecret"}]}'
```

Now you can sign the CSR by the K8s CA:

```
openssl x509 -req -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -days 1825
```

Also get K8s's CA key /etc/kubernetes/pki/ca.crt

```
kubectl config set-credentials dev --client-certificate=dev.crt --client-key=dev.key
kubectl config set-cluster nixaid --server=https://k8s.nixaid.com:6443 --certificate-authority=ca.crt
kubectl config set-context dev-context --cluster=nixaid --namespace=devns --user=dev
kubectl --context=dev-context get pods
```
