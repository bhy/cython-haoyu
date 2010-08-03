import cython
@cython.locals(x=double)
cdef func(x):
    return x**2

def test():
    """
    >>> type(test())
    <type 'float'>
    """
    return func(2)
