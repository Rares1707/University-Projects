from typing import List

GRAVITATIONAL_CONSTANT = 6.6743e-11

def vector_scalar_multiplication(vector: List[float], scalar: float):
    for i in range(len(vector)):
        vector[i] *= scalar
    return vector

def vector_scalar_division(vector: List[float], scalar: float):
    for i in range(len(vector)):
        vector[i] /= scalar
    return vector

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
    
    def compute_distance(self, other_body: Body):
        x_distance = self.position[0] - other_body.position[0]
        y_distance = self.position[1] - other_body.position[1]
        z_distance = self.position[2] - other_body.position[2]
        return (x_distance**2 + y_distance**2 + z_distance**2)**0.5


    def compute_gravitational_attraction(self, other_body: Body):
        squared_distance = self.compute_distance(other_body)**2
        return GRAVITATIONAL_CONSTANT * self.mass * other_body.mass / squared_distance

    def move(self, bodies):
        """
        Discrete physics.
        Time between object movement is exactly one second.
        This is still napkin physics because we take into account only the final acceleration.
        """
        resulting_force = vector_scalar_multiplication(self.acceleration * self.mass)
        for body in bodies:
            if body.id == self.id:
                continue
            attraction = self.compute_gravitational_attraction(body)
            resulting_force = vector_addition(resulting_force, attraction)

        self.acceleration = vector_addition(self.acceleration, vector_scalar_division(resulting_force, self.mass))
        self.velocity = vector_addition(self.velocity, self.acceleration)
        self.position = vector_addition(self.position, self.velocity)
        self.position = vector_addition(self.position, vector_scalar_division(self.acceleration, 2))

            

        
        
