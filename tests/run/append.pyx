__doc__ = u"""
>>> test_append([])
None
None
None
got error
[1, 2, (3, 4)]
>>> _ = test_append(A())
appending
1
appending
2
appending
(3, 4)
got error
>>> test_append(B())
None
None
None
None
[1, 2, (3, 4), 5, 6]
"""

cdef extern from "Python.h":
    ctypedef class __builtin__.list [ object PyListObject ]:
        pass

class A:
    def append(self, x):
        print u"appending"
        return x

cdef class B(list):
    def append(self, *args):
        for arg in args:
            list.append(self, arg)

def test_append(L):
    print L.append(1)
    print L.append(2)
    print L.append((3,4))
    try:
        print L.append(5,6)
    except TypeError:
        print u"got error"
    return L

