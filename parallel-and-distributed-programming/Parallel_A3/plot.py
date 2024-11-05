
import matplotlib.pyplot as plt

number_of_threads = []
classic_aproach_time = []
pooling_time = []

with open('out.txt', 'r') as file:
    for line in file:
        tokens = line.strip().split()
        number_of_threads.append(int(tokens[0]))
        classic_aproach_time.append(float(tokens[1]))
        pooling_time.append(float(tokens[2]))

plt.plot(number_of_threads, classic_aproach_time, 'r', number_of_threads, pooling_time, 'b')
plt.xlabel('number of threads')
plt.ylabel('time (ms)')
plt.legend(['classic', 'pooling'])
plt.savefig('performance_plot.png')
plt.show()
    