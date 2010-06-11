"""
>>> foo()
True
>>> bar()
True
>>> C().f()
True
"""
import math
flag = math.pi

def foo():
    return 'bar'

if flag>3:
    def foo():
        return True
    def bar():
        return True
elif flag>2:
    def foo():
        return None
else:
    def foo():
        return False

cdef class Bar:
    def __init__(self):
        pass

class C:
    def f(self):
        return False
    def f(self):
        return True

def test_in_closure():
    """
    >>> test_in_closure()
    True
    """
    n = True
    if flag>3:
        def foo():
            return n
    else:
        def foo():
            return not n
    return foo()

