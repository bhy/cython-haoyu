from __future__ import division

cdef int a, b = 1, c = 2
a = b / c

_ERRORS = u'''
4:6: Cannot assign type 'double' to 'int'
'''
