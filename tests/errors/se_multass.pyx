def f(obj1a, obj2a, obj3a, obj1b, obj2b, obj3b, obj4b):
	obj1a, (obj2a, obj3a) = obj1b, (obj2b, obj3b, obj4b)

_ERRORS = u"""
2:9: Unpacking sequence of wrong size (expected 2, got 3)
"""