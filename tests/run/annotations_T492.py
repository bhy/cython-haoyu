import cython


def test_foopy(x: cython.double):
    """
    >>> test_foopy(1)
    1.0
    """
    return x

@cython.cfunc
def foo(x: cython.double):
    return x

def test_foo():
    """
    >>> test_foo() 
    <type 'float'>
    """
    return type(foo(1))

MyStruct = cython.struct(x=cython.int, y=cython.double)
@cython.cfunc
def feed_me_struct(a: MyStruct):
    print a.x
    return a.y

def test_array():
    """
    >>> y = test_array()
    1
    >>> type(y)
    <type 'float'>
    """
    a = cython.declare(MyStruct)
    a.x = a.y = 1
    d = dict()
    return feed_me_struct(a)
