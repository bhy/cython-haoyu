"""
>>> Foo.incr.__module__ is not None
True
>>> Foo.incr.__module__ == Foo.__module__ == bar.__module__
True

"""
class Foo(object):
   def incr(self,x):
       return x+1

def bar():
    pass
