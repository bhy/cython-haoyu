__doc__ = u"""
>>> func1(None)
>>> func1(*[None])
>>> func1(arg=None)
Traceback (most recent call last):
...
TypeError: func1() takes no keyword arguments
>>> func2(None)
>>> func2(*[None])
>>> func2(arg=None)
Traceback (most recent call last):
...
TypeError: func2() takes no keyword arguments
>>> func3(None)
>>> func3(*[None])
>>> func3(arg=None)

>>> A().meth1(None)
>>> A().meth1(*[None])
>>> A().meth1(arg=None)
Traceback (most recent call last):
...
TypeError: meth1() takes no keyword arguments
>>> A().meth2(None)
>>> A().meth2(*[None])
>>> A().meth2(arg=None)
Traceback (most recent call last):
...
TypeError: meth2() takes no keyword arguments
>>> A().meth3(None)
>>> A().meth3(*[None])
>>> A().meth3(arg=None)
"""

cimport cython


def func1(arg):
    pass

@cython.always_allow_keywords(False)
def func2(arg):
    pass

@cython.always_allow_keywords(True)
def func3(arg):
    pass

cdef class A:

    def meth1(self, arg):
        pass

    @cython.always_allow_keywords(False)
    def meth2(self, arg):
        pass

    @cython.always_allow_keywords(True)
    def meth3(self, arg):
        pass
