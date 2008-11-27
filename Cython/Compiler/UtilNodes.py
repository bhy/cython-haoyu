#
# Nodes used as utilities and support for transforms etc.
# These often make up sets including both Nodes and ExprNodes
# so it is convenient to have them in a seperate module.
#

import Nodes
import ExprNodes
from Nodes import Node
from ExprNodes import AtomicExprNode

class TempHandle(object):
    temp = None
    needs_xdecref = False
    def __init__(self, type):
        self.type = type
        self.needs_cleanup = type.is_pyobject

    def ref(self, pos):
        return TempRefNode(pos, handle=self, type=self.type)

    def cleanup_ref(self, pos):
        return CleanupTempRefNode(pos, handle=self, type=self.type)

class TempRefNode(AtomicExprNode):
    # handle   TempHandle

    def analyse_types(self, env):
        assert self.type == self.handle.type
    
    def analyse_target_types(self, env):
        assert self.type == self.handle.type

    def analyse_target_declaration(self, env):
        pass

    def calculate_result_code(self):
        result = self.handle.temp
        if result is None: result = "<error>" # might be called and overwritten
        return result

    def generate_result_code(self, code):
        pass

    def generate_assignment_code(self, rhs, code):
        if self.type.is_pyobject:
            rhs.make_owned_reference(code)
            # TODO: analyse control flow to see if this is necessary
            code.put_xdecref(self.result(), self.ctype())
        code.putln('%s = %s;' % (self.result(), rhs.result_as(self.ctype())))
        rhs.generate_post_assignment_code(code)

class CleanupTempRefNode(TempRefNode):
    # handle   TempHandle

    def generate_assignment_code(self, rhs, code):
        pass

    def generate_execution_code(self, code):
        if self.type.is_pyobject:
            code.put_decref_clear(self.result(), self.type)
            self.handle.needs_cleanup = False

class TempsBlockNode(Node):
    """
    Creates a block which allocates temporary variables.
    This is used by transforms to output constructs that need
    to make use of a temporary variable. Simply pass the types
    of the needed temporaries to the constructor.
    
    The variables can be referred to using a TempRefNode
    (which can be constructed by calling get_ref_node).
    """

    # temps   [TempHandle]
    # body    StatNode
    
    child_attrs = ["body"]

    def generate_execution_code(self, code):
        for handle in self.temps:
            managed = handle.needs_cleanup or not handle.type.is_pyobject
            handle.temp = code.funcstate.allocate_temp(
                handle.type, manage_ref=managed)
        self.body.generate_execution_code(code)
        for handle in self.temps:
            if handle.needs_cleanup:
                if handle.needs_xdecref:
                    code.put_xdecref_clear(handle.temp, handle.type)
                else:
                    code.put_decref_clear(handle.temp, handle.type)
            code.funcstate.release_temp(handle.temp)

    def analyse_control_flow(self, env):
        self.body.analyse_control_flow(env)

    def analyse_declarations(self, env):
        self.body.analyse_declarations(env)
    
    def analyse_expressions(self, env):
        self.body.analyse_expressions(env)
    
    def generate_function_definitions(self, env, code):
        self.body.generate_function_definitions(env, code)
            
    def annotate(self, code):
        self.body.annotate(code)

