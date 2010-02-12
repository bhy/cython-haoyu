# cython: infer_types = True


cimport cython
from cython cimport typeof, infer_types

##################################################
# type inference tests in 'full' mode

cdef class MyType:
    pass

def simple():
    """
    >>> simple()
    """
    i = 3
    assert typeof(i) == "long", typeof(i)
    x = 1.41
    assert typeof(x) == "double", typeof(x)
    xptr = &x
    assert typeof(xptr) == "double *", typeof(xptr)
    xptrptr = &xptr
    assert typeof(xptrptr) == "double **", typeof(xptrptr)
    b = b"abc"
    assert typeof(b) == "char *", typeof(b)
    s = "abc"
    assert typeof(s) == "str object", typeof(s)
    u = u"xyz"
    assert typeof(u) == "unicode object", typeof(u)
    L = [1,2,3]
    assert typeof(L) == "list object", typeof(L)
    t = (4,5,6)
    assert typeof(t) == "tuple object", typeof(t)

def builtin_types():
    """
    >>> builtin_types()
    """
    b = bytes()
    assert typeof(b) == "bytes object", typeof(b)
    u = unicode()
    assert typeof(u) == "unicode object", typeof(u)
    L = list()
    assert typeof(L) == "list object", typeof(L)
    t = tuple()
    assert typeof(t) == "tuple object", typeof(t)
    d = dict()
    assert typeof(d) == "dict object", typeof(d)
    B = bool()
    assert typeof(B) == "bool object", typeof(B)

def slicing():
    """
    >>> slicing()
    """
    b = b"abc"
    assert typeof(b) == "char *", typeof(b)
    b1 = b[1:2]
    assert typeof(b1) == "bytes object", typeof(b1)
    u = u"xyz"
    assert typeof(u) == "unicode object", typeof(u)
    u1 = u[1:2]
    assert typeof(u1) == "unicode object", typeof(u1)
    L = [1,2,3]
    assert typeof(L) == "list object", typeof(L)
    L1 = L[1:2]
    assert typeof(L1) == "list object", typeof(L1)
    t = (4,5,6)
    assert typeof(t) == "tuple object", typeof(t)
    t1 = t[1:2]
    assert typeof(t1) == "tuple object", typeof(t1)

def multiple_assignments():
    """
    >>> multiple_assignments()
    """
    a = 3
    a = 4
    a = 5
    assert typeof(a) == "long"
    b = a
    b = 3.1
    b = 3.14159
    assert typeof(b) == "double"
    c = a
    c = b
    c = [1,2,3]
    assert typeof(c) == "Python object"

def arithmetic():
    """
    >>> arithmetic()
    """
    a = 1 + 2
    assert typeof(a) == "long", typeof(a)
    b = 1 + 1.5
    assert typeof(b) == "double", typeof(b)
    c = 1 + <object>2
    assert typeof(c) == "Python object", typeof(c)
    d = 1 * 1.5 ** 2
    assert typeof(d) == "double", typeof(d)

def builtin_type_operations():
    """
    >>> builtin_type_operations()
    """
    b1 = b'a' * 10
    b1 = 10 * b'a'
    b1 = 10 * b'a' * 10
    assert typeof(b1) == "bytes object", typeof(b1)
    b2 = b'a' + b'b'
    assert typeof(b2) == "bytes object", typeof(b2)
    u1 = u'a' * 10
    u1 = 10 * u'a'
    assert typeof(u1) == "unicode object", typeof(u1)
    u2 = u'a' + u'b'
    assert typeof(u2) == "unicode object", typeof(u2)
    u3 = u'a%s' % u'b'
    u3 = u'a%s' % 10
    assert typeof(u3) == "unicode object", typeof(u3)
    s1 = "abc %s" % "x"
    s1 = "abc %s" % 10
    assert typeof(s1) == "str object", typeof(s1)
    s2 = "abc %s" + "x"
    assert typeof(s2) == "str object", typeof(s2)
    s3 = "abc %s" * 10
    s3 = "abc %s" * 10 * 10
    s3 = 10 * "abc %s" * 10
    assert typeof(s3) == "str object", typeof(s3)
    L1 = [] + []
    assert typeof(L1) == "list object", typeof(L1)
    L2 = [] * 2
    assert typeof(L2) == "list object", typeof(L2)
    T1 = () + ()
    assert typeof(T1) == "tuple object", typeof(T1)
    T2 = () * 2
    assert typeof(T2) == "tuple object", typeof(T2)
    
def cascade():
    """
    >>> cascade()
    """
    a = 1.0
    b = a + 2
    c = b + 3
    d = c + 4
    assert typeof(d) == "double"
    e = a + b + c + d
    assert typeof(e) == "double"

def cascaded_assignment():
    a = b = c = d = 1.0
    assert typeof(a) == "double"
    assert typeof(b) == "double"
    assert typeof(c) == "double"
    assert typeof(d) == "double"
    e = a + b + c + d
    assert typeof(e) == "double"

def increment():
    """
    >>> increment()
    """
    a = 5
    a += 1
    assert typeof(a) == "long"

def loop():
    """
    >>> loop()
    """
    for a in range(10):
        pass
    assert typeof(a) == "long"

    b = 1.0
    for b in range(5):
        pass
    assert typeof(b) == "double"

    for c from 0 <= c < 10 by .5:
        pass
    assert typeof(c) == "double"

    for d in range(0, 10L, 2):
        pass
    assert typeof(a) == "long"

cdef unicode retu():
    return u"12345"

cdef bytes retb():
    return b"12345"

def conditional(x):
    """
    >>> conditional(True)
    (True, 'Python object')
    >>> conditional(False)
    (False, 'Python object')
    """
    if x:
        a = retu()
    else:
        a = retb()
    return type(a) is unicode, typeof(a)

##################################################
# type inference tests that work in 'safe' mode

@infer_types(None)
def double_inference():
    """
    >>> values, types = double_inference()
    >>> values == (1.0, 1.0*2, 1.0*2.0+2.0*2.0, 1.0*2.0)
    True
    >>> types
    ('double', 'double', 'double', 'Python object')
    """
    d_a = 1.0
    d_b = d_a * float(2)
    d_c = d_a * float(some_float_value()) + d_b * float(some_float_value())
    o_d = d_a * some_float_value()
    return (d_a,d_b,d_c,o_d), (typeof(d_a), typeof(d_b), typeof(d_c), typeof(o_d))

cdef object some_float_value():
    return 2.0


@cython.test_fail_if_path_exists('//NameNode[@type.is_pyobject = True]')
@cython.test_assert_path_exists('//InPlaceAssignmentNode/NameNode',
                                '//NameNode[@type.is_pyobject]',
                                '//NameNode[@type.is_pyobject = False]')
@infer_types(None)
def double_loop():
    """
    >>> double_loop() == 1.0 * 10
    True
    """
    cdef int i
    d = 1.0
    for i in range(9):
        d += 1.0
    return d

@infer_types(None)
def safe_only():
    """
    >>> safe_only()
    """
    a = 1.0
    assert typeof(a) == "double", typeof(c)
    b = 1;
    assert typeof(b) == "long", typeof(b)
    c = MyType()
    assert typeof(c) == "MyType", typeof(c)
    for i in range(10): pass
    assert typeof(i) == "long", typeof(i)
    d = 1
    res = ~d
    assert typeof(d) == "long", typeof(d)

    # potentially overflowing arithmatic
    e = 1
    e += 1
    assert typeof(e) == "Python object", typeof(e)
    f = 1
    res = f * 10
    assert typeof(f) == "Python object", typeof(f)
    g = 1
    res = 10*(~g)
    assert typeof(g) == "Python object", typeof(g)
    for j in range(10):
        res = -j
    assert typeof(j) == "Python object", typeof(j)

@infer_types(None)
def args_tuple_keywords(*args, **kwargs):
    """
    >>> args_tuple_keywords(1,2,3, a=1, b=2)
    """
    assert typeof(args) == "tuple object", typeof(args)
    assert typeof(kwargs) == "dict object", typeof(kwargs)

@infer_types(None)
def args_tuple_keywords_reassign_same(*args, **kwargs):
    """
    >>> args_tuple_keywords_reassign_same(1,2,3, a=1, b=2)
    """
    assert typeof(args) == "tuple object", typeof(args)
    assert typeof(kwargs) == "dict object", typeof(kwargs)

    args = ()
    kwargs = {}

@infer_types(None)
def args_tuple_keywords_reassign_pyobjects(*args, **kwargs):
    """
    >>> args_tuple_keywords_reassign_pyobjects(1,2,3, a=1, b=2)
    """
    assert typeof(args) == "Python object", typeof(args)
    assert typeof(kwargs) == "Python object", typeof(kwargs)

    args = []
    kwargs = "test"
