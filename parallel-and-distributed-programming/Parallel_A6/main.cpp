#include <iostream>
#include <vector>
#include <thread>
#include <future>
#include <atomic>
#include <mutex>
#include <chrono>
#include <algorithm>
#include <random>

using namespace std;

class HamiltonianCycle {
public:
    const std::vector<std::vector<int>> graph;
    const int numberOfVertices;
    std::atomic<bool> found;
    std::vector<int> initialPath;

    HamiltonianCycle(const std::vector<std::vector<int>>& inputGraph)
        : graph(inputGraph), numberOfVertices(inputGraph.size()), found(false), initialPath(numberOfVertices, -1) //empty path
    {}

    bool isAccessible(int vertex, int position, vector<int>& path) {
        if (graph[path[position - 1]][vertex] == 0)
            return false;

        for (int i = 0; i < position; i++)
            if (path[i] == vertex)
                return false;

        return true;
    }

    // Recursive utility function to solve Hamiltonian Cycle problem
    void addVertexToPathAtPosition(int position, int numberOfThreads, vector<int>& path) {
        if (found)
            return;

        if (position == numberOfVertices) { // we're done
            if (graph[path[position - 1]][path[0]] == 1) {
                found = true;
                printSolution(path);
            }
            return;
        }

        for (int vertex = 1; vertex < numberOfVertices; vertex++) {
            if (isAccessible(vertex, position, path)) {
                path[position] = vertex;

                if (numberOfThreads > 1) {
                    std::vector<int> pathCopy = path;
                    std::future<void> other = std::async(std::launch::async, [this, position, numberOfThreads, &pathCopy]()  {
                        addVertexToPathAtPosition(position + 1, numberOfThreads / 2, pathCopy);
                    });
                    addVertexToPathAtPosition(position + 1, numberOfThreads - numberOfThreads / 2, path);
                    other.wait();
                } else {
                    addVertexToPathAtPosition(position + 1, 1, path);
                }

                path[position] = -1;
            }
        }
    }

    void solve(int numberOfThreads) {
        initialPath[0] = 0;
        addVertexToPathAtPosition(1, numberOfThreads, initialPath);
    }

    // Function to print the Hamiltonian Cycle
    void printSolution(vector<int>& path) {
        if (!found) {
            return;
        }

        std::cout << "Hamiltonian cycle found: ";
        for (int i = 0; i < numberOfVertices; i++)
            std::cout << path[i] + 1 << " ";  // prints the graph with 1-indexing instead of 0-indexing
        std::cout << path[0] + 1  << std::endl;
    }
};

//def generate_random_edges(self, edges: int):
//"""Randomly generate edges until the graph has the required number of edges."""
//possible_edges = [(u, v) for u in range(self.vertices) for v in range(self.vertices) if u != v]
//random.shuffle(possible_edges)
//
//for u, v in possible_edges:
//if self.get_edge_count() >= edges:
//break
//self.add_edge(u, v)

std::vector<std::vector<int>> generate_graph(int numberOfVertices, int numberOfEdges){
    vector<vector<int>> graph(numberOfVertices, std::vector<int>(numberOfVertices, 0));
    vector<pair<int, int>> possibleEdges;
    bool finished = false;
    for (int i = 0; i < numberOfVertices && !finished; i++){
        for (int j = 0; j < numberOfVertices && !finished; j++){
//            if (possibleEdges.size() >= numberOfEdges){
//                finished = true;
//                break;
//            }
            if (i != j){
                possibleEdges.emplace_back(i, j);
            }
        }
    }
    auto rng = default_random_engine {};
    std::ranges::shuffle(possibleEdges, rng);
    for (int i = 0; i < numberOfEdges; i++){
        pair<int, int> edge = possibleEdges[i];
        graph[edge.first][edge.second] = 1;
    }
    return graph;
}

int main() {
    std::vector<std::vector<int>> graph = { // graph from https://www.pbinfo.ro/articole/5790/graf-hamiltonian
        {0, 1, 1, 0, 0, 0},
        {1, 0, 0, 1, 1, 0},
        {1, 0, 0, 0, 1, 1},
        {0, 1, 0, 0, 1, 1},
        {0, 1, 0, 1, 0, 1},
        {0, 0, 1, 1, 1, 0}
    };
    int n = 100;
    vector<vector<int>> bigGraph(n, std::vector<int>(n, 0));
    auto randomGraph = generate_graph(40, 100);

    HamiltonianCycle hamiltonianCycle(randomGraph);

    auto start = chrono::high_resolution_clock::now();
    hamiltonianCycle.solve(6);
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration = end - start;
    cout << "Duration: " << duration.count() << '\n';

    return 0;
}
