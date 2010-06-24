#def build_package():
    #with open('__init__.py', 'w') as f:
        #f.write('\n')
    #with open('foo.py', 'w') as f:
        #f.write("""
#baz = 1
#def bar():
    #return 'bar'
        #""")

#build_package()
from distutils import cmd, core, version
__package__='distutils' # fool Python we are in distutils

def test1():
    """
    >>> test1() == (cmd, core, 'distutils.version')
    True
    """
    from . import cmd, core
    from .version import __name__
    return cmd, core, __name__


