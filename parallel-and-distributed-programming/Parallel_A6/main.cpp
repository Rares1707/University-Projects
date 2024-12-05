#include <iostream>
#include <vector>
#include <thread>
#include <future>
#include <atomic>
#include <mutex>
#include <chrono>

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

    HamiltonianCycle hamiltonianCycle(graph);

    auto start = chrono::high_resolution_clock::now();
    hamiltonianCycle.solve(6);
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration = end - start;
    cout << "Duration: " << duration.count() << '\n';

    return 0;
}
