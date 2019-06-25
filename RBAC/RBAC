
Introduction :
You define your RBAC permissions by creating objects from the rbac.authorization.k8s.io API group in your cluster. You can create the objects using the kubectl command-line interface, or programmatically.

You'll need to create two kinds of objects:

1. A Role or ClusterRole object that defines what resource types and operations are allowed for a set of users.
2. A RoleBinding or ClusterRoleBinding that associates the Role (or ClusterRole) with one or more specific users.

RBAC permissions are purely additive there are no "deny" rules. When structuring your RBAC permissions, you should think in terms of "granting" users access to cluster resources.

1. Creating dev and stage namespace

[root@kubernetesmaster1 users]# kubectl get ns
NAME          STATUS   AGE
default       Active   3d3h
dev           Active   13s
kube-public   Active   3d3h
kube-system   Active   3d3h
stage         Active   5s
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# pwd
/root/.kube/users
[root@kubernetesmaster1 users]# ls

To create user1 generate RSA keys for dev create CSR and get it singed with kubernetes rootCA and rootCA private key
[root@kubernetesmaster1 users]# openssl genrsa -out dev.key 2048
Generating RSA private key, 2048 bit long modulus
.......+++
................+++
e is 65537 (0x10001)
[root@kubernetesmaster1 users]# ls
dev.key

Generate the CSR
[root@kubernetesmaster1 users]# openssl req -new -key dev.key -out dev.csr -subj "/CN=dev/O=example.com"
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# ls
dev.csr  dev.key

Sign the CSR and create the user1 x.509 certificate , sign CSR with the kubernetes rootCA and rootCA key which usually present in the /etc/kubernetes/pki/ location. for kubespary /etc/kubernetes/ssl/

[root@kubernetesmaster1 users]# openssl x509 -req -in dev.csr -CA /etc/kubernetes/ssl/ca.crt -CAkey /etc/kubernetes/ssl/ca.key -CAcreateserial -out dev.crt -days 365 
Signature ok
subject=/CN=dev/O=example.com
Getting CA Private Key
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]#

update the kubernetes config and define set-credentials and set-context for user1
ex: root@kube-master:# kubectl config set-credentials user1 --client-certificate=user1.crt --client-key=user1.key
User "user1" set.
root@kube-master:# kubectl config set-context dev --cluster=kubernetes --namespace=dev --user=user1
Context "dev" modified.

[root@kubernetesmaster1 users]# kubectl config set-credentials dev --client-certificate=dev.crt --client-key=dev.key
User "dev" set.
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# kubectl config set-context dev --cluster=kubernetes --namespace=dev --user=dev
Context "dev" created.
[root@kubernetesmaster1 users]#



[root@kubernetesmaster1 users]# openssl genrsa -out stage.key 2048
Generating RSA private key, 2048 bit long modulus
...................................+++
...........................................................................+++
e is 65537 (0x10001)
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# ls
dev.crt  dev.csr  dev.key  stage.key
[root@kubernetesmaster1 users]# openssl req -new -key stage.key -out stage.csr -subj "/CN=stage/O=example.com"
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# openssl x509 -req -in stage.csr -CA /etc/kubernetes/ssl/ca.crt -CAkey /etc/kubernetes/ssl/ca.key -CAcreateserial -out stage.crt -days 365
Signature ok
subject=/CN=stage/O=example.com
Getting CA Private Key
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# kubectl config set-credentials stage --client-certificate=stage.crt --client-key=stage.key
User "stage" set.
[root@kubernetesmaster1 users]#
[root@kubernetesmaster1 users]# kubectl config set-context stage --cluster=kubernetes --namespace=stage  --user=stage
Context "stage" created.
[root@kubernetesmaster1 users]#


[root@kubernetesmaster1 users]# kubectl auth can-i list pods -n  dev
yes
[root@kubernetesmaster1 users]# kubectl auth can-i list pods -n dev --as dev
no - no RBAC policy matched
[root@kubernetesmaster1 users]#


4. Creating the role and rolebinding for dev user

Creating role
Create role in dev namespace, In this yaml file we are creating the rule that allows a user to execute operations like deployments,replicasets,pods

[root@kubernetesmaster1 role-bind]# cat dev-role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: dev
  name: devlopment
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: dev-role-binding
  namespace: dev
subjects:
- kind: User
  name: dev
  apiGroup: ""
roleRef:
  kind: Role
  name: devlopment
  apiGroup: ""

[root@kubernetesmaster1 role-bind]#


Creating the role and rolebinding for stage user
[root@kubernetesmaster1 role-bind]# cat stage-role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: stage
  name: staging
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: stage-role-binding
  namespace: stage
subjects:
- kind: User
  name: stage
  apiGroup: ""
roleRef:
  kind: Role
  name: staging
  apiGroup: ""
[root@kubernetesmaster1 role-bind]#

Note : Here i created a smple role,rolebinding & clusterrole,Clusterrolebinding buti didn't apply any clusterrole and cluster rolebinding to any user 

[root@kubernetesmaster1 cluster-role]# cat role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: test
  name: netapp-k8s
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods", "services", "nodes"]
  verbs: ["get", "watch", "list"]

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: netapp-k8s-ro
  namespace: test
subjects:
- kind: User
  name: netapp # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: netapp-k8s # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
[root@kubernetesmaster1 cluster-role]#

[root@kubernetesmaster1 cluster-role]# cat cluster-role.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: cluster-node-reader
rules:
- apiGroups: [""]
  resources: ["nodes","pods"]
  verbs: ["get", "watch", "list"]

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-cluster-nodes
subjects:
- kind: User
  name: netapp # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-node-reader
  apiGroup: rbac.authorization.k8s.io
[root@kubernetesmaster1 cluster-role]#


6. Verify Roles and RoleBindings
[root@kubernetesmaster1 role-bind]# kubectl  get roles,rolebindings -n dev
NAME                                        AGE
role.rbac.authorization.k8s.io/devlopment   118s

NAME                                                     AGE
rolebinding.rbac.authorization.k8s.io/dev-role-binding   118s
[root@kubernetesmaster1 role-bind]#
[root@kubernetesmaster1 role-bind]# kubectl  get roles,rolebindings -n stage
NAME                                     AGE
role.rbac.authorization.k8s.io/staging   49s

NAME                                                       AGE
rolebinding.rbac.authorization.k8s.io/stage-role-binding   49s
[root@kubernetesmaster1 role-bind]#
[root@kubernetesmaster1 role-bind]#


[root@kubernetesmaster1 role-bind]# kubectl describe rolebindings dev-role-binding -n dev
Name:         dev-role-binding
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"rbac.authorization.k8s.io/v1beta1","kind":"RoleBinding","metadata":{"annotations":{},"name":"dev-role-binding","namespace":...
Role:
  Kind:  Role
  Name:  devlopment
Subjects:
  Kind  Name  Namespace
  ----  ----  ---------
  User  dev
[root@kubernetesmaster1 role-bind]#

[root@kubernetesmaster1 role-bind]# kubectl get rolebinding -n stage
NAME                 AGE
stage-role-binding   3m19s
[root@kubernetesmaster1 role-bind]# kubectl describe rolebinding stage-role-binding -n stage
Name:         stage-role-binding
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"rbac.authorization.k8s.io/v1beta1","kind":"RoleBinding","metadata":{"annotations":{},"name":"stage-role-binding","namespace...
Role:
  Kind:  Role
  Name:  staging
Subjects:
  Kind  Name   Namespace
  ----  ----   ---------
  User  stage
[root@kubernetesmaster1 role-bind]# 

7. Launch busybox pods in the respective namespace

[root@kubernetesmaster1 role-bind]#
[root@kubernetesmaster1 role-bind]# kubectl create -f dep.yaml -n stage
pod/busybox created
[root@kubernetesmaster1 role-bind]#
[root@kubernetesmaster1 role-bind]# kubectl create -f dep.yaml -n dev
pod/busybox created
[root@kubernetesmaster1 role-bind]#

8. Testing RBAC
[root@kubernetesmaster1 role-bind]# kubectl config get-contexts
CURRENT   NAME                    CLUSTER      AUTHINFO           NAMESPACE
          dev                     kubernetes   dev                dev
*         kubernetes-admin@prod   prod         kubernetes-admin   default
          stage                   kubernetes   stage              stage
[root@kubernetesmaster1 role-bind]#


[root@kubernetesmaster1 role-bind]# kubectl get pods -n dev
NAME      READY   STATUS    RESTARTS   AGE
busybox   1/1     Running   0          3m56s
[root@kubernetesmaster1 role-bind]# kubectl get pods -n stage
NAME      READY   STATUS    RESTARTS   AGE
busybox   1/1     Running   0          4m6s
[root@kubernetesmaster1 role-bind]#

[root@kubernetesmaster1 role-bind]# kubectl --context=dev get pods
NAME      READY     STATUS    RESTARTS   AGE
busybox   1/1       Running   0          4m
[root@kubernetesmaster1 role-bind]# kubectl --context=stage get pods
NAME      READY     STATUS    RESTARTS   AGE
busybox   1/1       Running   0          4m


[root@kubernetesmaster1 role-bind]# kubectl get pods -n dev --user=stage
Error from server (Forbidden): pods is forbidden: User "stage" cannot list resource "pods" in API group "" in the namespace "dev"
[root@kubernetesmaster1 role-bind]#
[root@kubernetesmaster1 role-bind]# kubectl get pods -n stage --user=dev
Error from server (Forbidden): pods is forbidden: User "dev" cannot list resource "pods" in API group "" in the namespace "stage"
[root@kubernetesmaster1 role-bind]#



Deleting Cluster,context and users

[root@kubernetesmaster1 ~]# kubectl config view
[root@kubernetesmaster1 ~]#
[root@kubernetesmaster1 ~]# kubectl config  get-clusters
[root@kubernetesmaster1 ~]# kubectl config delete-cluster kubernetes
[root@kubernetesmaster1 ~]#
[root@kubernetesmaster1 ~]# kubectl config get-contexts
CURRENT   NAME                    CLUSTER      AUTHINFO           NAMESPACE
          dev                     kubernetes   dev                dev
*         kubernetes-admin@prod   prod         kubernetes-admin   default
          stage                   kubernetes   stage              stage
[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]# kubectl config delete-context stage
deleted context stage from /root/.kube/config
[root@kubernetesmaster1 ~]#
[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]# kubectl config view
[root@kubernetesmaster1 ~]# kubectl  config  unset users.maya
Property "users.maya" unset.
[root@kubernetesmaster1 ~]#



[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]# 
[root@kubernetesmaster1 ~]#
[root@kubernetesmaster1 ~]# 




REF:

https://8gwifi.org/docs/kube-auth.jsp
http://www.ethernetresearch.com/kubernetes/kubernetes-security-user-authentication-authorization-rbac/

https://jeremievallee.com/2018/05/28/kubernetes-rbac-namespace-user.html

https://www.anexinet.com/blog/non-privileged-rbac-user-administration-in-kubernetes/

https://imti.co/team-kubernetes-remote-access/

