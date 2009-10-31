
cimport cython

cdef class MyType:
    def __init__(self):
        print "INIT"

cdef class MySubType(MyType):
    def __init__(self):
        print "INIT"

class MyClass(object):
    def __init__(self):
        print "INIT"

class MyTypeSubClass(MyType):
    def __init__(self):
        print "INIT"

# only this can be safely optimised:

@cython.test_assert_path_exists('//PythonCapiCallNode')
@cython.test_fail_if_path_exists('//SimpleCallNode/AttributeNode')
def make_new():
    """
    >>> isinstance(make_new(), MyType)
    True
    """
    m = MyType.__new__(MyType)
    return m

@cython.test_assert_path_exists('//PythonCapiCallNode')
@cython.test_fail_if_path_exists('//SimpleCallNode/AttributeNode')
def make_new_builtin():
    """
    >>> isinstance(make_new_builtin(), tuple)
    True
    """
    m = dict.__new__(dict)
    m = list.__new__(list)
    m = tuple.__new__(tuple)
    return m

# these cannot:

@cython.test_assert_path_exists('//SimpleCallNode/AttributeNode')
@cython.test_fail_if_path_exists('//PythonCapiCallNode')
def make_new_pyclass():
    """
    >>> isinstance(make_new_pyclass(), MyTypeSubClass)
    True
    """
    m = MyClass.__new__(MyClass)
    m = MyTypeSubClass.__new__(MyTypeSubClass)
    return m

@cython.test_assert_path_exists('//SimpleCallNode/AttributeNode')
@cython.test_fail_if_path_exists('//PythonCapiCallNode')
def make_new_args(type t1=None, type t2=None):
    """
    >>> isinstance(make_new_args(), MyType)
    True
    >>> isinstance(make_new_args(MyType), MyType)
    True
    >>> isinstance(make_new_args(MyType, MyType), MyType)
    True

    >>> isinstance(make_new_args(MyType, MySubType), MySubType)
    Traceback (most recent call last):
    TypeError: tp_new.MyType.__new__(tp_new.MySubType) is not safe, use tp_new.MySubType.__new__()
    >>> isinstance(make_new_args(MySubType, MyType), MyType)
    Traceback (most recent call last):
    TypeError: tp_new.MySubType.__new__(tp_new.MyType): tp_new.MyType is not a subtype of tp_new.MySubType
    """
    if t1 is None:
        t1 = MyType
    if t2 is None:
        t2 = MyType
    m = t1.__new__(t2)
    return m

@cython.test_assert_path_exists('//SimpleCallNode/AttributeNode')
@cython.test_fail_if_path_exists('//PythonCapiCallNode')
def make_new_none(type t1=None, type t2=None):
    """
    >>> isinstance(make_new_none(), MyType)
    Traceback (most recent call last):
    TypeError: object.__new__(X): X is not a type object (NoneType)
    """
    m = t1.__new__(t2)
    return m

@cython.test_assert_path_exists('//SimpleCallNode/AttributeNode')
@cython.test_fail_if_path_exists('//PythonCapiCallNode')
def make_new_none_typed(tuple t1=None, tuple t2=None):
    """
    >>> isinstance(make_new_none(), MyType)
    Traceback (most recent call last):
    TypeError: object.__new__(X): X is not a type object (NoneType)
    """
    m = t1.__new__(t2)
    return m

@cython.test_assert_path_exists('//SimpleCallNode/AttributeNode')
@cython.test_fail_if_path_exists('//PythonCapiCallNode')
def make_new_untyped(t):
    """
    >>> make_new_untyped(None)
    Traceback (most recent call last):
    TypeError: object.__new__(X): X is not a type object (NoneType)
    """
    m = t.__new__(t)
    return m
