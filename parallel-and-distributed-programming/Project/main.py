from Body import Body
import random
from typing import List

NUMBER_OF_BODIES = 128
STEPS = 100

def init_bodies(number_of_bodies) -> List[Body]:
    random.seed(42)
    bodies = []
    for i in range(number_of_bodies):
        mass = random.uniform(10, 100) # smaller than earth
        position =  [random.uniform(-1e5, 1e5) for _ in range(3)]
        acceleration = [random.uniform(-1, 1) for _ in range(3)]   
        body = Body(id=i, mass=mass, position=position, acceleration=acceleration)
        bodies.append(body)
    return bodies
    
def main():
    bodies = init_bodies(NUMBER_OF_BODIES)
    for body in bodies:
        print(f'Id: {body.id}; Mass: {body.mass}; Position: {body.position}; Velocity: {body.velocity}; Acceleration: {body.acceleration}')

    for i in range(STEPS):
        #print('-------------------------------------------------')
        #print(f'Step {i}')
        for body in bodies:
            body.move(bodies)
            #print(f'Id: {body.id}; Position: {body.position}; Velocity: {body.velocity}; Acceleration: {body.acceleration}')

    print('-------------------------------------------------')
    for body in bodies:
        print(f'Id: {body.id}; Position: {body.position}; Velocity: {body.velocity}; Acceleration: {body.acceleration}')
            

if __name__ == "__main__":
    main()