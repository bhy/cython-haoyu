u"""
>>> a,b = 'a *','b *' # use non-interned strings

>>> or2_assign(2,3) == (2 or 3)
True
>>> or2_assign('a', 'b') == ('a' or 'b')
True
>>> or2_assign(a, b) == (a or b)
True

>>> or2(2,3) == (2 or 3)
True
>>> or2(0,2) == (0 or 2)
True
>>> or2('a', 'b') == ('a' or 'b')
True
>>> or2(a, b) == (a or b)
True
>>> or2('', 'b') == ('' or 'b')
True
>>> or2([], [1]) == ([] or [1])
True
>>> or2([], [a]) == ([] or [a])
True

>>> or3(0,1,2) == (0 or 1 or 2)
True
>>> or3([],(),[1]) == ([] or () or [1])
True

>>> or2_no_result(2,3)
>>> or2_no_result(0,2)
>>> or2_no_result('a','b')
>>> or2_no_result(a,b)
>>> a or b
'a *'
"""

def or2_assign(a,b):
    c = a or b
    return c

def or2(a,b):
    return a or b

def or3(a,b,c):
    d = a or b or c
    return d

def or2_no_result(a,b):
    a or b
