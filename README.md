# SuanMing: Experiment-controller
Experiment controller for evaluation experiments of the SuanMing project. 
Currently provides five different setups conducting the necessary measurements.

## Usage

### Prerequisites
The following prerequesites need to be met:

- A running kubernetes cluster with a configured `kubectl` CLI.

### Run an experiment

There are different experiments available, organized in the `experimentX.sh` scripts and the according `controllerX.yaml` files in the `kubernetes` folder.
