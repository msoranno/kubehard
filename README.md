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

### install salt 
```bash
# salt master ubuntu18

sudo hostnamectl set-hostname salt

sudo vi /etc/hosts
127.0.0.1 localhost salt

wget -O - https://repo.saltstack.com/apt/debian/9/amd64/archive/2018.3.0/SALTSTACK-GPG-KEY.pub | sudo apt-key add -

sudo vi /etc/apt/sources.list.d/saltstack.list
deb http://repo.saltstack.com/apt/debian/9/amd64/archive/2018.3.0 stretch main

sudo apt-get update -y
sudo apt-get install salt-master salt-minion

curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -P -M

# salt minion (ubuntu18)
sudo hostnamectl set-hostname master01.k8s.com
sudo vi /etc/hosts
127.0.0.1       localhost master01.k8s.com
192.168.1.60    salt

curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -P


# salt minion (Centos7)
sudo hostnamectl set-hostname master02.k8s.com
sudo vi /etc/hosts
127.0.0.1       localhost master02.k8s.com
192.168.1.60    salt

curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -P


# Again on salt master ubuntu18

    # - Verifying unnacepted keys keys (salt master). 

msoranno@salt:~$ sudo salt-key -L
Accepted Keys:
Denied Keys:
Unaccepted Keys:
master01.k8s.com
master02.k8s.com
salt
Rejected Keys:

    # - Listing keys
msoranno@salt:~$ sudo salt-key -F master
Local Keys:
master.pem:  2f:e0:24:1b:ad:1f:c9:81:68:c6:29:72:e4:41:02:5f:e4:d3:38:4e:14:85:13:8c:b9:d9:a4:42:7c:fe:10:b4
master.pub:  45:4c:b2:e4:ea:82:00:b2:0b:05:38:7f:46:7d:0b:3d:ec:cb:6b:79:4c:02:6a:6d:20:de:ad:b9:45:7c:73:d9
Unaccepted Keys:
master01.k8s.com:  bf:b2:74:8b:19:a9:15:53:3e:64:46:48:8e:33:9c:45:7b:8e:2e:c0:01:14:86:1a:f6:c0:b4:d5:dc:2d:7c:55
master02.k8s.com:  18:55:42:78:dc:eb:30:ef:3e:8d:be:4a:75:39:f4:d4:e7:0b:c8:95:18:95:42:62:8c:b4:e4:90:7c:8c:78:6b
salt:  04:5a:55:2f:eb:57:61:66:80:4d:f1:1d:04:de:99:a7:f3:b3:df:dc:43:09:87:c5:18:f3:ca:fa:df:28:36:57


# On every minion. Update the master_finger value with the master.pub returned before.
sudo vi /etc/salt/minion

    # Once updated restart
sudo systemctl restart salt-minion


# Now back on master we can accepts keys

msoranno@salt:~$ sudo salt-key -A

The following keys are going to be accepted:
Unaccepted Keys:
master01.k8s.com
master02.k8s.com
salt
Proceed? [n/Y] y
Key for minion master01.k8s.com accepted.
Key for minion master02.k8s.com accepted.
Key for minion salt accepted.

```
### configuring salt

```bash
# AT SALT-MASTER We make our /home/msoranno/salt directory as root to salt
mkdir salt
cd /etc/salt/master.d
sudo vi file-roots.conf
file_roots:
  base:
    - /home/msoranno/kubehard/salt
    
sudo systemctl restart salt-master

# AT MINION we create roles for them.
cd /etc/salt/minion.d/
sudo vi grains.conf
grains:
  roles:
    - kubeMaster

sudo systemctl restart salt-minion

```

 
### install virtualbox on redhat7
```bash
# Add repo and update
cd /etc/yum.repos.d/
wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
yum udate -y
yum update -y

# check kernel version, if not matches the reboot.
uname -r
rpm -qa kernel |sort -V |tail -n 1

# installmsoranno
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install VirtualBox-5.2

#configure
/usr/lib/virtualbox/vboxdrv.sh setup
usermod -a -G vboxusers sp81891

# troubleshooting
#------
# - error starting vm
# The VirtualBox Linux kernel driver (vboxdrv) is either not loaded or there is a permission problem with /dev/vboxdrv. Please reinstall the kernel module by executing
#------
yum install kernel-devel-$(uname -r)
vboxconfig 

```

### Ubuntu18 static ip
```bash
root@salt:~# cd /etc/netplan/
root@salt:/etc/netplan# vi 50-cloud-init.yaml

network:
 version: 2
 renderer: networkd
 ethernets:
   enp0s3:
     dhcp4: no
     dhcp6: no
     addresses: [192.168.1.60/24]
     gateway4: 192.168.1.1
     nameservers:
       addresses: [80.58.61.254,80.58.61.250]
       
root@salt:/etc/netplan# netplan apply

```
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


## Double checks on Environment start

- salt master
```bash
sysctl -w net.ipv4.ip_forward=0
```
- kube master01 (alien)
```bash
sudo systemctl start systemd-udevd
```


## Troubleshooting

### Duplicate PING
```bash
64 bytes from 192.168.1.60: icmp_seq=57 ttl=64 time=159 ms
64 bytes from 192.168.1.60: icmp_seq=57 ttl=64 time=159 ms (DUP!)
```
Salt-master ia a vm running on virtualbox on my lenovo redhat7 as host. 
Sometimes salt-minions failed on connecting to salt-master and we figure out that the problem was the salt master was responding duplicates ping packages.
The problem must be related with a bug on virtualbox.

> Solution: we have to disable ip_forwarding on the redhat host.
```bash
# This will turn back to 1 on restart.
sysctl -w net.ipv4.ip_forward=0
```




