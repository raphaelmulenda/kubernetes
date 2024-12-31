cd ../kubernetes/sealed-secrets/
helm dependency update
helm install sealed-secrets . --namespace kube-system

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.27.3/controller.yaml
sleep 10

KUBESEAL_VERSION='0.27.1'
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
echo "installed sealed-secrets on cluster and kubeseal on your machine"

echo "downloading certificate"
kubeseal --fetch-cert >~/.kube/kubeseal_local_cert.pem
echo "certificate installed in ~/.kube/kubeseal_local_cert.pem"
