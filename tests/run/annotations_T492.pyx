import cython


def test_double1(x: cython.double):
    """
    >>> isinstance(test_double1(1), float)
    True
    """
    return x

def test_double2(x: cython.double):
    """
    >>> test_double2('abc') #doctest: +ELLIPSIS
    Traceback (most recent call last):
        ...
    TypeError: ...
    """
    if not cython.compiled:
        if not isinstance(x, float):
            raise TypeError('a float is required.')
    return x


@cython.cfunc
def foo(x: cython.double):
    return x

def test_foo():
    """
    >>> isinstance(test_foo(), float)
    True
    """
    return foo(1)

MyStruct = cython.struct(x=cython.int, y=cython.double)
@cython.cfunc
def feed_me_struct(a: MyStruct):
    print(a.x)
    return a.y

def test_struct():
    """
    >>> y = test_struct()
    1
    >>> isinstance(y, float)
    True
    """
    a = cython.declare(MyStruct)
    a.x = a.y = 1
    d = dict()
    return feed_me_struct(a)

@cython.cclass
class MyExtType(object):
    def shout(self):
        print("Hello!")
        return

def test_exttype(a: MyExtType):
    """
    >>> test_exttype(MyExtType())
    Hello!
    """
    a.shout()
    return

@cython.ccall
def test_dummy(a: "an argument", b: None):
    """
    >>> test_dummy(1, 2)
    (1, 2)
    """
    return (a,b)

@cython.ccall
def test_return(x) -> cython.double:
    """
    >>> isinstance(test_return(1), float)
    True
    """
    return x
