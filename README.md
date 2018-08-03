# kubehard

Configuration of kubernetes at home using the hard way by [**Kelsey Hightower**](https://github.com/kelseyhightower/kubernetes-the-hard-way) and 
[**MICHAEL CHAMPAGNE**](https://blog.csnet.me/2018/04/on-prem-k8s-thw/).



## Planning

- OS's. 
    - Ubuntu for Master
    - 
- Balancer (HAProxy)
 
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




