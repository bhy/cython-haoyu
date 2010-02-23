def test(dict d, index):
    """
    >>> d = { 1: 10 }
    >>> test(d, 1)
    10

    >>> test(d, 2)
    Traceback (most recent call last):
    ...
    KeyError: 2

    >>> test(d, (1,2))
    Traceback (most recent call last):
    ...
    KeyError: (1, 2)

    >>> class Unhashable:
    ...    def __hash__(self):
    ...        raise ValueError
    >>> test(d, Unhashable())
    Traceback (most recent call last):
    ...
    ValueError
    
    >>> test(None, 1)
    Traceback (most recent call last):
    ...
    TypeError: 'NoneType' object is unsubscriptable
    """
    return d[index]

def time_dict(dict d, ix, long N):
    """
    >>> time_dict({"abc": 1}, "abc", 1e6)
    """
    from time import time
    t = time()
    cdef int i
    for i in range(N):
        d[ix]
    return time() - t

def time_nondict(object d, ix, long N):
    """
    >>> time_nondict({"abc": 1}, "abc", 1e6)
    """
    from time import time
    t = time()
    cdef int i
    for i in range(N):
        d[ix]
    return time() - t