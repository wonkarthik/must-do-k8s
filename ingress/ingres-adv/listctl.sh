echo "container-name,container-image,requests-cpu,requests-mem,limit-cpu,limit-mem"
kubectl get po --all-namespaces -o=jsonpath='{range .items[*]}{range .spec.containers[*]}{.name}{","}{.image}{","}{.resources.requests.cpu}{","}{.resources.requests.memory}{","}{.resources.limits.cpu}{","}{.resources.limits.memory}{"\n"}{end}{range .spec.initContainers[*]}{.name}{","}{.image}{","}{.resources.requests.cpu}{","}{.resources.requests.memory}{","}{.resources.limits.cpu}{","}{.resources.limits.memory}{"\n"}{end}{end}'

# kubectl get pods --all-namespaces -o=jsonpath='{range .items[*]}{.metadata.name}{","}{..namespace}{","}{..status.phase}{","}{..status.containerStatuses[].image}{","}{..status.initContainerStatuses[].image}{"\n"}{end}'

