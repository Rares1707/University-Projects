import numpy as np  

def add_polynomials(p1, p2):
    n = max(len(p1), len(p2))
    result = np.zeros(n)
    for i in range(n):
        if i < len(p1):
            result[i] += p1[i]
        if i < len(p2): 
            result[i] += p2[i]
    return result

def subtract_polynomials(p1, p2):
    n = max(len(p1), len(p2))
    result = np.zeros(n)
    for i in range(n):
        if i < len(p1):
            result[i] += p1[i]
        if i < len(p2): 
            result[i] -= p2[i]
    return result