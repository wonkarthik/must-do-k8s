 Helm will have created a number of files and directories.
```sh
 Chart.yaml          - the metadata for your Helm Chart.
 values.yaml         - values that can be used as variables in your templates.
 templates/*.yaml    - Example Kubernetes manifests.
 _helpers.tpl        - helper functions that can be used inside the templates.
 templates/NOTES.txt - templated notes that are displayed on Chart install.

# creating a helm Chart
  helm create jenkins 

# Deploying the application with helm chart
  helm install --name jenkins-blueocean ./jenkins --set service.type=NodePort

# To Debug to inspect the helm application
  helm install --dry-run --debug ./jenkins

# To Test the helm application
  helm lint ./jenkins 

# Package the application and share 
  helm package ./jenkins
  helm install --name jenkins-blueocean1 jenkins-blueocean-0.1.0.tgz --set service.type=NodePort
  
  # helm serve command to run a local repository to serve our chart.
  helm serve
  helm search local
  helm install --name jenkins-blueocean2 local/jenkins-blueocean --set service.type=NodePort
  ```


### General Usage
```sh
  helm list --all
  helm repo (list|add|update)
  helm search
  helm inspect <chart-name>
  helm install --set a=b -f config.yaml <chart-name> -n <release-name> # --set take precedented, merge into -f
  helm status <deployment-name>
  helm delete <deployment-name>
  helm inspect values <chart-name>
  helm upgrade -f config.yaml <deployment-name> <chart-name>
  helm rollback <deployment-name> <version>

  helm create <chart-name>
  helm package <chart-name>
  helm lint <chart-name>

  helm dep up <chart-name> # update dependency
  helm get manifest <deployment-name> # prints out all of the Kubernetes resources that were uploaded to the server
  helm install --debug --dry-run <deployment-name> # it will return the rendered template to you so you can see the output
  helm lint ./rabbitmq-server/ --debug
  helm fetch --untar stable/rabbitmq
  here rabbitmq is release name 
  helm ls  
  helm upgrade rabbitmq .

  helm rollback rabbitmq 1
```
