cd ../kubernetes/argocd-apps/
helm repo add argo https://argoproj.github.io/argo-helm
helm dependency update
helm dependency build
helm install argocd-apps . --namespace argocd --values values.yaml --create-namespace
