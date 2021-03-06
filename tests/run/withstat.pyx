from __future__ import with_statement

import sys

def typename(t):
    name = type(t).__name__
    if sys.version_info < (2,5):
        if name == 'classobj' and issubclass(t, MyException):
            name = 'type'
        elif name == 'instance' and isinstance(t, MyException):
            name = 'MyException'
    return u"<type '%s'>" % name

class MyException(Exception):
    pass

class ContextManager(object):
    def __init__(self, value, exit_ret = None):
        self.value = value
        self.exit_ret = exit_ret

    def __exit__(self, a, b, tb):
        print u"exit", typename(a), typename(b), typename(tb)
        return self.exit_ret
        
    def __enter__(self):
        print u"enter"
        return self.value

def no_as():
    """
    >>> no_as()
    enter
    hello
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager(u"value"):
        print u"hello"
        
def basic():
    """
    >>> basic()
    enter
    value
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager(u"value") as x:
        print x
        
def with_pass():
    """
    >>> with_pass()
    enter
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager(u"value") as x:
        pass
        
def with_return():
    """
    >>> with_return()
    enter
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager(u"value") as x:
        # FIXME: DISABLED - currently crashes!!
        # return x
        pass

def with_exception(exit_ret):
    """
    >>> with_exception(None)
    enter
    value
    exit <type 'type'> <type 'MyException'> <type 'traceback'>
    outer except
    >>> with_exception(True)
    enter
    value
    exit <type 'type'> <type 'MyException'> <type 'traceback'>
    """
    try:
        with ContextManager(u"value", exit_ret=exit_ret) as value:
            print value
            raise MyException()
    except:
        print u"outer except"

def multitarget():
    """
    >>> multitarget()
    enter
    1 2 3 4 5
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager((1, 2, (3, (4, 5)))) as (a, b, (c, (d, e))):
        print a, b, c, d, e

def tupletarget():
    """
    >>> tupletarget()
    enter
    (1, 2, (3, (4, 5)))
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager((1, 2, (3, (4, 5)))) as t:
        print t

def typed():
    """
    >>> typed()
    enter
    10
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    cdef unsigned char i
    c = ContextManager(255)
    with c as i:
        i += 11
        print i

def multimanager():
    """
    >>> multimanager()
    enter
    enter
    enter
    enter
    enter
    enter
    2
    value
    1 2 3 4 5
    nested
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    exit <type 'NoneType'> <type 'NoneType'> <type 'NoneType'>
    """
    with ContextManager(1), ContextManager(2) as x, ContextManager(u'value') as y,\
            ContextManager(3), ContextManager((1, 2, (3, (4, 5)))) as (a, b, (c, (d, e))):
        with ContextManager(u'nested') as nested:
            print x
            print y
            print a, b, c, d, e
            print nested

