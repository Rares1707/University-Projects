# 1. Methodology
## Tasks
WANNs with undifferentiable activations will be tested on MNIST digit classification (https://yann.lecun.com/exdb/mnist/) and 2 continous control tasks:
+ CartPoleSwingUp (https://arxiv.org/abs/1606.01540): A 2D system formed of a pole and a cart is given. The model must control the movement of the cart (without going out of the bounds of the track) so that it swings the pole up and keeps it upright (90 degree angle with the ground). The pole starts from a resting position (270 degree angle with the ground)
+ BipedalWalker-v2 (https://arxiv.org/abs/1606.01540): The goal is to guide a two-legged agent across randomly generated 2D terrain. Each leg is controlled by a knee and a hip joint and has 24 inputs (including LIDAR sensors for detecting terain and other information such as the joints' speed). Rewards are awarded for distance traveled.
The environments and evaluation will be identical to the ones used in https://arxiv.org/abs/1906.04358.
## Comparison
I will compare my results with those of the original WANN paper. I will compare model size, convergence rate and how well the tasks are performed.
## Mathematical modelling
Both continous control tasks are mathematically described in https://arxiv.org/abs/1606.01540. 

Image classification works like this: the WANN receives all images from the test set and must predict the class for each one. The metric used for evaluating its prediction is accuracy = number of correct predictions / total number of predictions.

# 2. Case study
I used the repository of the original WANN paper and expanded it.

Experiments were made on the classification task.

Experiment 1:
+ run the the evolutionary algorithm (all hyperparameters exactly as in the original paper) for 120 generations on the MNIST training
+ evaluate the resulting WANN on the test set with a sweep of 10 global weights in the range [-2, 2]
+ results:
    + mean accuracy across all global weights: 0.55 
    + highest accuracy: 0.6299 (with weights set to 1.(9))
    + model size: 187

Experiment 2:
+ run the the evolutionary algorithm (all hyperparameters exactly as in the original paper) for 120 generations on the MNIST training but add 5 nondifferentiable functions to the activations set: 
    + x/|x| 
    + 1/x
    + sin(x)/x
    + 1/(x^2)
    + sin(1/x)
+ for all of the above x becomes 0.0001 if it is equal to 0 to avoid division by 0
+ evaluate the resulting WANN on the test set with a sweep of 10 global weights in the range [-2, 2]
+ results:
    + mean accuracy across all global weights: 0.43
    + highest accuracy: 0.5209 (with weights set to -2)
    + model size: 202

## Interpreting the results
The resulting WANN of the evolutionary search is worse at performing the classification task when adding undifferentiable functions to the search space, but this is expected. The search space of the activations is 55% larger and convergence didn't occur in any of the experiments because the evolutionary algorithm wasn't allowed to run for enough generations. The extended WANN would need to run for more generations than the original one to achieve convergence. Additionally, more numerous generations would benefit the extended WANN because it would allow it to sample a higher percentage of the activations. Because of the larger size of the extended model, we can deduce that not enough individuals sampled satisfactory activations, thus leading in more connections and increased model size. 

Another important factor to take into account is the quality of the newly added activations. Many of them might not be good candidates simply because they tend to infinity when x approaches 0, thus completely breaking the information flow of the networks because of the lack of normalization.

# 3. Related work
Researchers have tried many different methods of training neural networks which stand apart from the traditional gradient-based one. Pruning randomly initialized NNs to find "lottery tickets" (smaller models wich can already perform the task without needing to train their weights) has shown impressive results https://arxiv.org/abs/1905.01067 https://arxiv.org/abs/1911.13299 https://proceedings.mlr.press/v119/malach20a.html. Others have tried using discontinous activations in networks to improve performance https://www.sciencedirect.com/science/article/pii/S0167278905005063 https://www.sciencedirect.com/science/article/pii/S089360801730062X https://ieeexplore.ieee.org/document/1242840. My aproach is a combination of the latter and the one used by Weight Agnostic Neural Networks https://arxiv.org/abs/1906.04358.It is worth noting that some researchers have experimented with learning both weights and connections https://arxiv.org/abs/1506.02626.

## Weigth Agnostic Neural Networks
WANNs are created through architecture search that uses evolutionary algorithms. All weights are set to the same value and the network learns its architecture (nodes, connections, activations). The evolutionary algorithm tests them on a set of weights from a predefined range to make sure that they work well regardless of the weights used.

## Improving WANNs
Since WANNs don't need to be trained with gradient-based methods to perform well, they aren't limited by the need for differentiability, thus we can model neuron activations using a vaster array of functions. For example, WANNs could use step functions as excitation operations https://arxiv.org/abs/1709.01507v4 for the outputs of the nodes that connect to it. 

## Expected results
Extended WANNs could perform tasks better than their counterparts, but also be smaller in size. Why? As described in https://arxiv.org/abs/1708.02691, NNs approximate functions, but if the function that a WANN tries to approximate is already in the search space of the activations, then it can simply use it instead of adding numerous nodes and connections to approximate it. 

Regarding task performance, even though convergence will be slower, extended WANNs might show better results due to the nature of the tasks. For example, if the function which perfectly solves a tasks is not differentiable, then a classical NN can only approximate it, while extended WANNs have the potential of becoming that function.

# 4. Repository and history
The **private** repository is at https://github.com/Rares1707/Extending-WANNs. 

I don't have the history because I started coding before carefully reading the assignment. I worked on the repository many hours in 2 days: the first day for making it run and the second for extending (and understanding) the repo and for running the 2 small experiments.