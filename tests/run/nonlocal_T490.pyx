foo = 0
def testNonlocal1():
    """
    >>> testNonlocal1()
    1
    """
    nonlocal foo
    foo = 1
    print(foo)
    return

def testNonlocal2():
    """
    >>> testNonlocal2() 
    1
    """
    # 'nonlocal' NAME (',' NAME)*
    x = 0
    y = 0
    def f():
        nonlocal x
        nonlocal x, y
        x = 1
        print(x)
    f()
