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
    export ASDF_KUBECTL_VERSION=1.13.4
    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
    export KUBECONFIG="$HOME/.kube/kubeconfig.minikube.yaml";
    minikube start --memory 7168 --disk-size 20g --extra-config=apiserver.authorization-mode=RBAC
    minikube addons enable ingress
    kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
    kubectl create clusterrolebinding default-cluster-admin --clusterrole=cluster-admin --serviceaccount=default:default
    kubectl -n kube-system create sa tiller
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    # helm init --service-account tiller
#     helm install stable/kube2iam --name kube2iam \
# --set=extraArgs.base-role-arn=arn:aws:iam::$AWS_ACCOUNT_ID:role/,extraArgs.default-role=$AWS_KUBE2IAM_DEFAULT_ROLE \
# --set host.iptables=true \
# --set "aws.secret_key=$AWS_SECRET_KEY" \
# --set "aws.access_key=$AWS_ACCESS_KEY_ID" \
# --set "aws.region=$AWS_REGION" \
# --namespace kube-system

}

regimme_mini_dns ()
{
    export ASDF_KUBECTL_VERSION=1.13.4
    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
    export KUBECONFIG="$HOME/.kube/kubeconfig.minikube.yaml";
    echo "Deleting current route"
    sudo route -n delete 10/24 > /dev/null 2>&1
    echo "Adding new route 10.0.0.0/24 $(minikube ip)"
    sudo route -n add 10.0.0.0/24 $(minikube ip)
    echo "Get interfaces:"
    ifconfig 'bridge0' | grep member | awk '{print $2}'
    interfaces_array=( $(ifconfig 'bridge0' | grep member | awk '{print $2}') )
    echo "Set firewall"
    for interface in "${interfaces_array[@]}"
    do
        sudo ifconfig bridge0 -hostfilter $interface
    done
    echo Done!
}

regimme_mini_svc () {

    echo Setting up minikube environment for you

    brew cask list minikube > /dev/null 2>&1
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "minikube not installed, so installing now"
        brew cask install minikube
    fi

    brew list kubectl > /dev/null 2>&1
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "kubectl not installed, so installing now"
        brew install kubectl
    fi

    brew list dnsmasq > /dev/null 2>&1
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "dnsmasq not installed, so installing now"
        brew install dnsmasq
    fi

    export ASDF_KUBECTL_VERSION=1.13.4
    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
    export KUBECONFIG="$HOME/.kube/kubeconfig.minikube.yaml";
    minikube status > /dev/null 2>&1
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "Minikube is not yet running, so starting it"
        minikube start --memory 7168 --disk-size 20g --extra-config=apiserver.authorization-mode=RBAC
        minikube addons enable ingress
    fi

    # brew install dnsmasq
    MINIKUBE_IP="$(minikube ip)"
    echo Minikube IP is $MINIKUBE_IP
    echo Setting local docker build context to minikube
    eval "$(minikube docker-env)"

    echo Setting dnsmasq to resolve minikube ingress

    grep -Fxq 'bind-interfaces' /usr/local/etc/dnsmasq.conf
    retVal=$?
    if [ $retVal -ne 0 ]; then
      echo 'bind-interfaces' >> /usr/local/etc/dnsmasq.conf
    fi

    grep -Fxq 'listen-address=127.0.0.1' /usr/local/etc/dnsmasq.conf
    retVal=$?
    if [ $retVal -ne 0 ]; then
      echo 'listen-address=127.0.0.1' >> /usr/local/etc/dnsmasq.conf
    fi

    RESOLVE_MINIKUBE_INGRESS="address=/ingress.local/${MINIKUBE_IP}"
    grep -Fxq "${RESOLVE_MINIKUBE_INGRESS}" /usr/local/etc/dnsmasq.conf
    retVal=$?
    if [ $retVal -ne 0 ]; then
      #remove outdated minikube ip address references, if any
      sed -i.bak '/^address=\/ingress.local/d' /usr/local/etc/dnsmasq.conf
      rm /usr/local/etc/dnsmasq.conf.bak
      echo "${RESOLVE_MINIKUBE_INGRESS}" >> /usr/local/etc/dnsmasq.conf
    fi
    sudo mkdir -p /etc/resolver/
    sudo tee -a /etc/resolver/ingress.local > /dev/null <<'EOF'
nameserver 127.0.0.1
domain ingress.local
search ingress.local default.ingress.local
options ndots:5
EOF
    echo Restarting DNS and flushing caches
    sudo brew services restart dnsmasq

    sudo killall -HUP mDNSResponder; sleep 2
    # echo check what's happening:
    # scutil --dns
}


regimme_mini ()
{
    export ASDF_KUBECTL_VERSION=1.13.4;
    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl;
    export KUBECONFIG="$HOME/.kube/kubeconfig.minikube.yaml";
    #alias minikube=/usr/local/etc/minikube-ingress-dns/minikube-ingress-dns-macos
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
  AWS_PATH="/usr/local/bin"
  EP=$(${AWS_PATH}/aws eks describe-cluster --name ${CLUSTER_NAME}  --query cluster.endpoint --output text)
  CC=$(${AWS_PATH}/aws eks describe-cluster --name ${CLUSTER_NAME}  --query cluster.certificateAuthority.data --output text)
  # KUBE_ROLE_ARN='arn:aws:iam::594813696195:role/sequoia-FullV1'

  # export KUBE_ROLE_ARN="arn:aws:iam::594813696195:role/$(/usr/local/bin/aws sts get-caller-identity --query 'Arn' --output text | cut -f 2 -d '/')"
  # eksctl utils write-kubeconfig --name=${CLUSTER_NAME} --kubeconfig=$KUBECONFIG --set-kubeconfig-context=true

  # aws eks update-kubeconfig --name $CLUSTER_NAME --kubeconfig $KUBECONFIG --role-arn $KUBE_ROLE_ARN
  # sed -e "s%<endpoint-url>%${EP}%g" \
  # -e "s%<base64-encoded-ca-cert>%${CC}%g" \
  # -e "s%<cluster-name>%${CLUSTER_NAME}%g" \
  # ~/.kube/kubeconfig.tmpl > $KUBECONFIG

  # command: aws-vault
  # args:
  #   - "exec"
  #   - "core"
  #   - "--"
  #   - "aws-iam-authenticator"
  #   - "token"
  #   - "-i"
  #   - "${CLUSTER_NAME}"
cat <<EOF > $KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${EP}
    certificate-authority-data: ${CC}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
      - "token"
      - "-i"
      - "${CLUSTER_NAME}"
EOF
  printf "\n...done\n\n"
}

function eksme() {

    export SGK_ENVIRONMENT="${1:-test}"
    #export CLUSTER_NAME="${2:-${SGK_ENVIRONMENT}-c20n}"
    #export STACK_NAME="${3:-${SGK_ENVIRONMENT}}"
    export CLUSTER_NAME="${2:-labs-${SGK_ENVIRONMENT}}"
    export STACK_NAME="${STACK_NAME:-eksctl-${CLUSTER_NAME}-cluster}"
    export KUBECONFIG="$HOME/.kube/kubeconfig.${CLUSTER_NAME}.yaml"
    set_kubecontext

    # export ASDF_KUBECTL_VERSION=1.12.7
    # export CLUSTER_NAME="$(eksctl get cluster --region=$AWS_REGION | sed -n 2p | awk '{print $1}')"
    # export KUBECONFIG="$HOME/.kube/eksctl/clusters/${CLUSTER_NAME}"
    # eksctl utils write-kubeconfig --name=${CLUSTER_NAME}


}

function eks_create_cluster() {
    export CLUSTER_NAME="${CLUSTER_NAME:-labs-v1}"
    export EKS_WORKER_AMI="ami-0440e4f6b9713faf6"
    #acorn
    export EKS_VPC_ID="vpc-de490eba"
    export EKS_SUBNET_IDS="subnet-880c6bfe, subnet-e9da6ec3, subnet-d3853a8b, subnet-d4853a8c, subnet-890c6bff, subnet-edda6ec7"
    export EKS_SECURITY_GROUPS="sg-63659818"

    aws eks create-cluster \
      --name k8s-workshop \
      --role-arn $EKS_SERVICE_ROLE \
      --resources-vpc-config subnetIds=${EKS_SUBNET_IDS},securityGroupIds=${EKS_SECURITY_GROUPS} \
      --kubernetes-version 1.10
}

function eks_launch_worker_nodes() {

    export CLUSTER_NAME="${CLUSTER_NAME:-labs-v1}"
    export AWS_STACK_NAME="${CLUSTER_NAME}-eks-workers"
    export EKS_WORKER_AMI="ami-0440e4f6b9713faf6"
    #acorn
    export EKS_VPC_ID="vpc-de490eba"
    export EKS_SUBNET_IDS="subnet-880c6bfe, subnet-e9da6ec3, subnet-d3853a8b, subnet-d4853a8c, subnet-890c6bff, subnet-edda6ec7"
    export EKS_SECURITY_GROUPS="sg-63659818"

    export EKS_VPC_ID="$(aws eks describe-cluster --name labs-v1 --query cluster.resourcesVpcConfig.vpcId --output text)"
    export EKS_SUBNET_IDS="$(aws eks describe-cluster --name labs-v1 --query cluster.resourcesVpcConfig.subnetIds --output text | tr '\t' ,)"
    export EKS_SECURITY_GROUPS="$(aws eks describe-cluster --name labs-v1 --query cluster.resourcesVpcConfig.securityGroupIds --output text | tr '\t' ,)"

    export NODE_AUTOSCALING_GROUP_MAX_SIZE="20"
    export NODE_INSTANCE_TYPE="m4.large"
    aws cloudformation create-stack \
  --stack-name "${AWS_STACK_NAME}" \
  --template-url https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-nodegroup.yaml \
  --capabilities "CAPABILITY_IAM" \
  --parameters "[{\"ParameterKey\": \"KeyName\", \"ParameterValue\": \"cfn-sagoku-key\"},
                 {\"ParameterKey\": \"NodeImageId\", \"ParameterValue\": \"${EKS_WORKER_AMI}\"},
                 {\"ParameterKey\": \"ClusterName\", \"ParameterValue\": \"${CLUSTER_NAME}\"},
                 {\"ParameterKey\": \"NodeGroupName\", \"ParameterValue\": \"${AWS_STACK_NAME}\"},
                 {\"ParameterKey\": \"ClusterControlPlaneSecurityGroup\", \"ParameterValue\": \"${EKS_SECURITY_GROUPS}\"},
                 {\"ParameterKey\": \"VpcId\", \"ParameterValue\": \"${EKS_VPC_ID}\"},
                 {\"ParameterKey\": \"NodeAutoScalingGroupMaxSize\", \"ParameterValue\": \"${NODE_AUTOSCALING_GROUP_MAX_SIZE}\"},
                 {\"ParameterKey\": \"NodeInstanceType\", \"ParameterValue\": \"${NODE_INSTANCE_TYPE}\"},
                 {\"ParameterKey\": \"Subnets\", \"ParameterValue\": \"${EKS_SUBNET_IDS}\"}]" \
  --tags '[{"Key":"sequoia:user","Value":"Cypress@ithaka"},{"Key":"sequoia:environment","Value":"acorn"},{"Key":"sequoia:basedomain","Value":"cirrostratus.org"}]'

}

function eks_get_worker_role_arn() {
    export CLUSTER_NAME="${CLUSTER_NAME:-labs-v1}"
    export AWS_STACK_NAME="${AWS_STACK_NAME:-eksctl-labs-test-cluster}"
    # AWS_STACK_NAME=eksctl-${CLUSTER_NAME}-nodegroup-${CLUSTER_NAME}-m5-private-1a
    export CLUSTER_NAME="labs-test"

    export ACCT_ROLE_ARN_PRE="arn:aws:iam::594813696195:role/"
    RA="$(aws cloudformation list-stack-resources --stack-name "${AWS_STACK_NAME}" \
    --query 'StackResourceSummaries[?LogicalResourceId==`NodeInstanceRole`].PhysicalResourceId' \
    --output text)"
    export NODE_ROLE_ARN="arn:aws:iam::594813696195:role/eks-nodes-base-role"
    echo "${NODE_ROLE_ARN}"
}

function eks_apply_auth_configmap() {
    eks_get_worker_role_arn
#    read -r -d '' EKS_AUTH_CONFIGMAP <<EOF
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapUsers: |
    - userarn: arn:aws:iam::594813696195:user/scoffman
      username: scoffman
      groups:
        - system:masters
  mapRoles: |
    - rolearn: ${NODE_ROLE_ARN}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::594813696195:role/sequoia-FullV1
      username: admin:{{AccountID}}:{{SessionName}}
      groups:
        - system:masters
    - rolearn: arn:aws:iam::594813696195:role/sequoia-DevelopmentV1
      username: development:{{AccountID}}:{{SessionName}}
      groups:
        - system:masters
EOF

}


function labseksme() {
    export SGK_ENVIRONMENT="${1:-test}"
    export CLUSTER_NAME="${2:-labs-${SGK_ENVIRONMENT}}"
    export STACK_NAME="${STACK_NAME:-eksctl-${CLUSTER_NAME}-cluster}"
    export KUBECONFIG="$HOME/.kube/kubeconfig.${CLUSTER_NAME}.yaml"

# asdf local kubectl 1.10.7
    export ASDF_KUBECTL_VERSION=1.12.7
    #printf "attempting to update your $KUBECONFIG context for the cluster ${CLUSTER_NAME}...\n"
    #eksctl utils write-kubeconfig --name=${CLUSTER_NAME} --kubeconfig=${KUBECONFIG} --set-kubeconfig-context=true
    set_kubecontext
    #printf "\n...done\n\n"
}


function dashboard() {
    export SGK_ENVIRONMENT=${SGK_ENVIRONMENT:-test}
    export CLUSTER_NAME="${CLUSTER_NAME:-labs-${SGK_ENVIRONMENT}}"
    export KUBECONFIG="$HOME/.kube/kubeconfig.${CLUSTER_NAME}.yaml"

    case $SGK_ENVIRONMENT in
        test|prod) echo Opening Dasbboard for $CLUSTER_NAME in $SGK_ENVIRONMENT ;;
        *) echo "SGK_ENVIRONMENT $SGK_ENVIRONMENT not valid" && return 1;;
    esac

    if !hash aws-iam-authenticator 2>/dev/null
    then
        echo 'Make sure you have the aws-iam-authenticator binary installed. You can install it with:'
        echo 'go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator'
        return 1
    fi
    aws-iam-authenticator token -i "${CLUSTER_NAME}" | jq -r ".status.token" | pbcopy
    open 'https://labs-dashboard.'${SGK_ENVIRONMENT}'.cirrostratus.org/#!/login'
    # KUBECTL_PROXY_PID=$(lsof -t -i :8001)
    # if [[ -n "${KUBECTL_PROXY_PID:-}" ]]
    # then
    #   kill -9 "${KUBECTL_PROXY_PID}"
    # else
    #     echo "Nothing running listening to 8001"
    # fi
    # kubectl proxy &
    # aws-iam-authenticator token -i "${CLUSTER_NAME}" -r arn:aws:iam::594813696195:role/sequoia-DevelopmentV1 | jq -r ".status.token" | pbcopy
    #open 'http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login'

}
