############ purity ############
"""
1. No Side-Effect
2. Referential Transparency (returned value is always determined solely by params)
"""

def add(x: int, y: int):
    return x + y

a = 3
def global_add(y: int):
    return a + y

def effect_add(x: int, y: int):
    print("SIDE EFFECT")
    a += 1 # Also a side effect
    return x + y

def hmm_add(x, y):
    return x + y

class Point:
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y
    
    def __add__(self, other: "Point"):
        return {
            "x": self.x + other.x,
            "y": self.y + other.y
        }

n_point = Point(1, 2)
m_point = Point(2, 3)
print(hmm_add(n_point, m_point))

# Let's consider multi-threaded environment
#### Thread 1 ####
n_point.x = 100; ...
#### Thread 2 (call-by-reference) ####
result = hmm_add(n_point, m_point); ...
# We need lock... or fundamentally immutability!

############ purity ############


############ immutability & recursion ############
def sum_loop(x: int):
    result = 0
    while x > 0:
        result += x # Immutability breaks
        x -= 1
    return result

def sum_rec(x: int):
    if x <= 0:
        return 0
    return x + sum_rec(x - 1)

# P.S. Tail Call Optimization
# Refer to ./tail_call_opt.c

# P.S. C vs Haskell (POSIX vs abstract(POSIX))
# Refer to ./fread.c & ./fread.hs

############ immutability & recursion ############


############ first class function ############
def add(x: int, y: int):
    return x + y

def cadd(x: int):
    return lambda y: x + y

a = add(1, 2)
b = cadd(1)(2)

# iterables
from functools import reduce

ints = list(map(int, "123456789"))
evens = list(filter(lambda x: x % 2 == 0, ints))
total = reduce(lambda acc, x: acc + x, evens, 0)

# Why linked list is a fundamental data structure for FP?
# Hint: Think about how can we generate an IMMUTABLE array with N elements

############ first class function ############


############ curried map ############
def umap(f, _list):
    """
    umap: <T, U>(f: T -> U, _list: T[]) -> U[]
    """
    return list(map(f, _list))

def fmap(f):
    """
    fmap: <T, U>(f: T -> U) -> ((_list: T[]) -> U[])
    """
    def _map(_list):
        return list(map(f, _list))

    return _map

xs = list(range(0, 10))

increase = lambda x: x + 1
incMap = fmap(increase)

print(f"""
    Result from map:  {umap(increase, xs)}
    Result from fmap: {fmap(increase)(xs)}
    Result from fmap: {incMap(xs)}
""")

############ curried map ############