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
    >>> testNonlocal1() 
    1
    2
    """
    # 'nonlocal' NAME (',' NAME)*
    x = 0
    def f():
        nonlocal x
        x=1
        print(x)
    f()
