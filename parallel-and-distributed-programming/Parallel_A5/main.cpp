#include <iostream>
#include "vector"
#include "thread"
#include "chrono"

using namespace std;

int NUM_THREADS = 12;

//-----------------------------------------------------------------------------------------------
//CLASSIC

vector<int> multiplyPolynomials(const vector<int>& A, const vector<int>& B) {
    int n = A.size();
    int m = B.size();
    vector<int> result(n + m - 1, 0);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            result[i + j] += A[i] * B[j];
        }
    }
    return result;
}

//--------------------------------------------------------------------------------------------
//CLASSIC PARALLELIZED

void multiplyPart(const vector<int>& A, const vector<int>& B, vector<int>& result, int start, int end) {
    // multiplies part of the first polynomial with the second polynomial
    int m = B.size();
    for (int i = start; i < end; ++i) {
        for (int j = 0; j < m; ++j) {
            result[i + j] += A[i] * B[j];
        }
    }
}

vector<int> multiplyPolynomialsParallel(const vector<int>& A, const vector<int>& B) {
    int n = A.size();
    int m = B.size();
    vector<int> result(n + m - 1, 0);

    vector<thread> threads;
    int partSize = n / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; ++i) {
        int start = i * partSize;
        int end = (i == NUM_THREADS - 1) ? n : (i + 1) * partSize;
        threads.push_back(thread(multiplyPart, cref(A), cref(B), ref(result), start, end));
    }

    for (auto& t : threads) {
        t.join();
    }

    return result;
}


//-----------------------------------------------------------------------------------------------
//KARATSUBA

vector<int> addPolynomials(const vector<int>& A, const vector<int>& B) {
    int n = max(A.size(), B.size());
    vector<int> result(n, 0);
    for (int i = 0; i < n; ++i) {
        if (i < A.size()){
            result[i] += A[i];
        }
        if (i < B.size()){
            result[i] += B[i];
        }
    }
    return result;
}

vector<int> subtractPolynomials(const vector<int>& A, const vector<int>& B) {
    int n = max(A.size(), B.size());
    vector<int> result(n, 0);
    for (int i = 0; i < n; ++i) {
        if (i < A.size()){
            result[i] += A[i];
        }
        if (i < B.size()){
            result[i] -= B[i];
        }
    }
    return result;
}

vector<int> karatsuba(const vector<int>& A, const vector<int>& B) {
    int n = max(A.size(), B.size());
    if (n < 100)
    {
        return multiplyPolynomials(A, B);
    };

    int half = n / 2;

    vector<int> A1(A.begin(), A.begin() + half);
    vector<int> A2(A.begin() + half, A.end());
    vector<int> B1(B.begin(), B.begin() + half);
    vector<int> B2(B.begin() + half, B.end());

    vector<int> P1 = karatsuba(A1, B1);
    vector<int> P2 = karatsuba(A2, B2);
    vector<int> A1A2 = addPolynomials(A1, A2);
    vector<int> B1B2 = addPolynomials(B1, B2);
    vector<int> temp = karatsuba(A1A2, B1B2);

    vector<int> second_term = subtractPolynomials(temp, addPolynomials(P1, P2));

    vector<int> result(2 * n - 1, 0);
    for (int i = 0; i < P1.size(); ++i) result[i + 2 * half] += P1[i];
    for (int i = 0; i < second_term.size(); ++i) result[i + half] += second_term[i];
    for (int i = 0; i < P2.size(); ++i) result[i] += P2[i];

    return result;
}

//-----------------------------------------------------------------------------------------------------
// KARATSUBA PARALLELIZED

vector<int> karatsubaParallel(const vector<int>& A, const vector<int>& B);

void karatsubaHelper(const vector<int>& A, const vector<int>& B, vector<int>& result, int start, int end) {
    //used for computing P1 and P2 on other threads
    vector<int> tempResult = karatsuba(vector<int>(A.begin() + start, A.begin() + end), vector<int>(B.begin() + start, B.begin() + end));
    for (int i = 0; i < tempResult.size(); ++i) {
        result[start + i] += tempResult[i];
    }
}

vector<int> karatsubaParallel(const vector<int>& A, const vector<int>& B) {
    int n = max(A.size(), B.size());
    if (n < 100)
    {
        return multiplyPolynomials(A, B);
    };

    int half = n / 2;

    vector<int> A1(A.begin(), A.begin() + half);
    vector<int> A2(A.begin() + half, A.end());
    vector<int> B1(B.begin(), B.begin() + half);
    vector<int> B2(B.begin() + half, B.end());

    vector<int> P1(half * 2 - 1, 0), P2(half * 2 - 1, 0), P3(n * 2 - 1, 0);

    thread t1(karatsubaHelper, cref(A1), cref(B1), ref(P1), 0, half);
    thread t2(karatsubaHelper, cref(A2), cref(B2), ref(P2), 0, half);

    vector<int> A1A2 = addPolynomials(A1, A2);
    vector<int> B1B2 = addPolynomials(B1, B2);
    vector<int> temp = karatsuba(A1A2, B1B2); //using the parallelized version doesn't yield any benefits, probably because too many threads are created

    t1.join();
    t2.join();
    vector<int> second_part = subtractPolynomials(temp, addPolynomials(P1, P2));

    vector<int> result(2 * n - 1, 0);
    for (int i = 0; i < P1.size(); ++i) result[i] += P1[i];
    for (int i = 0; i < second_part.size(); ++i) result[i + half] += second_part[i];
    for (int i = 0; i < P2.size(); ++i) result[i + 2 * half] += P2[i];

    return result;
}

void smallTest(){
    vector<int> A = {1, 2, 3, 4}; // Example polynomial P(x)
    vector<int> B = {5, 6, 7, 8}; // Example polynomial Q(x)

    auto start = chrono::high_resolution_clock::now();
    vector<int> result1 = multiplyPolynomials(A, B);
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration1 = end - start;

    start = chrono::high_resolution_clock::now();
    vector<int> result2 = multiplyPolynomialsParallel(A, B);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration2 = end - start;

    start = chrono::high_resolution_clock::now();
    vector<int> result3 = karatsuba(A, B);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration3 = end - start;

    start = chrono::high_resolution_clock::now();
    vector<int> result4 = karatsubaParallel(A, B);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration4 = end - start;

    cout << duration1.count() << "ms for classical multiplication: ";
    for (int coefficient : result1) {
        cout << coefficient << " ";
    }
    cout << '\n';

    cout << duration2.count() << "ms for parallel classical multiplication: ";
    for (int coefficient : result2) {
        cout << coefficient << " ";
    }
    cout << '\n';

    cout << duration3.count() << "ms for Karatsuba multiplication: ";
    for (int coefficient : result3) {
        cout << coefficient << " ";
    }
    cout << '\n';

    cout << duration4.count() << "ms for parallel Karatsuba multiplication: ";
    for (int coefficient : result4) {
        cout << coefficient << " ";
    }
    cout << '\n';
}

void bigTest(){
    int n = 40000;
    vector<int> A = vector(n, 1); // Example polynomial P(x)
    vector<int> B = vector(n, 1); // Example polynomial Q(x)

    auto start = chrono::high_resolution_clock::now();
    vector<int> result1 = multiplyPolynomials(A, B);
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration1 = end - start;
    cout << duration1.count() << "ms for classical multiplication\n";

    start = chrono::high_resolution_clock::now();
    vector<int> result2 = multiplyPolynomialsParallel(A, B);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration2 = end - start;
    cout << duration2.count() << "ms for parallel classical multiplication\n";

    start = chrono::high_resolution_clock::now();
    vector<int> result3 = karatsuba(A, B);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration3 = end - start;
    cout << duration3.count() << "ms for Karatsuba multiplication\n";

    start = chrono::high_resolution_clock::now();
    vector<int> result4 = karatsubaParallel(A, B);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double, milli> duration4 = end - start;
    cout << duration4.count() << "ms for parallel Karatsuba multiplication\n";

    cout << "\nBtw normal multiplication uses 12 threads while karatsuba uses only 3 because I found it harder to parallelize" <<
            " (although the normal version isn't improved much by going from 6 to 12 threads)";
}

int main() {
    smallTest(); // for this it would be better to change the conditions in the karatsuba versions from n < 100 to n = 1
    cout << '\n';
    bigTest();
    return 0;
}


