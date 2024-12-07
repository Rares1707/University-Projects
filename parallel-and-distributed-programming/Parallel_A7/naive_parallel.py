import numpy as np

def naive_polynomial_multiplication_parallel(p1, p2, rank, size, comm):
    chunk_size = len(p1) // size
    start = rank * chunk_size
    end = (rank + 1) * chunk_size
    if rank == size - 1:
        end = len(p1)

    result = np.zeros(len(p1) + len(p2) - 1)
    for i in range(start, end):
        for j in range(len(p2)):
            result[i + j] += p1[i] * p2[j]

    results = comm.gather(result, root=0)
    if rank == 0:
        final_result = np.zeros(len(p1) + len(p2) - 1)
        for result in results:
            final_result += result
        return final_result
    else:
        return None