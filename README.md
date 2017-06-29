# arc_cosine_kernels
Experimentation with arccosine kernels, with a softmax perceptron for classification, and a use of isomap. Based on the paper Kernel Methods for Deep Learning by Youngmin Cho and Lawrence K. Saul.

A distance matrix for the COIL-100 dataset.

![image](kernel_dist_coil_1_2.jpg)

and the corresponding ISOMAP embedding with 50 neighbors.

![image](res_coil_1_2.jpg)

Now, a distance matrix for a training subset of the MNIST dataset.

![image](kernel_dist_mnist.jpg)

and the corresponding ISOMAP embedding with 50 neighbors.

![image](isomap_mnist.jpg)

And the error plot for the training of a softmax layer over the kernels, a crude approximation for a multiclass SVM.

![image](error_mnist_1_2.jpg)

and the W obtained:

![image](w_mnist.jpg)
