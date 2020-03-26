# SuanMing: Experiment-controller
Experiment controller for evaluation experiments of the SuanMing project. 
Currently provides five different setups conducting the necessary measurements.

## Usage

### Prerequisites
The following prerequesites need to be met:

- A running kubernetes cluster with a configured `kubectl` CLI.

### Run an experiment

There are different experiments available, organized in the `experimentX.sh` scripts and the according `experimentX.yaml` files in the `kubernetes` folder. Although the use of the scripts directly is possible, we recommend using the provided kubernetes jobs.
 
#### Setup: Roles
First, the jobs need to be associated with the required rights in order to be able to work from within the kubernetes cluster.
To do so execute: 
 
     kubectl apply -f kubernetes/create-role.yaml
      
The created role can afterwards be deleted using `kubectl delete -f kubernetes/create-role.yaml`. 
<!--If you just want to ensure that the role is in place, you can use `kubectl apply -f kubernetes/create-role.yaml`.-->
  
#### Execute experiment
If the roles are created accordingly you can launch the desired experiment by using `create` with the respective `.yaml`.
Example:
 
    kubectl create -f kubernetes/experiment1.yaml
      
This will launch a Kubernetes Job that will spin up the experiment environment, conduct the experiments, and then tear down the environment. 
After completion, the Pod will still be available for log analysis, until it is deleted using `kubectl delete -f kubernetes/experiment1.yaml`.
