from utils import *
from naive import naive_polynomial_multiplication
from karatsuba import karatsuba_polynomial_multiplication

def karatsuba_polynomial_multiplication_parallel(p1, p2, rank, size, comm):
    n = max(len(p1), len(p2))
    if n <= 100:
        return naive_polynomial_multiplication(p1, p2)
    half = (n + 1) // 2

    if rank == 1:
        a = p1[:half]
        c = p2[:half]

        ac = karatsuba_polynomial_multiplication(a, c)
        comm.send(ac, dest=0)

    if rank == 2:
        b = p1[half:]
        d = p2[half:]

        bd = karatsuba_polynomial_multiplication(b, d)
        comm.send(bd, dest=0)
    
    if rank == 0:
        a = p1[:half]
        b = p1[half:]
        c = p2[:half]
        d = p2[half:]

        temp = karatsuba_polynomial_multiplication(add_polynomials(a, b), add_polynomials(c,d))
        ac = comm.recv(source=1) #karatsuba_polynomial_multiplication(a, c)
        bd = comm.recv(source=2) #karatsuba_polynomial_multiplication(b, d)
        second_term = subtract_polynomials(temp, add_polynomials(ac, bd))

        result = np.zeros(2 * n - 1)
        result[:len(ac)] += ac
        result[half : half + len(second_term)] += second_term
        result[half * 2 : half * 2 + len(bd)] += bd

        return result