def get(dict d, key):
    """
    >>> d = { 1: 10 }
    >>> d.get(1)
    10
    >>> get(d, 1)
    10

    >>> d.get(2) is None
    True
    >>> get(d, 2) is None
    True

    >>> d.get((1,2)) is None
    True
    >>> get(d, (1,2)) is None
    True

    >>> class Unhashable:
    ...    def __hash__(self):
    ...        raise ValueError

    >>> d.get(Unhashable())
    Traceback (most recent call last):
    ValueError
    >>> get(d, Unhashable())
    Traceback (most recent call last):
    ValueError

    >>> None.get(1)
    Traceback (most recent call last):
    ...
    AttributeError: 'NoneType' object has no attribute 'get'
    >>> get(None, 1)
    Traceback (most recent call last):
    ...
    AttributeError: 'NoneType' object has no attribute 'get'
    """
    return d.get(key)

def get_default(dict d, key, default):
    """
    >>> d = { 1: 10 }

    >>> d.get(1, 2)
    10
    >>> get_default(d, 1, 2)
    10

    >>> d.get(2, 2)
    2
    >>> get_default(d, 2, 2)
    2
    """
    return d.get(key, default)
