cdef void foo(obj):
	cdef int i1
	cdef char *p1
	cdef int *p2
	i1 = p1 # error
	p2 = obj # error
_ERRORS = u"""
5:16: Cannot assign type 'char *' to 'int'
6:17: Cannot convert Python object to 'int *'
"""
