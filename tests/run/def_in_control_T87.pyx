"""
>>> foo()
True
"""
import math
flag = math.pi

def foo():
    return 'bar'

if flag>3:
    def foo():
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
