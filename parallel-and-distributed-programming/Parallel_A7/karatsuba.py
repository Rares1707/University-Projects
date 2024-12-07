from utils import *
from naive import naive_polynomial_multiplication

def karatsuba_polynomial_multiplication(p1, p2):
    n = max(len(p1), len(p2))
    if n <= 100:
        return naive_polynomial_multiplication(p1, p2)
    
    half = (n + 1) // 2

    a = p1[:half]
    b = p1[half:]
    c = p2[:half]
    d = p2[half:]

    ac = karatsuba_polynomial_multiplication(a, c)
    bd = karatsuba_polynomial_multiplication(b, d)
    temp = karatsuba_polynomial_multiplication(add_polynomials(a, b), add_polynomials(c,d))
    second_term = subtract_polynomials(temp, add_polynomials(ac, bd))

    result = np.zeros(2 * n - 1)
    result[:len(ac)] += ac
    result[half : half + len(second_term)] += second_term
    result[half * 2 : half * 2 + len(bd)] += bd

    return result