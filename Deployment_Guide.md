# CENM EKS Deployment

## Install Tools

### 1. Install `kubectl`

```
$ sudo apt install -y apt-transport-https
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg \
| sudo apt-key add -
$ echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" \
| sudo tee -a /etc/apt/sources.list.d/kubernetes.list
$ sudo apt update
$ sudo apt install -y kubectl
```

### 2. Install `helm`

```
$ curl -fsSL -o get_helm.sh \
https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
### 3. Install `Docker` 

```
$ sudo apt install -y docker.io
$ sudo usermod -aG docker $USER
```

### 4. Download the Docker image with `CENM Command-Line Interface (CLI) tool` 
```
$ docker pull corda/enterprise-cenm-cli:1.4-zulu-openjdk8u242
```
### 5. Install `AWS-cli`

```
$ sudo apt update
$ sudo apt remove -y --purge awscli
$ sudo apt install -y python3 python3-pip
$ sudo pip3 install awscli --upgrade
$ aws --version
```

### 6. Install `Amazon Authenticator`
```
$ curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
$ chmod +x aws-iam-authenticator
$ sudo mv aws-iam-authenticator /usr/bin/aws-iam-authenticator
```
## Connect with EKS cluster

```
$ aws eks update-kubeconfig --name <cluser-id>
```

## Create Namespace

```
$ cd k8s
$ kubectl apply -f cenm.yaml
$ export nameSpace=cenm
$ kubectl config set-context $(kubectl config current-context) --namespace=${nameSpace}
```
Verify using 

```
$ kubectl get ns
```

## AWS EFS Provisioning

```
$ helm install efs-provisioner ./efs \
 --set efs.id=<file.system.id> --set efs.region=<aws.region>
```

## Create Storage Class

```
$ kubectl create -f storage-class-aws.yaml
```

## Deploy CENM

Replace the `<host>`, `<port>`, `<admin_user>` and `<admin_pwd>` in database configurations of "values.yaml" files of the following services with proper values.

    1. auth
    2. idman
    3. nmap
    4. notary
    5. zone

To bootstrap the network
```
$ cd helm
$ ./bootstrap.cenm --ACCEPT_LICENSE Y -m <corda_minimum_platform_version> -p <release_prefix>
```

