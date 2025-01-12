//
// Created by Rares on 12.01.2025.
//

#ifndef C___IMPLEMENTATION_FOR_THREADS_BODY_H
#define C___IMPLEMENTATION_FOR_THREADS_BODY_H

#include <vector>
#include <cmath>

using namespace std;

const double GRAVITATIONAL_CONSTANT = 6.6743e-11;

vector<double> vector_scalar_multiplication(const vector<double>& vector, double scalar) {
    std::vector<double> result;
    for (double value : vector) {
        result.push_back(value * scalar);
    }
    return result;
}

vector<double> vector_scalar_division(const vector<double>& vector, double scalar) {
    std::vector<double> result;
    for (double value : vector) {
        result.push_back(value / scalar);
    }
    return result;
}

vector<double> vector_addition(const vector<double>& first_vector, const vector<double>& second_vector) {
    vector<double> result;
    for (size_t i = 0; i < first_vector.size(); ++i) {
        result.push_back(first_vector[i] + second_vector[i]);
    }
    return result;
}

class Body {
public:
    Body(int id, double mass, const vector<double>& position, const vector<double>& acceleration)
            : id(id), mass(mass), position(position), acceleration(acceleration), velocity({0, 0, 0}) {}

    vector<double> compute_distance_vector(const Body& other_body) const {
        vector<double> distance_vector(3);
        for (int i = 0; i < 3; ++i) {
            distance_vector[i] = position[i] - other_body.position[i];
        }
        return distance_vector;
    }

    vector<double> compute_gravitational_attraction(const Body& other_body) const {
        vector<double> distance_vector = compute_distance_vector(other_body);
        double distance_magnitude = sqrt(accumulate(distance_vector.begin(), distance_vector.end(), 0.0, [](double a, double b) { return a + b * b; }));

        if (distance_magnitude == 0) {
            throw runtime_error("Distance between bodies is zero. Gravitational force is undefined.");
        }

        double force_magnitude = GRAVITATIONAL_CONSTANT * mass * other_body.mass / (distance_magnitude * distance_magnitude);
        vector<double> force_vector(3);
        for (int i = 0; i < 3; ++i) {
            force_vector[i] = -force_magnitude * distance_vector[i] / distance_magnitude;
        }

        return force_vector;
    }

    void move(const vector<Body>& bodies) {
        vector<double> resulting_force = vector_scalar_multiplication(acceleration, mass);
        for (const Body& body : bodies) {
            if (body.id == id) continue;
            vector<double> attraction = compute_gravitational_attraction(body);
            resulting_force = vector_addition(resulting_force, attraction);
        }

        acceleration = vector_addition(acceleration, vector_scalar_division(resulting_force, mass));
        velocity = vector_addition(velocity, acceleration);
        position = vector_addition(position, velocity);
        position = vector_addition(position, vector_scalar_division(acceleration, 2.0));
    }

    int id;
    double mass;
    vector<double> position;
    vector<double> acceleration;
    vector<double> velocity;
};

#endif //C___IMPLEMENTATION_FOR_THREADS_BODY_H
