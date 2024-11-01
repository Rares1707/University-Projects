#include <iostream>
#include "vector"
#include "thread"
#include "functional"
#include "chrono"
#include "mutex"
#include "condition_variable"
#include "list"

using namespace std;

int TRIALS = 100;

int computeElement(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2, int i, int j)
{
    int dot_product = 0;
    for (int k = 0; k < matrix1[0].size(); k++) // matrix1[0].size() is n
    {
        dot_product += matrix1[i][k] * matrix2[k][j];
    }
    return dot_product;
}

void computeElementsRowAfterRow(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2, int startingRow,
                                int numberOfElements, vector<vector<int>>& resultingMatrix)
{
    for (int i = 0; i < numberOfElements; i++)
    {
        int row = startingRow + i / matrix2[0].size(); // matrix2[0].size() is p
        int column = i % matrix2[0].size();
        resultingMatrix[row][column] = computeElement(matrix1, matrix2, row, column);
    }
}

void computeElementsColumnAfterColumn(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                                      int startingColumn, int numberOfElements, vector<vector<int>>& resultingMatrix)
{
    for (int i = 0; i < numberOfElements; i++)
    {
        int row = i % matrix1.size(); // matrix1.size() is m
        int column = startingColumn + i / matrix1.size();
        resultingMatrix[row][column] = computeElement(matrix1, matrix2, row, column);
    }
}

void computeEveryKthElement(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2, int k,
                            int startingElementIndex, int numberOfElements, vector<vector<int>>& result)
{
    for (int i = 0; i < numberOfElements; i++) {
        int index = startingElementIndex + i * k;
        int row = index / matrix2[0].size(); // matrix2[0].size() is p
        int col = index % matrix2[0].size();
        result[row][col] = computeElement(matrix1, matrix2, row, col);
    }
}

void printMatrix(const vector<vector<int>>& matrix)
{
    for (vector<int> row : matrix)
    {
        for (int element : row)
        {
            cout << element << ' ';
        }
        cout << '\n';
    }
    cout << '\n';
}

class ThreadPool {
public:
    explicit ThreadPool(size_t nrThreads)
            :m_end(false)
    {
        m_threads.reserve(nrThreads);
        for (size_t i = 0; i < nrThreads; ++i) {
            m_threads.emplace_back([this]() {this->run(); });
        }
    }

    ~ThreadPool() {
        close();
        for (std::thread& t : m_threads) {
            t.join();
        }
    }

    void close() {
        std::unique_lock<std::mutex> lck(m_mutex);
        m_end = true;
        m_cond.notify_all();
    }

    void enqueue(std::function<void()> func) {
        std::unique_lock<std::mutex> lck(m_mutex);
        m_queue.push_back(std::move(func));
        m_cond.notify_one();
    }

    //    template<typename Func, typename... Args>
    //    void enqueue(Func func, Args&&... args) {
    //        std::function<void()> f = [=](){func(args...);};
    //        enqueue(std::move(f));
    //    }
private:
    void run() {
        while (true) {
            std::function<void()> toExec;
            {
                std::unique_lock<std::mutex> lck(m_mutex);
                while (m_queue.empty() && !m_end) {
                    m_cond.wait(lck);
                }
                if (m_queue.empty()) {
                    return;
                }
                toExec = std::move(m_queue.front());
                m_queue.pop_front();
            }
            toExec();
        }
    }

    std::mutex m_mutex;
    std::condition_variable m_cond;
    std::list<std::function<void()> > m_queue;
    bool m_end;
    std::vector<std::thread> m_threads;
};

void classicRowByRow(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                     vector<vector<int>>& resultingMatrix)
{
    double sum = 0;
    for (int i = 0; i < TRIALS; i++)
    {
        auto start = std::chrono::high_resolution_clock ::now();
        thread t1(computeElementsRowAfterRow, ref(matrix1), ref(matrix2), 0, 27, ref(resultingMatrix));
        thread t2(computeElementsRowAfterRow, ref(matrix1), ref(matrix2), 3, 27, ref(resultingMatrix));
        thread t3(computeElementsRowAfterRow, ref(matrix1), ref(matrix2), 6, 27, ref(resultingMatrix));
        t1.join();
        t2.join();
        t3.join();
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> duration = end - start;
        sum += duration.count();
    }
    std::cout << "Classic row by row: " << sum / TRIALS << " ms\n";
}

void poolRowByRow(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                  vector<vector<int>>& resultingMatrix)
{
    double sum = 0;
    for (int i = 0; i < TRIALS; i++)
    {
        ThreadPool pool(3);
        auto start = std::chrono::high_resolution_clock ::now();
        int finalMatrixDimensions = 9;
        for (unsigned i = 0; i < finalMatrixDimensions; ++i) {
            auto matrixRef = ref(resultingMatrix);
            pool.enqueue([matrix1, matrix2, i, matrixRef, finalMatrixDimensions]()
            {
                computeElementsRowAfterRow(matrix1, matrix2, i, finalMatrixDimensions, matrixRef);
            });
        }
        pool.close();
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> duration = end - start;
        sum += duration.count();
    }
    std::cout << "Pool row by row: " << sum / TRIALS << " ms\n";
}

void classicColumnByColumn(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                     vector<vector<int>>& resultingMatrix)
{
    double sum = 0;
    for (int i = 0; i < TRIALS; i++)
    {
        auto start = std::chrono::high_resolution_clock ::now();
        thread t1(computeElementsColumnAfterColumn, ref(matrix1), ref(matrix2), 0, 27, ref(resultingMatrix));
        thread t2(computeElementsColumnAfterColumn, ref(matrix1), ref(matrix2), 3, 27, ref(resultingMatrix));
        thread t3(computeElementsColumnAfterColumn, ref(matrix1), ref(matrix2), 6, 27, ref(resultingMatrix));
        t1.join();
        t2.join();
        t3.join();
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> duration = end - start;
        sum += duration.count();
    }
    std::cout << "Classic column by column: " << sum / TRIALS << " ms\n";
}

void poolColumnByColumn(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                  vector<vector<int>>& resultingMatrix)
{
    double sum = 0;
    for (int i = 0; i < TRIALS; i++)
    {
        ThreadPool pool(3);
        auto start = std::chrono::high_resolution_clock ::now();
        // [i, lenPerThread, iterations]() {func(lenPerThread * i, lenPerThread, iterations); }
        int finalMatrixDimensions = 9;
        for (unsigned i = 0; i < finalMatrixDimensions; ++i) {
            auto matrixRef = ref(resultingMatrix);
            pool.enqueue([matrix1, matrix2, i, matrixRef, finalMatrixDimensions]()
                         {
                             computeElementsColumnAfterColumn(matrix1, matrix2, i, finalMatrixDimensions, matrixRef);
                         });
        }
        pool.close();
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> duration = end - start;
        sum += duration.count();
    }
    std::cout << "Pool column by column: " << sum / TRIALS << " ms\n";
}

void classicEveryKthElement(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                           vector<vector<int>>& resultingMatrix, int k)
{
    double sum = 0;
    for (int i = 0; i < TRIALS; i++)
    {
        auto start = std::chrono::high_resolution_clock ::now();
        thread t1(computeEveryKthElement, ref(matrix1), ref(matrix2), k, 0, 27, ref(resultingMatrix));
        thread t2(computeEveryKthElement, ref(matrix1), ref(matrix2), k, 1, 27, ref(resultingMatrix));
        thread t3(computeEveryKthElement, ref(matrix1), ref(matrix2), k, 2, 27, ref(resultingMatrix));
        t1.join();
        t2.join();
        t3.join();
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> duration = end - start;
        sum += duration.count();
    }
    std::cout << "Classic every kth element: " << sum / TRIALS << " ms\n";
}

void poolEveryKthElement(const vector<vector<int>>& matrix1, const vector<vector<int>>& matrix2,
                         vector<vector<int>>& resultingMatrix, int k)
{
    double sum = 0;
    for (int i = 0; i < TRIALS; i++)
    {
        ThreadPool pool(3);
        auto start = std::chrono::high_resolution_clock ::now();
        // [i, lenPerThread, iterations]() {func(lenPerThread * i, lenPerThread, iterations); }
        for (unsigned i = 0; i < k; ++i) {
            auto matrixRef = ref(resultingMatrix);
            pool.enqueue([matrix1, matrix2, i, matrixRef, k]()
                         {
                             computeEveryKthElement(matrix1, matrix2, k, i, 27, matrixRef);
                         });
        }
        pool.close();
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> duration = end - start;
        sum += duration.count();
    }
    std::cout << "Pool column by column: " << sum / TRIALS << " ms\n";
}

// m,n * n,p = m,p
int main() {
    vector<vector<int>> matrix1 =
    {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9},
        {10, 11, 12},
        {13, 14, 15},
        {16, 17, 18},
        {19, 20, 21},
        {22, 23, 24},
        {25, 26, 27}
    };

    vector<vector<int>> matrix2 =
    {
        {1, 2, 3, 4, 5, 6, 7, 8, 9},
        {10, 11, 12, 13, 14, 15, 16, 17, 18},
        {19, 20, 21, 22, 23, 24, 25, 26, 27}
    };

    std::vector<std::vector<int>> resultingMatrix(9, std::vector<int>(9, 0));
    classicRowByRow(matrix1, matrix2, resultingMatrix);
    //printMatrix(resultingMatrix);
    
    resultingMatrix = std::vector<std::vector<int>>(9, std::vector<int>(9, 0));
    classicColumnByColumn(matrix1, matrix2, resultingMatrix);
    //printMatrix(resultingMatrix);

    resultingMatrix = std::vector<std::vector<int>>(9, std::vector<int>(9, 0));
    classicEveryKthElement(matrix1, matrix2, resultingMatrix, 3);
   // printMatrix(resultingMatrix);

    resultingMatrix = std::vector<std::vector<int>>(9, std::vector<int>(9, 0));
    poolRowByRow(matrix1, matrix2, resultingMatrix);
    //printMatrix(resultingMatrix);

    resultingMatrix = std::vector<std::vector<int>>(9, std::vector<int>(9, 0));
    poolColumnByColumn(matrix1, matrix2, resultingMatrix);
    //printMatrix(resultingMatrix);

    resultingMatrix = std::vector<std::vector<int>>(9, std::vector<int>(9, 0));
    poolEveryKthElement(matrix1, matrix2, resultingMatrix, 3);
    //printMatrix(resultingMatrix);

    return 0;
}
