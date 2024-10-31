# Schita cuprinsului:
+ Abstract
+ Introduction
+ Related Work
+ Motivation
+ Choice of activations
+ Experimental Results
    + Performance of WANNs with Discontinuous Activations
    + Distilling knowledge into WANNs with Discontinuous Activations
    + Visualization
+ Discussion and Future Research
+ Acknowledgements
+ References

# Plan pentru partea aplicativa a lucrarii:
**Ipoteza:**
+ improving the performance (prediction quality or model size) of WANNs through the use of discontinuous activations 

**Methodology:**
+ search for related work regarding architecture search, discontinuous activations and knowledge distillation
+ carry out experiments
+ analyze experimental results 
+ draw conclusions
+ write the paper

**Original approach:**
+ adding discontinuous activations to WANNs
+ distilling knowledge into WANNs

**Experiments:**
1. Add discontinous activations to WANNs and measure their performance on MNIST Digit classification and other datasets
2. Add discontinous activations to WANNs and measure their performance on continous control tasks suchs as CartPoleSwingUp, BipedalWalker-v2 and CarRacing-v0
3. Knowledge distillation from simple WANNs into WANNs with Discontinous activations
4. Knowledge distillation from large networks (suchs as ResNet50) into simple WANNs and WANNs with Discontinous activations

# Posibila contributie originala
### Contribution:
+ showing the benefits of removing the limits particular to gradient optimization methods
+ improving the power of knowledge distillation
+ creating much smaller and efficient neural networks
### Questions answered:
+ Do NNs with discontinous activations perform better than classical NNs?
+ Are NNs trying to approximate discontinous functions?
+ Can knowledge be distilled effectively into WANNs when adding discontinous activations?

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

<a id="11"></a>
[11] Gou, Jianping, Baosheng Yu, Stephen J. Maybank, and Dacheng Tao. "Knowledge distillation: A survey." International Journal of Computer Vision 129, no. 6 (2021): 1789-1819.

<a id="11"></a>
[12] Stanley, Kenneth O., Jeff Clune, Joel Lehman, and Risto Miikkulainen. "Designing neural networks through neuroevolution." Nature Machine Intelligence 1, no. 1 (2019): 24-35.

<a id="12"></a>
[13] Bullmore, Ed, and Olaf Sporns. "Complex brain networks: graph theoretical analysis of structural and functional systems." Nature reviews neuroscience 10, no. 3 (2009): 186-198.

<a id="13"></a>
[13] Gal, Yarin. "Uncertainty in deep learning." (2016).

<a id="14"></a>
[14] Han, Song, Jeff Pool, John Tran, and William Dally. "Learning both weights and connections for efficient neural network." Advances in neural information processing systems 28 (2015).

<a id="15"></a>
[15] He, Yong, and Alan Evans. "Graph theoretical modeling of brain connectivity." Current opinion in neurology 23, no. 4 (2010): 341-350.

<a id="16"></a>
[16] Hinton, Geoffrey E., and Drew Van Camp. "Keeping the neural networks simple by minimizing the description length of the weights." In Proceedings of the sixth annual conference on Computational learning theory, pp. 5-13. 1993.

<a id="17"></a>
[17] Carnevale, Nicholas T., and Michael L. Hines. The NEURON book. Cambridge University Press, 2006.

<a id="18"></a>
[18] Hines, Michael L., and Nicholas T. Carnevale. "The NEURON simulation environment." Neural computation 9, no. 6 (1997): 1179-1209.

<a id="19"></a>
[19] Hanin, Boris. "Universal function approximation by deep neural nets with bounded width and relu activations." Mathematics 7, no. 10 (2019): 992.
