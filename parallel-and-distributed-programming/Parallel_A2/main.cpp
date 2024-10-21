#include <iostream>
#include <thread>
#include <queue>
#include <condition_variable>
#include <mutex>

int length = 100;
int array1[100];
int array2[100];
std::queue<int> products;
std::condition_variable condition;
std::mutex myMutex;
bool done = false;

void producer() {
    for (int i = 0; i < length; i++) {
        int product = array1[i] * array2[i];
        myMutex.lock();
        products.push(product);
        myMutex.unlock();
        condition.notify_one();
    }
    myMutex.lock();
    done = true;
    myMutex.unlock();
    condition.notify_one();
}

void consumer() {
    unsigned long long int sum = 0;
    do
    {
        std::unique_lock<std::mutex> lock(myMutex);
        condition.wait(lock, [] { return !products.empty() || done; });
        while (!products.empty()) {
            sum += products.front();
            products.pop();
        }
    }
    while (!done);
    std::cout << "The dot product is: " << sum << std::endl;
}

int main() {
    for (int i = 0; i < 100; i++)
    {
        array1[i] = i;
        array2[i] = i;
    }

    std::thread consumerThread(consumer);
    std::thread producerThread(producer);

    producerThread.join();
    consumerThread.join();

    return 0;
}
