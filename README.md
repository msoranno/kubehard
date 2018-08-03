# kubehard

Configuration of kubernetes at home using the hard way by [**Kelsey Hightower**](https://github.com/kelseyhightower/kubernetes-the-hard-way) and 
[**MICHAEL CHAMPAGNE**](https://blog.csnet.me/2018/04/on-prem-k8s-thw/).



## Planning

### Control plane 1
- ubuntu 16
- .39
- salt master
### Control plane 2
- centos 7
- .50

### worker1
### loadbalancer


## Housekeeping
### install virtualbox on redhat
```bash
# Add repo and update
cd /etc/yum.repos.d/
wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
yum udate -y
yum update -y

# check kernel version, if not matches the reboot.
uname -r
rpm -qa kernel |sort -V |tail -n 1

# install
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install VirtualBox-5.2

#configure
/usr/lib/virtualbox/vboxdrv.sh setup
usermod -a -G vboxusers sp81891

# optional
vboxconfig 

```


### install salt on control plane 1


### Centos7 static ip
```bash
# find your interface
msoranno@node01 ~]$ ip ad
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:01:22:04 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.48/24 brd 192.168.1.255 scope global noprefixroute dynamic eth0
       valid_lft 41453sec preferred_lft 41453sec
    inet6 fe80::e7d0:b97a:78c5:cfd3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

[msoranno@node01 ~]$ cd /etc/sysconfig/network-scripts/
[msoranno@node01 network-scripts]$ sudo cp ifcfg-eth0 ifcfg-eth0.backup 
[msoranno@node01 network-scripts]$ sudo vi ifcfg-eth0


TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
#BOOTPROTO="dhcp"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth0"
UUID="37876cd5-8df9-4a3f-a3be-157e6c1bb879"
DEVICE="eth0"
ONBOOT="yes"
IPADDR=192.168.1.50
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=80.58.61.254
DNS2=80.58.61.250


[msoranno@node01 network-scripts]$ sudo systemctl restart network

```


 
## Concepts

### Control Plane (Master components)
- Master components provide the cluster’s control plane.
- Master components can be run on any machine in the cluster.
- Master components make global decisions about the cluster (for example, scheduling), and detecting and responding to cluster events (starting up a new pod when a replication controller’s ‘replicas’ field is unsatisfied).

> **kube-apiserver**: Component on the master that exposes the Kubernetes API. It is the front-end for the Kubernetes control plane

> **etcd**: Consistent and highly-available key value store used as Kubernetes’ backing store for all cluster data.

> **kube-scheduler**: Component on the master that watches newly created pods that have no node assigned, and selects a node for them to run on.

> **kube-controller-manager**:  Component on the master that runs controllers. Logically, each controller  is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process. These controllers include:
> - Node Controller: Responsible for noticing and responding when nodes go down.
> - Replication Controller: Responsible for maintaining the correct number of pods for every replication controller object in the system.
> - Endpoints Controller: Populates the Endpoints object (that is, joins Services & Pods)
> - Service Account & Token Controllers: Create default accounts and API access tokens for new namespaces.

> **cloud-controller-manager**: runs controllers that interact with the underlying cloud providers. cloud-controller-manager allows cloud vendors code and the Kubernetes core to evolve independent of each other

### Node components

Node components run on every node, maintaining running pods and providing the Kubernetes runtime environment.

> **kubelet**: An agent that runs on each node in the cluster. It makes sure that containers are running in a pod. The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy

> **kube-proxy**: enables the Kubernetes service abstraction by maintaining network rules on the host and performing connection forwarding.

> **Container Runtime**: The container runtime is the software that is responsible for running containers. Kubernetes supports several runtimes: Docker, rkt, runc and any OCI runtime-spec implementation.

### Addons

Addons are pods and services that implement cluster features. The pods may be managed by Deployments, ReplicationControllers, and so on. Namespaced addon objects are created in the kube-system namespace. List of [availables addons](https://kubernetes.io/docs/concepts/cluster-administration/addons/)

> Required addon
> - DNS: all Kubernetes clusters should have cluster DNS, as many examples rely on it. Cluster DNS is a DNS server, in addition to the other DNS server(s) in your environment, which serves DNS records for Kubernetes services. Containers started by Kubernetes automatically include this DNS server in their DNS searches.




