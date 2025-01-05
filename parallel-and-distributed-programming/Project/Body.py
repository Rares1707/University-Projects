from typing import List
import math

GRAVITATIONAL_CONSTANT = 6.6743e-11

def vector_scalar_multiplication(vector: List[float], scalar: float):
    result = []
    for i in range(len(vector)):
        result.append(vector[i] * scalar)
    return result

def vector_scalar_division(vector: List[float], scalar: float):
    result = []
    for i in range(len(vector)):
        result.append(vector[i] / scalar)
    return result

def vector_addition(first_vector: List[float], second_vector: List[float]):
    """
    Vectors must be of the same size
    """
    result = []
    for i in range(len(first_vector)):
        result.append(first_vector[i] + second_vector[i])
    return result

class Body:
    """
    This is not ideal because the interaction between each two bodies will be computed twice.
    We ignore collisions.
    """

    def __init__(self, id: int, mass: float, position: List[float], acceleration: List[float]):
        """
        All bodies exist in 3D space and have mass. 
        We ignore shape, rotation, and other physics factors because they wouldn't affect the communication mechanisms.
        """
        self.id = id
        self.velocity = [0, 0, 0]
        self.mass = mass
        self.gravitational_force = mass
        self.position = position
        self.acceleration = acceleration

    def compute_distance_vector(self, other_body: 'Body') -> List[float]: 
        return [self.position[i] - other_body.position[i] for i in range(3)] 
    
    def compute_gravitational_attraction(self, other_body: 'Body') -> List[float]: 
        distance_vector = self.compute_distance_vector(other_body) 
        distance_magnitude = sum(d**2 for d in distance_vector) ** 0.5

        if distance_magnitude == 0: 
            raise ValueError("Distance between bodies is zero. Gravitational force is undefined.") 
        
        force_magnitude = GRAVITATIONAL_CONSTANT * self.mass * other_body.mass / distance_magnitude**2 
        force_vector = [-force_magnitude * d / distance_magnitude for d in distance_vector] 
    
        return force_vector


    def move(self, bodies: List['Body']):
        """
        Discrete physics.
        Time between object movement is exactly one second.
        This is still napkin physics because we take into account only the final acceleration.
        """
        resulting_force = vector_scalar_multiplication(self.acceleration, self.mass)
        for body in bodies:
            if body.id == self.id:
                continue
            attraction = self.compute_gravitational_attraction(body)
            resulting_force = vector_addition(resulting_force, attraction)

        self.acceleration = vector_addition(self.acceleration, vector_scalar_division(resulting_force, self.mass))
        self.velocity = vector_addition(self.velocity, self.acceleration)
        self.position = vector_addition(self.position, self.velocity)
        self.position = vector_addition(self.position, vector_scalar_division(self.acceleration, 2))

            

        
        
