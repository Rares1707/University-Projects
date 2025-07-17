from Body import Body
import random
from typing import List
from time import time
import copy
import threading

NUMBER_OF_BODIES = 128
STEPS = 100
NUM_THREADS = 6

def init_bodies(number_of_bodies) -> List[Body]:
    random.seed(42)
    bodies = []
    for i in range(number_of_bodies):
        mass = random.uniform(10, 100)
        position =  [random.uniform(-1e5, 1e5) for _ in range(3)]
        acceleration = [random.uniform(-1, 1) for _ in range(3)]   
        body = Body(id=i, mass=mass, position=position, acceleration=acceleration)
        bodies.append(body)
    return bodies
    
def centralized_solution(bodies: List[Body]) -> List[Body]:
    bodies = copy.deepcopy(bodies)
    for i in range(STEPS):
        for body in bodies:
            body.move(bodies)
    return bodies


def solutions_are_the_same(mpi_solution: List[Body], centralized_solution: List[Body]) -> bool:
    for i in range(len(centralized_solution)):
        mpi_body = mpi_solution[i]
        centralized_body = centralized_solution[i]

        if mpi_body.id != centralized_body.id:
            print('Something is wrong, bodies got shuffled and IDs do not match')

        if not all(mpi_body.position[i] == centralized_body.position[i] for i in range(3)):
            return False
        
    return True

def process_chunk(bodies: List[Body], start: int, end: int, barrier: threading.Barrier) -> None:
    for _ in range(STEPS):
        for i in range(start, end):
            bodies[i].move(bodies)
        barrier.wait()

def parallelized_solution(bodies: List[Body]) -> List[Body]:
    bodies = copy.deepcopy(bodies)
    chunk_size = len(bodies) // NUM_THREADS
    barrier = threading.Barrier(NUM_THREADS)

    threads = []
    for i in range(NUM_THREADS):
        start = i * chunk_size
        if i != NUM_THREADS - 1:
            end = start + chunk_size
        else:
            end = len(bodies)
        thread = threading.Thread(target=process_chunk, args=(bodies, start, end, barrier))
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

    return bodies

def main():
    bodies = init_bodies(NUMBER_OF_BODIES)

    starting_time = time()
    solution = centralized_solution(bodies)
    end_time = time()
    print(f'Centralized duration: {end_time - starting_time}ms')

    starting_time = time()
    thpExec_solution = parallelized_solution(bodies)
    end_time = time()
    print(f'Threaded duration: {end_time - starting_time}ms')

    print(f'Both implementations gave the same solution: {solutions_are_the_same(thpExec_solution, solution)}')
    # print(f'Both implementations gave the same solution: {solutions_are_the_same(multiproc_solution, thpExec_solution)}')
    print(solution[0].position)
    print(thpExec_solution[0].position)


if __name__ == "__main__":
    main()