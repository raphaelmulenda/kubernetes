# Intro
Homelab configuration with k8s and whatever hardware I can find
files under `nixos-anywhere` are for archival purpose and are not used anymore

# Spec
## Homelab-01 (controller)
Lenovo Thinkpad W520
CPU: i7-2760QM 2.4GHz
RAM: 16GB
Storage: 240GB SSD

## Requirements
Each node is running NixOS for reproducibility. Everything (in best effort) will be defined as code. Each node's definition is in `/nixos/<node_name>`

# Cluster
For now vanilla k8s will be used. Main goal right now is to learn nuts and bolts for CKA exam as well as create a test environment for different services.

## Requirements

## Configuration
Entire config is in nix files. Here you can find reference and explanation
## k8s

# Install
## NixOS
Install whatever as long as you have flakes enabled.
- Download this repo go to node's directory and change:
  - username
  - user's password
  - ip address
  - hostname

After changes (and on machine you want to set up) run:
`sudo nix flake update`
`sudo nixos-rebuild switch --flake .#junkyard-01`

### Debugging
After installation it's best to check if kubelet is running:
`journalctl -u kubelet`
There you'll find useful info

### Admin config
To use KubeAPI you need kubeconfig.
copy it from `/etc/kubernetes/cluster-admin.kubeconfig`
as well as client key `client-key /var/lib/kubernetes/secrets/cluster-admin-key.pem` and ` /var/lib/kubernetes/secrets/cluster-admin-key.pem`
put them in `~/.kube` and own them. (you need to change paths to those keys in kubeconfig itself)


# Sealed Secrets and ARGO repositories
Since docs for Argo reps is not accurate follow these steps to apply new repository using Sealed Secrets

```bash
echo sshPrivateKey=empty > secret
echo url=git@github.com:koyaaniskassie/klabater.git >> secret
echo type=git >> secret


kubectl create secret generic private-repo --dry-run=client --namespace=argocd --from-env-file secret -o json > secret.json

# replace `empty` in secret.json with key below
cat ~/.ssh/id_rsa| openssl base64 | tr -d '\n'

```

Add label to secret.json
```json
"labels": {"argocd.argoproj.io/secret-type": "repository"}

```

Use sealed secrets to hide encrypt secrets and apply it
```bash
./sealed-secrets_create_secret.sh -f secret.json -o secret_encrypted.yaml
```
