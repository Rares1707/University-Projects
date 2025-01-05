from Body import Body
import random
from typing import List
from mpi4py import MPI
from time import time
import copy

NUMBER_OF_BODIES = 128
STEPS = 100

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

def main():
    """
    Results are as expected. Running the MPI implementation on 6 cores gave a x3 speed improvement 
    because it had to do twice as many computations for the gravitational forces
    """
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()

    if rank == 0:
        bodies = init_bodies(NUMBER_OF_BODIES)
        starting_time = time()
        solution = centralized_solution(bodies)
        end_time = time()
        print(f'Centralized duration: {end_time - starting_time}ms')
    else:
        bodies = None

    bodies = comm.bcast(bodies, root=0)

    chunk_size = len(bodies) // size
    start = rank * chunk_size
    if rank != size - 1:
        end = start + chunk_size
    else:
        end = len(bodies)

    if rank == 0:
        starting_time = time()

    for _ in range(STEPS):
        # each process computes the movement of its chunk of bodies
        for j in range(start, end):
            bodies[j].move(bodies)
        comm.barrier() # wait for everyone to finish the step

        all_chunks = comm.gather(bodies[start:end], root=0)
        if rank == 0:
            # flatten
            bodies = []
            for chunk in all_chunks: 
                bodies.extend(chunk)
        bodies = comm.bcast(bodies, root=0)

    if rank == 0:
        end_time = time()
        print(f'MPI duration: {end_time - starting_time}ms')
        print(f'Both implementations gave the same solution: {solutions_are_the_same(bodies, solution)}')
        print(bodies[0].position)

    # if rank == 0:
    #     print('-------------------------------------------------')
    #     for body in bodies:
    #         print(f'Id: {body.id}; Position: {body.position}; Velocity: {body.velocity}; Acceleration: {body.acceleration}')
            

if __name__ == "__main__":
    main()