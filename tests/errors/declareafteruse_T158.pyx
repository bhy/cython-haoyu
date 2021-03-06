def mult_decl_test():
    print "%s" % vv
    print "%s" % s
    cdef str s, vv = "Test"

def def_test():
    cdef int j = 10
    i[0] = j
    cdef int *i = NULL # pointer variables are special case

cdef cdef_test():
    cdef int j = 10
    i[0] = j
    print "%d" % i[0]
    cdef int *i = NULL

cpdef cpdef_test():
    cdef int j = 10
    i[0] = j
    print "%d" % i[0]
    cdef int *i = NULL

s.upper()
cdef str s = "Test"

class Foo(object):
    def bar(self, x, y):
        cdef unsigned long w = 20
        z = w + t
        cdef int t = 10

cdef class Foo2(object):
    print '%s' % r # check error inside class scope
    cdef str r
    def bar(self, x, y):
        cdef unsigned long w = 20
        self.r = c'r'
        print self.r
        z = w + g(t)
        cdef int t = 10

def g(x):
    return x

cdef int d = 20
baz[0] = d
cdef int *baz

print var[0][0]
cdef unsigned long long var[100][100]

# in 0.11.1 these are warnings
FUTURE_ERRORS = u"""
4:13: cdef variable 's' declared after it is used
4:16: cdef variable 'vv' declared after it is used
9:14: cdef variable 'i' declared after it is used
15:14: cdef variable 'i' declared after it is used
21:14: cdef variable 'i' declared after it is used
24:9: cdef variable 's' declared after it is used
30:17: cdef variable 't' declared after it is used
34:13: cdef variable 'r' declared after it is used
40:17: cdef variable 't' declared after it is used
47:10: cdef variable 'baz' declared after it is used
50:24: cdef variable 'var' declared after it is used
"""

syntax error

_ERRORS = u"""
40:17: cdef variable 't' declared after it is used
47:10: cdef variable 'baz' declared after it is used
50:24: cdef variable 'var' declared after it is used
67:7: Syntax error in simple statement list
"""
