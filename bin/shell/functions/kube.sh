#!/bin/bash

alias k="kubectl"
alias kc="kubectl create -f"
alias kg="kubectl get"
alias pods="kubectl get pods"
alias allpods="kubectl get pods --all-namespaces"
alias rcs="kubectl get rc"
alias svcs="kubectl get services"
alias getdep="kubectl get deployment"
alias kd="kubectl describe"
alias kdp="kubectl describe pod "
alias kds="kubectl describe service "
alias nodes="kubectl get nodes"
# kubectl logs my-pod -c my-container
alias klogs="kubectl logs"
alias ns="kubectl get ns"
alias deploys="kubectl get deployment"
alias events="kubectl get events"
alias kexec="kubectl exec -it "
alias secrets="kubectl get secrets"
alias igs="kubectl get ingress"
alias contexts="kubectl config get-contexts"
alias ktop="kubectl top nodes"

function dedash_node_ip() {
    printf "$1" | cut -f1 -d '.' | sed 's/[^0-9-]*//g'| tr '-' '.' | tail -c +2 | tr -d '\n'
}

function cadvisor_for_node() {
    bless_tunnel $(dedash_node_ip "$1")  4194 9000
    ### We don't exit above so next line doesn't really work.
open http://localhost:9000/containers/
}

function get_service_ingress_ip(){
    # 1 is service nme 2 is is namespace
    kubectl get service $1 -n $2 --template="{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"
}

function pods_by_selector() {
  kubectl get pods --selector=$1
}

# List Names of Pods that belong to Particular RS

# List Names of Pods that belong to Particular RC
function get_pods_for_rs() {
# "jq" command useful for transformations that are too complex for jsonpath, it can be found at https://stedolan.github.io/jq/
sel=${$(kubectl get rc $1 --output=json | jq -j '.spec.selector | to_entries | .[] | "\(.key)=\(.value),"')%?}
echo "$(kubectl get pods --selector=$sel --output=jsonpath={.items..metadata.name})"
}

alias get_selectors="kubectl get rs --output=json | jq -j '.items[].spec.selector | to_entries | .[] | \"\(.key)=\(.value),\"'"

function kubeshell() {
    # -i        If the -i option is present, the shell is interactive.
    # -l        Make  bash act as if it had been invoked as a login shell
    kubectl exec "$1" -i -t -- /bin/sh -il
}
#export KOPS_NAME="ha-master-private.k8s.cirrostratus.org"
#export KOPS_STATE_STORE="s3://sequoia-k8s-state-store"


function brew_kops_head() {
    brew unlink kops; brew update;brew install --HEAD kops --debug --verbose
}

function nuke_scoffman() {
    cd /Users/scoffman/Documents/git/continuous-deployment/k8s/kops || return 1
    set_kops_env scoffman; kops delete cluster --name $KOPS_NAME --yes;./launchk8s.sh scoffman
}

function kube_docker_context() {
    kubectl config use-context docker-for-desktop
}

function current_context() {
  kubectl config view -o=jsonpath='{.current-context}'
}

function get_contexts() {
  kubectl config get-contexts -o=name | sort -n
}

function get_namespaces() {
  kubectl get namespaces -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}'
}


function set_kops_env() {
    # asdf local kubectl 1.8.14
    export ASDF_KUBECTL_VERSION=1.8.14
    WHOAMI=$(whoami)
    STACK_NAME=${1:-$WHOAMI}
    export KOPS_NAME="k8s-cluster.${STACK_NAME}.cirrostratus.org"
    export KOPS_STATE_STORE="s3://sequoia-k8s/kops"
    export KOPS_FEATURE_FLAGS="+DrainAndValidateRollingUpdate"
    kops export kubecfg --name $KOPS_NAME --state $KOPS_STATE_STORE

}
function get_dashboard() {
  if [[ -z $KOPS_NAME ]]; then
    echo
    echo "Please export the KOPS_NAME environment variable as KOPS_NAME"
    echo
    return 1
  fi

  PASSWORD=$(sh << EOF
kubectl config view -o jsonpath='{.users[?(@.name == "${KOPS_NAME}-basic-auth")].user.password}'
EOF
)
  printf '%s' "$PASSWORD" | pbcopy
  echo "Password copied to clipboard"
  open "https://api.${KOPS_NAME}/ui"
  # /api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
}

function kube_master_ssh() {
    if [[ -z $KOPS_NAME ]]; then
        echo
        echo "Please export the KOPS_NAME environment variable as KOPS_NAME"
        echo
        return 1
    fi
    # bless_me api.internal.k8s-cluster scoffman
    ssh -A -i ~/.ssh/prod.pem api.internal.$KOPS_NAME

}

function kube_log_pod() {
    POD_NAMES=$(kubectl get pods --selector=k8s-app=kubernetes-dashboard -n kube-system -o jsonpath='{.items[*].metadata.name}')
    kubectl logs -n kube-system $POD_NAMES
}

function kube_log_dns() {
#    for a in $(kubectl get pods  -n kube-system |grep kube-dns |grep -v autoscaler |cut -d ' ' -f 1 );do for b in kubedns dnsmasq sidecar;do kubectl logs -n kube-system $a -c $b  > $a-$b.log;done;done
  for b in kubedns dnsmasq sidecar;do kubectl logs -n kube-system -l k8s-app=kube-dns -c $b;done
}

function dang_it_make_better_name_later() {
    if [[ -z $KOPS_NAME ]]; then
        echo
        echo "Please export the KOPS_NAME environment variable as KOPS_NAME"
        echo
        return 1
    fi
    bless_scp ubuntu@api.internal.$KOPS_NAME:/srv/kubernetes/ca.crt $HOME/Downloads/ca.crt
    bless_scp ubuntu@api.internal.$KOPS_NAME:/srv/kubernetes/ca.key $HOME/Downloads/ca.key
    TOKEN=$(kubectl describe secret "$(kubectl get secrets | grep default-token | cut -f1 -d ' ')" | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d ' ')
    curl --cacert ~/Downloads/ca.crt -H "Authorization: Bearer $TOKEN" https://api.$KOPS_NAME/api/v1/namespaces/kube-system/services/hello-from-kube
    # kubectl create secret tls ingress-ssl-secret --key $HOME/Downloads/ca.key --cert $HOME/Downloads/ca.crt
# curl --silent --fail \
#  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
#   -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
#   https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PO‌​RT/api/v1/namespaces‌​/default/services/$S‌​ERVICE_NAME \
#   | jq '.spec.ports[] | select(.name=="http") | .nodePort'
}


function gimme_mini() {
    # asdf local kubectl 1.11.0
    export ASDF_KUBECTL_VERSION=1.11.0
    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
    minikube start --extra-config=apiserver.authorization-mode=RBAC
    kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
    kubectl create clusterrolebinding default-cluster-admin --clusterrole=cluster-admin --serviceaccount=default:default
    kubectl -n kube-system create sa tiller
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    helm init --service-account tiller
#     helm install stable/kube2iam --name kube2iam \
# --set=extraArgs.base-role-arn=arn:aws:iam::$AWS_ACCOUNT_ID:role/,extraArgs.default-role=$AWS_KUBE2IAM_DEFAULT_ROLE \
# --set host.iptables=true \
# --set "aws.secret_key=$AWS_SECRET_KEY" \
# --set "aws.access_key=$AWS_ACCESS_KEY_ID" \
# --set "aws.region=$AWS_REGION" \
# --namespace kube-system

}
obtain_role_arn() {
  if [[ $STACK_NAME == "" ]]
  then
    STACK_NAME=$(echo $CLUSTER_NAME | cut -d '-' -f 1)
    printf "Stack name for role not determined, attempting $STACK_NAME...\n"
  fi
  EKSSTACK=$(aws cloudformation list-stack-resources --stack-name ${STACK_NAME} | jq -r ".StackResourceSummaries[] | select(.LogicalResourceId==\"EKS\").PhysicalResourceId")
  RA=$(aws cloudformation list-stack-resources --stack-name $EKSSTACK | jq -r ".StackResourceSummaries[] | select(.LogicalResourceId | test(\"^EKSNodeInstanceRole\")) | .PhysicalResourceId")
  if [[ $? < 1 ]]
  then
    printf "Discovered NODE Role ARN ${RA} for cluster ${CLUSTER_NAME}\n"
  else
    printf "Did not discover role ARN, $?\n"
    usage
  fi
  NODE_ROLE_ARN="${ACCT_ROLE_ARN_PRE}${RA}"
}

set_kubecontext() {
  printf "attempting to update your $KUBECONFIG context for the cluster ${CLUSTER_NAME}...\n"
  # EP=$(aws eks describe-cluster --name ${CLUSTER_NAME}  --query cluster.endpoint --output text)
  # CC=$(aws eks describe-cluster --name ${CLUSTER_NAME}  --query cluster.certificateAuthority.data --output text)
  KUBE_ROLE_ARN='arn:aws:iam::594813696195:role/sequoia-FullV1'
  aws eks update-kubeconfig --name $CLUSTER_NAME --kubeconfig $KUBECONFIG --role-arn $KUBE_ROLE_ARN
  # sed -e "s%<endpoint-url>%${EP}%g" \
  # -e "s%<base64-encoded-ca-cert>%${CC}%g" \
  # -e "s%<cluster-name>%${CLUSTER_NAME}%g" \
  # ~/.kube/kubeconfig.tmpl > $KUBECONFIG
  printf "\n...done\n\n"
}

function eksme() {
    export STACK_NAME="${STACK_NAME:-test}"
    export KUBECONFIG="$HOME/.kube/config_eks_${STACK_NAME}"
    export CLUSTER_NAME="${STACK_NAME}-c20n"
# asdf local kubectl 1.10.5
    export ASDF_KUBECTL_VERSION=1.10.7
    set_kubecontext
}
