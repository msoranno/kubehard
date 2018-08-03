# kubehard

Configuration of kubernetes at home using the hard way by [**Kelsey Hightower**](https://github.com/kelseyhightower/kubernetes-the-hard-way) and 
[**MICHAEL CHAMPAGNE**](https://blog.csnet.me/2018/04/on-prem-k8s-thw/).



## Planning

- OS's. 
    - Ubuntu for Master
    - 
- Balancer (HAProxy)
 
## Concepts

### Control Plane
- Master components provide the cluster’s control plane.
- Master components can be run on any machine in the cluster.
- Master components make global decisions about the cluster (for example, scheduling), and detecting and responding to cluster events (starting up a new pod when a replication controller’s ‘replicas’ field is unsatisfied).

> **kube-apiserver**: Component on the master that exposes the Kubernetes API. It is the front-end for the Kubernetes control plane

> **etcd**: Consistent and highly-available key value store used as Kubernetes’ backing store for all cluster data.

> **kube-scheduler**: Component on the master that watches newly created pods that have no node assigned, and selects a node for them to run on.

> **kube-controller-manager**:  Component on the master that runs controllers. Logically, each controller  is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.
> - Node Controller: Responsible for noticing and responding when nodes go down.
> - Replication Controller: Responsible for maintaining the correct number of pods for every replication controller object in the system.
> - Endpoints Controller: Populates the Endpoints object (that is, joins Services & Pods)
> - Service Account & Token Controllers: Create default accounts and API access tokens for new namespaces.
