#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <barrier>
#include "body.h"

using namespace std;

const int NUMBER_OF_BODIES = 128;
const int STEPS = 100;
const int NUM_THREADS = 6;

vector<Body> init_bodies(int number_of_bodies) {
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<> dis_mass(10.0, 100.0);
    uniform_real_distribution<> dis_position(-1e5, 1e5);
    uniform_real_distribution<> dis_acceleration(-1.0, 1.0);

    vector<Body> bodies;
    for (int i = 0; i < number_of_bodies; ++i) {
        double mass = dis_mass(gen);
        vector<double> position = {dis_position(gen), dis_position(gen), dis_position(gen)};
        vector<double> acceleration = {dis_acceleration(gen), dis_acceleration(gen), dis_acceleration(gen)};
        bodies.emplace_back(i, mass, position, acceleration);
    }
    return bodies;
}

vector<Body> centralized_solution(const vector<Body>& bodies) {
    vector<Body> new_bodies = bodies;
    for (int i = 0; i < STEPS; ++i) {
        for (Body& body : new_bodies) {
            body.move(new_bodies);
        }
    }
    return new_bodies;
}

bool solutions_are_the_same(const vector<Body>& parallelized_solution, const vector<Body>& centralized_solution) {
    for (size_t i = 0; i < centralized_solution.size(); ++i) {
        const Body& parallel_body = parallelized_solution[i];
        const Body& centralized_body = centralized_solution[i];

        if (parallel_body.id != centralized_body.id) {
            cerr << "Something is wrong, bodies got shuffled and IDs do not match\n";
            return false;
        }

        if (!equal(parallel_body.position.begin(), parallel_body.position.end(), centralized_body.position.begin())) {
            return false;
        }
    }
    return true;
}

void process_chunk(vector<Body>& bodies, int start, int end, barrier<>& barrier) {
    for (int i = 0; i < STEPS; ++i) {
        for (int j = start; j < end; ++j) {
            bodies[j].move(bodies);
        }
        barrier.arrive_and_wait();
    }
}

vector<Body> parallelized_solution(const vector<Body>& bodies) {
    vector<Body> new_bodies = bodies;
    int chunk_size = new_bodies.size() / NUM_THREADS;
    barrier barrier(NUM_THREADS);

    vector<thread> threads;
    for (int i = 0; i < NUM_THREADS; ++i) {
        int start = i * chunk_size;
        int end = start + chunk_size;

        if (i == NUM_THREADS - 1)
            end = new_bodies.size();

        threads.emplace_back(process_chunk, ref(new_bodies), start, end, ref(barrier));
    }

    for (thread& thread : threads) {
        thread.join();
    }

    return new_bodies;
}

int main() {
    auto bodies = init_bodies(NUMBER_OF_BODIES);

    auto start_time = chrono::high_resolution_clock::now();
    auto solution = centralized_solution(bodies);
    auto end_time = chrono::high_resolution_clock::now();
    cout << "Centralized duration: " << chrono::duration_cast<chrono::milliseconds>(end_time - start_time).count() << "ms\n";

    start_time = chrono::high_resolution_clock::now();
    auto thpExec_solution = parallelized_solution(bodies);
    end_time = chrono::high_resolution_clock::now();
    cout << "Threaded duration: " << chrono::duration_cast<chrono::milliseconds>(end_time - start_time).count() << "ms\n";

    cout << "Both implementations gave the same solution: " << solutions_are_the_same(thpExec_solution, solution) << '\n';
    for (double pos : solution[0].position) cout << pos << " ";
    cout << '\n';
    for (double pos : thpExec_solution[0].position) cout << pos << " ";
    cout << '\n';

    return 0;
}
