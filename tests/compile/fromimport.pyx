def f():
    from spam import eggs
    from spam.morespam import bacon, eggs, ham
    from spam import eggs as ova
    from . import spam
    from ... import spam
    from .spam import foo 
    from ...spam import foo, bar
    from ...spam.foo import bar

