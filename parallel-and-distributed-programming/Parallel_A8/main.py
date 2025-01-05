from mpi4py import MPI
from time import time, sleep

NUMBER_OF_NODES = 4

class Node:
    def __init__(self, node_id):
        self.node_id = node_id
        self.variables = {}
        self.timestamp = 0
        self.subscribers = {}  # Subscribers for each variable
        #self.order = []

    def create_variable(self, variable_id):
        self.variables[variable_id] = {'value': 0, 'timestamp': 0}

    def write(self, variable_id, value, callback_queue):
        self.variables[variable_id]['value'] = value
        self.variables[variable_id]['timestamp'] = self.timestamp
        self.timestamp += 1
        self.notify_subscribers(variable_id, callback_queue)

    def compare_and_exchange(self, variable_id, expected_value, new_value, callback_queue):
        if self.variables[variable_id]['value'] == expected_value:
            self.variables[variable_id]['value'] = new_value
            self.variables[variable_id]['timestamp'] = self.timestamp
            self.timestamp += 1
            self.notify_subscribers(variable_id, callback_queue)
            return True
        return False

    def get_variable(self, variable_id):
        return self.variables[variable_id]['value']

    def notify_subscribers(self, variable_id, callback_queue):
        if variable_id in self.subscribers.keys():
            for subscriber in self.subscribers[variable_id]:
                callback_queue.append((subscriber, variable_id, self.variables[variable_id]['value']))

    def got_notification(self, variable_id, value, notif):
        self.variables[variable_id]['value'] = value
        self.variables[variable_id]['timestamp'] = self.timestamp
        self.timestamp += 1
        #self.order.append((variable_id, value, notif))
        #print(notif)

class DSM:
    def __init__(self):
        self.nodes = {}
        self.variables = {}
        self.timestamp = 0
        self.callback_queue = []  # List to handle callbacks
        self.subscribers = {}

    def notify(self, subscriber, variable_id, value, notif):
        self.nodes[subscriber].got_notification(variable_id, value, notif)

    def create_node(self, node_id):
        self.nodes[node_id] = Node(node_id)

    def create_variable(self, variable_id):
        if variable_id not in self.variables.keys():
            self.variables[variable_id] = {'value': 0, 'timestamp': 0}

    def write(self, node_id, variable_id, value):
        self.nodes[node_id].write(variable_id, value, self.callback_queue)
        self.variables[variable_id]['value'] = value
        self.variables[variable_id]['timestamp'] = self.timestamp
        self.timestamp += 1

    def subscribe(self, node_id, variable_id):
        if variable_id not in self.variables:
            self.create_variable(variable_id)
        if node_id not in self.nodes:
            self.create_node(node_id)
        if variable_id not in self.subscribers:
            self.subscribers[variable_id] = [node_id]
        else:
            self.subscribers[variable_id].append(node_id)

        for node_id in self.subscribers[variable_id]:
            self.nodes[node_id].subscribers[variable_id] = self.subscribers[variable_id]

        # for node in self.nodes.values():
        #     if variable_id in node.subscribers.keys():
        #         if node_id not in node.subscribers[variable_id]:
        #             node.subscribers[variable_id].append(node_id)


    def compare_and_exchange(self, node_id, variable_id, expected_value, new_value):
        result = self.nodes[node_id].compare_and_exchange(variable_id, expected_value, new_value, self.callback_queue)
        if result:
            self.variables[variable_id]['value'] = new_value
            self.variables[variable_id]['timestamp'] = self.timestamp
            self.timestamp += 1
        return result

    def get_variable(self, node_id, variable_id):
        return self.nodes[node_id].get_variable(variable_id)

def worker(node_id, dsm):
    #order = []
    dsm.write(node_id, 1, node_id)
    print(f"Node {node_id} wrote {node_id} to variable 1")

    result = dsm.compare_and_exchange(node_id, 1, node_id, node_id*10)
    print(f"Node {node_id} compare and exchange result: {result}")

    print(f"Node {node_id} read {dsm.get_variable(node_id, 1)} from variable 1")

    start_time = time()
    while time() - start_time < 5:  # Check for 5 seconds
        if dsm.callback_queue:
            subscriber, variable_id, value = dsm.callback_queue.pop(0)
            dsm.notify(subscriber, variable_id, value, f"Callback: Node {subscriber} notified that variable {variable_id} changed to {value}")
            #order.append((variable_id, value))
            print(f"Callback: Node {subscriber} notified that variable {variable_id} changed to {value}")
    #print(f"Order observed by node {subscriber}: {order}")

def main():
    """
    Spaghetti code
    """
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()

    if rank == 0:
        dsm = DSM()
        dsm.create_variable(1)            
        for i in range(NUMBER_OF_NODES):
            dsm.create_node(i)
            dsm.nodes[i].create_variable(1)
            dsm.subscribe(i, 1)

        for i in range(1, size):
            comm.send(dsm, dest=i, tag=0)
    else:
        dsm = comm.recv(source=0, tag=0)

    worker(rank, dsm)
  

    # if rank == 0:
    #     sleep(2)
    #     print(dsm.subscribers)
    #     for node in dsm.nodes.values():
    #         print(node.order)

if __name__ == "__main__":
    main()
