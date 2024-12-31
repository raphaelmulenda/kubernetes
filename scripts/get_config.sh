mkdir -p ~/.kube/
scp kassie@junkyard-01:/etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config
scp kassie@junkyard-01:/var/lib/kubernetes/secrets/cluster-admin-key.pem ~/.kube/config
scp kassie@junkyard-01:/var/lib/kubernetes/secrets/cluster-admin.pem ~/.kube/config
scp kassie@junkyard-01:/var/lib/kubernetes/secrets/ca.pem ~/.kube/config
