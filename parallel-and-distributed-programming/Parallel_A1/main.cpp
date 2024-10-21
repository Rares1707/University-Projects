#include <iostream>
#include <list>
#include <functional>
#include "vector"
#include "mutex"
#include "thread"
#include "queue"
#include "ctime"

struct Node {
    Node *parent;
    int value;
    std::list<Node*> children;
    std::mutex mutex;

    Node(int value, Node* parent=NULL)
    {
        this->value = value;
        this->parent = parent;
        this->children = *new std::list<Node*>();
    };
};

bool treeIsConsistent(Node* root)
{
    std::queue<Node*> queue;
    queue.push(root);
    while (!queue.empty())
    {
        Node* currentNode = queue.front();
        queue.pop();
        int sum = 0;
        for (Node* child: currentNode->children)
        {
            sum += child->value;
            queue.push(child);
        }
        if (!currentNode->children.empty() && sum != currentNode->value)
        {
            return false;
        }
    }
    return true;
}

void changeSecondaryNodeValue(Node* node, int differenceBetweenOldAndNewValue, int threadId)
{
    node->mutex.lock();
    node->value -= differenceBetweenOldAndNewValue;
    if (node->parent)
    {
        changeSecondaryNodeValue(node->parent, differenceBetweenOldAndNewValue, threadId);
    }
    node->mutex.unlock();
}

void changePrimaryNodeValue(Node* node, int newValue, int threadId)
{
    std::this_thread::sleep_for(std::chrono::seconds (2));
    node->mutex.lock();
    int differenceBetweenValues = node->value - newValue;
    node->value = newValue;
    if (node->parent)
    {
        changeSecondaryNodeValue(node->parent, differenceBetweenValues, threadId);
    }
    node->mutex.unlock();
    //std::cout<<"Thread " << threadId << " finished";
}

bool threadsHaveFinished(std::vector<bool> &threadFinished)
{
    for (bool threadStatus: threadFinished)
    {
        if (!threadStatus)
        {
            return false;
        }
    }
    return true;
}


int main() {
    Node *root = new Node(0);

    //children of root
    Node *child1 = new Node(0, root);
    Node *child2 = new Node(0, root);
    Node *child3 = new Node(0, root);
    root->children.push_back(child1);
    root->children.push_back(child2);
    root->children.push_back(child3);

    //children of child2
    Node *child4 = new Node(0, child2);
    Node *child5 = new Node(0, child2);
    child2->children.push_back(child4);
    child2->children.push_back(child5);

    //child of child4
    Node *child6 = new Node(0, child4);
    child4->children.push_back(child6);

    //children of child3
    Node *child7 = new Node(0, child3);
    Node *child8 = new Node(0, child3);
    Node *child9 = new Node(0, child3);
    child3->children.push_back(child7);
    child3->children.push_back(child8);
    child3->children.push_back(child9);

    //children of child8
    Node *child10 = new Node(0, child8);
    Node *child11 = new Node(0, child8);
    child8->children.push_back(child10);
    child8->children.push_back(child11);

    //children of child9
    Node *child12 = new Node(0, child9);
    Node *child13 = new Node(0, child9);
    child9->children.push_back(child12);
    child9->children.push_back(child13);

    std::list<Node*> nodes = {root, child1, child2, child3, child4, child5, child6, child7, child8, child9, child10,
                              child11, child12, child13};

    nodes.reverse();
    std::vector<Node*> leaves = {child1, child5, child6, child7, child10, child11, child12, child13};

    std::srand(std::time(nullptr));

    std::vector<std::thread> threads;
    std::vector<bool> threadFinished;

    for(int i = 0; i < 100000; i++)
    {
        int leafId = std::rand() % leaves.size();
        int randomValue = std::rand() % 100;
        threadFinished.emplace_back(false);
        threads.emplace_back(changePrimaryNodeValue, leaves[leafId], randomValue, i);
        /*threads.emplace_back(&, leafId, randomValue, i {
                changePrimaryNodeValue(leaves[leafId], randomValue, i, threadFinished);
        });*/
        //threads.emplace_back(std::bind(changePrimaryNodeValue, leaves[leafId], randomValue, i, std::ref(threadFinished)));
    }

    //main thread
    int k = 0;
    while (k < 1000)
    {
        k++;
        for (Node* node: nodes)
        {
            node->mutex.lock();
        }
        if (!treeIsConsistent(root))
        {
            int j = 0;
            for (Node* node: nodes)
            {
                std::cout << "Node: " << 13-j << " Value:" << node->value << "\n";
                j++;
            }
            std::cout<<("The tree is NOT consistent");
            return 0;
        }
        std::cout<<("The tree is consistent");

        for (Node* node: nodes)
        {
            node->mutex.unlock();
        }
        std::this_thread::sleep_for(std::chrono::milliseconds (15));
    }

    // show the final tree
    int j = 0;
    for (Node* node: nodes)
    {
        std::cout << "Node: " << 13-j << " Value:" << node->value << "\n";
        j++;
    }
    std::cout<<("The tree is consistent");

    for (auto& thread: threads)
    {
        thread.join();
    }

    return 0;
}
