def testNonlocal1():
    """
    >>> testNonlocal1() 
    1
    2
    """
    # 'nonlocal' NAME (',' NAME)*
    x = 1
    y = 2
    def f():
        nonlocal x
        nonlocal x, y
        print(x)
        print(y)
    f()

def testNonlocal2():
    """
    >>> testNonlocal2() 
    1
    """
    # 'nonlocal' NAME (',' NAME)*
    xx = 0
    def ff():
        nonlocal xx
        xx=1
        print(xx)
    ff()

def testNonlocal3():
    """
    >>> testNonlocal3() 
    1
    """
    # 'nonlocal' NAME (',' NAME)*
    x = 0
    def f():
        def g():
            nonlocal x
            x=1
            print(x)
        return g
    f()()
