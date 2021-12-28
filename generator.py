from math import floor
from random import randint, gauss
from tqdm import tqdm
import click


def generate_batch(num):
    """
    Given the number of integer, returns a random array with num elements
    The first element is the sequence lenght as specified in the document
    """

    def clamp(value):
        return max(min(floor(value), 255), 0)

    return [num] + [clamp(gauss(127, 30)) for _ in range(num)]


class FSM:
    def __init__(self, state):
        self.state = state

    #return output value and update current state
    def getVal(self, input):
        if self.state==0:
            if input==0:
                self.state = 0
                return 0
            else:
                self.state = 2
                return 3
        if self.state==1:
            if input==0:
                self.state = 0
                return 3
            else:
                self.state = 2
                return 0
        if self.state==2:
            if input==0:
                self.state = 1
                return 1
            else:
                self.state = 3
                return 2
        if self.state==3:
            if input==0:
                self.state = 1
                return 2
            else:
                self.state = 3
                return 1

class Solver:
    #store the current state
    # to be more efficient calculate all possible output sequence in the constructor
    def __init__(self):
        self.results = []
        self.state = 0
        for state in range(4):
            self.results.append([])
            for val in range(256):
                fsm= FSM(state)
                self.results[state].append([self.byteSolver(fsm, val), fsm.state])

    @staticmethod
    def byteSolver(fsm, byte):
        res = 0
        for i in range(8):
            bit = floor(byte/pow(2, 7-i))
            byte = byte % pow(2, 7-i)
            res *= 4
            res += fsm.getVal(bit)
        return res

    #return an integer that represent the generated two bytes
    def getNextValue(self, input_val):
        current_state= self.state
        self.state = self.results[current_state][input_val][1]
        return self.results[current_state][input_val][0]
        #fsm = FSM(current_state)
        #res = self.byteSolver(fsm, input_val)
        #self.state = fsm.state
        #return res
        


def solve_batch(batch, solver):
    """
    Given a list with a structure like
    [num, BYTE_1, ..., BYTE_(num)]
    returns a list of value elaborated with the given algorithm
    """

    stream = batch[1:]
    solver.state = 0
    def equalize(byte):
        temp_val = solver.getNextValue(byte)
        return [floor(temp_val/256), temp_val%256]

    res = []
    for x in stream:
        res += equalize(x)
    return res

def generate_ram(num, solver):
    """
    Generates ram values for a random test case
    """

    batch = generate_batch(num)
    solution = solve_batch(batch, solver)
    return batch + solution


@click.command()
@click.option('--size', default=100, show_default=True, help='Number of tests to generate')
@click.option('--limit', default=128, show_default=True, help='Maximum input stream size')
def main(size, limit):
    solver = Solver()
    with open('ram_content.txt', 'w') as ram, open('test_values.txt', 'w') as readable:
        for i in tqdm(range(size), desc='Generating tests', dynamic_ncols=True):
            num = randint(1, limit)
            test = generate_ram(num, solver)

            for value in test:
                ram.write(f'{value}\n')

            written_ram = ' '.join([str(v) for v in test])
            readable.write(f'{test[0]} bytes \t\t RAM: {written_ram}\n')


if __name__ == '__main__':
    main()
