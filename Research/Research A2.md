

### [[1]](#1) Gaier, Adam, and David Ha. "Weight agnostic neural networks." Advances in neural information processing systems 32 (2019).
+ The backbone of my paper. I will try to extend this, mainly by adding discontinuous/undifferentiable activation functions
+ It proposes proposes a search method for neural network architectures that can already perform a task without any explicit weight training
+ Cited by 324
+ 129 references
+ BibLaTeX citation style
+ Structure:
    + Title
    + Abstract
    1. Introduction
    2. Related Work
    3. Weight Agnostic Neural Network Search
    4. Experimental Results
    5. Discussion and Future Work
    + Acknowledgements
    + Supplementary Materials for Weight Agnostic Neural Networks
    + References

### [[2]](#2) Miller, Brad L., and David E. Goldberg. "Genetic algorithms, tournament selection, and the effects of noise." Complex systems 9, no. 3 (1995): 193-212.
+ Will be useful for my architecture search method
+ It's about the convergence of genetic algorithms that use tournament selection
+ Cited by 1659
+ 10 references
+ BibLaTex citation style
+ Structure: 
    + Title
    + Abstract
    1. Introduction
    2. Background
    3. Tournament selection in deterministic environments
    4. Tournament selection in noisy environments
    5. Validation of model
    6. Future Research
    7. Conclusions
    8. Acknowledgements
    + References

### [[3]](#3) Zhou, Hattie, Janice Lan, Rosanne Liu, and Jason Yosinski. "Deconstructing lottery tickets: Zeros, signs, and the supermask." Advances in neural information processing systems 32 (2019).

### [[4]](#4) Ramanujan, Vivek, Mitchell Wortsman, Aniruddha Kembhavi, Ali Farhadi, and Mohammad Rastegari. "What's hidden in a randomly weighted neural network?." In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition, pp. 11893-11902. 2020.
+ Not sure how it will help me, but it's too cool not to at least mention it since it's related to my paper, but from a different direction. Aaand maybe I could try pruning the networks I find 
+ From the Abstract: "we demonstrate that randomly weighted neural networks contain subnetworks which achieve impressive performance without ever modifying the weight values. Hidden in a randomly weighted Wide ResNet-50 we find a subnetwork (with random weights) that is smaller than, but matches the performance of a ResNet-34 trained on ImageNet"
+ Cited by 361
+ 34 references
+ IEEE citation style
+ Structure: 
    + Title
    1. Introduction
    2. Related work
    3. Method 
    4. Experiments
    5. Conclusion 
    + Acknowledgements
    + References
    + A. Table of ImageNet Results
    + B. Additional Technical Details
    + C. Additional Experiments

### [[5]](#5) Malach, Eran, Gilad Yehudai, Shai Shalev-Schwartz, and Ohad Shamir. "Proving the lottery ticket hypothesis: Pruning is all you need." In International Conference on Machine Learning, pp. 6682-6691. PMLR, 2020.

### [[6]](#6) Orseau, Laurent, Marcus Hutter, and Omar Rivasplata. "Logarithmic pruning is all you need." Advances in Neural Information Processing Systems 33 (2020): 2925-2934.

### [[7]](#7) Forti, Mauro, M. Grazzini, Paolo Nistri, and Luca Pancioni. "Generalized Lyapunov approach for convergence of neural networks with discontinuous or non-Lipschitz activations." Physica D: Nonlinear Phenomena 214, no. 1 (2006): 88-99.

### [[8]](#8) Ding, Xiaoshuai, Jinde Cao, Ahmed Alsaedi, Fuad E. Alsaadi, and Tasawar Hayat. "Robust fixed-time synchronization for uncertain complex-valued neural networks with discontinuous activation functions." Neural Networks 90 (2017): 42-55.

### [[9]](#9) Forti, Mauro, and Paolo Nistri. "Global convergence of neural networks with discontinuous neuron activations." IEEE Transactions on Circuits and Systems I: Fundamental Theory and Applications 50, no. 11 (2003): 1421-1435.
+ I want to see what discontinous activation functions people tried to use in neural networks
+ The paper performs an analysis of global convergence for a large class of neural networks where the neuron activations are modeled by discontinuous functions
+ Cited by 484
+ 30 references
+ IEEE citation style
+ Structure:
    + Title
    + Abstract
    1. Introduction
    2. Neural Network Model and Problem Formulation
    3. Existance and Uniqueness of Equilibrium Point
    4. Global Convergence of Neural Network
    5. Stronger Global Convergence. Properties of Neural Network
    6. Conclusion
    + Appendix 
    + Acknowledgement
    + References


### [[10]](#10) Hinton, Geoffrey. "Distilling the Knowledge in a Neural Network." arXiv preprint arXiv:1503.02531 (2015).
+ I will try to search for weight agnostic networks which distill the knwoledge of larger networks
+ It's about distilling the knowledge of network ensembles into single networks
+ Cited by 21597  
+ 9 references
+ ACM citation style
+ Structure:
    + Title
    + Abstract
    1. Introduction
    2. Distillation
    3. Preliminary experiments on MNIST
    4. Experiments on speech recognition
    5. Training ensembles of specialists on very big datasets
    6. Soft Targets as Regularizers
    7. Relationship to Mixtures of Experts
    8. Discussion
    + Aknowledgements
    + References


# References
<a id="1"></a>
[1] Gaier, Adam, and David Ha. "Weight agnostic neural networks." Advances in neural information processing systems 32 (2019).

<a id="2"></a>
[2] Miller, Brad L., and David E. Goldberg. "Genetic algorithms, tournament selection, and the effects of noise." Complex systems 9, no. 3 (1995): 193-212.

<a id="3"></a>
[3] Zhou, Hattie, Janice Lan, Rosanne Liu, and Jason Yosinski. "Deconstructing lottery tickets: Zeros, signs, and the supermask." Advances in neural information processing systems 32 (2019).

<a id="4"></a>
[4] Ramanujan, Vivek, Mitchell Wortsman, Aniruddha Kembhavi, Ali Farhadi, and Mohammad Rastegari. "What's hidden in a randomly weighted neural network?." In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition, pp. 11893-11902. 2020.

<a id="5"></a>
[5] Malach, Eran, Gilad Yehudai, Shai Shalev-Schwartz, and Ohad Shamir. "Proving the lottery ticket hypothesis: Pruning is all you need." In International Conference on Machine Learning, pp. 6682-6691. PMLR, 2020.

<a id="6"></a>
[6] Orseau, Laurent, Marcus Hutter, and Omar Rivasplata. "Logarithmic pruning is all you need." Advances in Neural Information Processing Systems 33 (2020): 2925-2934.

<a id="7"></a>
[7] Forti, Mauro, M. Grazzini, Paolo Nistri, and Luca Pancioni. "Generalized Lyapunov approach for convergence of neural networks with discontinuous or non-Lipschitz activations." Physica D: Nonlinear Phenomena 214, no. 1 (2006): 88-99.

<a id="8"></a>
[8] Ding, Xiaoshuai, Jinde Cao, Ahmed Alsaedi, Fuad E. Alsaadi, and Tasawar Hayat. "Robust fixed-time synchronization for uncertain complex-valued neural networks with discontinuous activation functions." Neural Networks 90 (2017): 42-55.

<a id="9"></a>
[9] Forti, Mauro, and Paolo Nistri. "Global convergence of neural networks with discontinuous neuron activations." IEEE Transactions on Circuits and Systems I: Fundamental Theory and Applications 50, no. 11 (2003): 1421-1435.

<a id="10"></a>
[10] Hinton, Geoffrey. "Distilling the Knowledge in a Neural Network." arXiv preprint arXiv:1503.02531 (2015).
