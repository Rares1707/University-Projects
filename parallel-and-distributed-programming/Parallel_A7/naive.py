import numpy as np

def naive_polynomial_multiplication(p1, p2):
    result = np.zeros(len(p1) + len(p2) - 1)
    for i in range(len(p1)):
        for j in range(len(p2)):
            result[i + j] += p1[i] * p2[j]
    return result