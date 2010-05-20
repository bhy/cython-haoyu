def simple():
    """
    >>> simple() 
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

def assign():
    """
    >>> assign() 
    1
    """
    # 'nonlocal' NAME (',' NAME)*
    xx = 0
    def ff():
        nonlocal xx
        xx=1
        print(xx)
    ff()

def nested():
    """
    >>> nested() 
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

