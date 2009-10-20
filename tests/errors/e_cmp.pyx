cdef void foo():
	cdef int bool, int1
	cdef char *ptr2
	cdef int *ptr3
	cdef object i = 5

	bool = i == ptr2  # evaluated in Python space
	bool = ptr3 == i # error
	bool = int1 == ptr2 # error
	bool = ptr2 == ptr3 # error

_ERRORS = u"""
 8:13: Invalid types for '==' (int *, Python object)
 9:13: Invalid types for '==' (int, char *)
10:13: Invalid types for '==' (char *, int *)
"""
