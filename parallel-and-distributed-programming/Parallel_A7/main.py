import mpi4py.MPI as MPI
import numpy as np
from time import time
from utils import *
from naive import naive_polynomial_multiplication
from naive_parallel import naive_polynomial_multiplication_parallel
from karatsuba import karatsuba_polynomial_multiplication
from karatsuba_parallel import karatsuba_polynomial_multiplication_parallel

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

# p1 = np.array([1, 2, 3, 4])
# p2 = np.array([5, 6, 7, 8])

p1 = np.ones(2000)
p2 = np.ones(2000)

if rank == 0:
    print('---------------------------------------------------------------------')
    start = time()
    result_naive = naive_polynomial_multiplication(p1, p2)
    end = time()
    print(f"Naive Polynomial Multiplication: {end - start}ms\n{result_naive}")

    start = time()
    result_karatsuba = karatsuba_polynomial_multiplication(p1, p2)
    end = time()
    print(f"\nKaratsuba Polynomial Multiplication: {end - start}ms\n{result_karatsuba}")

if size >= 3: # Karatsuba won't be parallelized unless we have at least 3 processes
    start = time()
    result_naive_parallel = naive_polynomial_multiplication_parallel(p1, p2, rank, size, comm)
    end = time()
    duration1 = end - start

    start = time()
    result_karatsuba_parallel = karatsuba_polynomial_multiplication_parallel(p1, p2, rank, size, comm)
    end = time()
    duration2 = end - start

    if rank == 0:
        print(f"\nNaive Polynomial Multiplication (Parallel): {duration1}ms\n{result_naive_parallel}")
        print(f"\nKaratsuba Polynomial Multiplication (Parallel): {duration2}ms\n{result_karatsuba_parallel}")

if rank == 0:
    print('---------------------------------------------------------------------')


