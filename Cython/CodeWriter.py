from Cython.Compiler.Visitor import TreeVisitor
from Cython.Compiler.Nodes import *

"""
Serializes a Cython code tree to Cython code. This is primarily useful for
debugging and testing purposes.

The output is in a strict format, no whitespace or comments from the input
is preserved (and it could not be as it is not present in the code tree).
"""

class LinesResult(object):
    def __init__(self):
        self.lines = []
        self.s = u""
        
    def put(self, s):
        self.s += s
    
    def newline(self):
        self.lines.append(self.s)
        self.s = u""
    
    def putline(self, s):
        self.put(s)
        self.newline()

class CodeWriter(TreeVisitor):

    indent_string = u"    "
    
    def __init__(self, result = None):
        super(CodeWriter, self).__init__()
        if result is None:
            result = LinesResult()
        self.result = result
        self.numindents = 0
    
    def write(self, tree):
        self.visit(tree)
    
    def indent(self):
        self.numindents += 1
    
    def dedent(self):
        self.numindents -= 1
    
    def startline(self, s = u""):
        self.result.put(self.indent_string * self.numindents + s)
    
    def put(self, s):
        self.result.put(s)
    
    def endline(self, s = u""):
        self.result.putline(s)

    def line(self, s):
        self.startline(s)
        self.endline()
    
    def comma_seperated_list(self, items, output_rhs=False):
        if len(items) > 0:
            for item in items[:-1]:
                self.visit(item)
                if output_rhs and item.rhs is not None:
                    self.put(u" = ")
                    self.visit(item.rhs)
                self.put(u", ")
            self.visit(items[-1])
    
    def visit_Node(self, node):
        raise AssertionError("Node not handled by serializer: %r" % node)
    
    def visit_ModuleNode(self, node):
        self.visitchildren(node)
    
    def visit_StatListNode(self, node):
        self.visitchildren(node)

    def visit_FuncDefNode(self, node):
        self.startline(u"def %s(" % node.name)
        self.comma_seperated_list(node.args)
        self.endline(u"):")
        self.indent()
        self.visit(node.body)
        self.dedent()
    
    def visit_CArgDeclNode(self, node):
        if node.base_type.name is not None:
            self.visit(node.base_type)
            self.put(u" ")
        self.visit(node.declarator)
        if node.default is not None:
            self.put(u" = ")
            self.visit(node.default)
    
    def visit_CNameDeclaratorNode(self, node):
        self.put(node.name)
    
    def visit_CSimpleBaseTypeNode(self, node):
        # See Parsing.p_sign_and_longness
        if node.is_basic_c_type:
            self.put(("unsigned ", "", "signed ")[node.signed])
            if node.longness < 0:
                self.put("short " * -node.longness)
            elif node.longness > 0:
                self.put("long " * node.longness)
            
        self.put(node.name)
    
    def visit_SingleAssignmentNode(self, node):
        self.startline()
        self.visit(node.lhs)
        self.put(u" = ")
        self.visit(node.rhs)
        self.endline()
    
    def visit_NameNode(self, node):
        self.put(node.name)
    
    def visit_IntNode(self, node):
        self.put(node.value)
        
    def visit_IfStatNode(self, node):
        # The IfClauseNode is handled directly without a seperate match
        # for clariy.
        self.startline(u"if ")
        self.visit(node.if_clauses[0].condition)
        self.endline(":")
        self.indent()
        self.visit(node.if_clauses[0].body)
        self.dedent()
        for clause in node.if_clauses[1:]:
            self.startline("elif ")
            self.visit(clause.condition)
            self.endline(":")
            self.indent()
            self.visit(clause.body)
            self.dedent()
        if node.else_clause is not None:
            self.line("else:")
            self.indent()
            self.visit(node.else_clause)
            self.dedent()

    def visit_PassStatNode(self, node):
        self.startline(u"pass")
        self.endline()
    
    def visit_PrintStatNode(self, node):
        self.startline(u"print ")
        self.comma_seperated_list(node.arg_tuple.args)
        if not node.append_newline:
            self.put(u",")
        self.endline()

    def visit_BinopNode(self, node):
        self.visit(node.operand1)
        self.put(u" %s " % node.operator)
        self.visit(node.operand2)
    
    def visit_CVarDefNode(self, node):
        self.startline(u"cdef ")
        self.visit(node.base_type)
        self.put(u" ")
        self.comma_seperated_list(node.declarators, output_rhs=True)
        self.endline()

    def visit_ForInStatNode(self, node):
        self.startline(u"for ")
        self.visit(node.target)
        self.put(u" in ")
        self.visit(node.iterator.sequence)
        self.endline(u":")
        self.indent()
        self.visit(node.body)
        self.dedent()
        if node.else_clause is not None:
            self.line(u"else:")
            self.indent()
            self.visit(node.else_clause)
            self.dedent()

    def visit_SequenceNode(self, node):
        self.comma_seperated_list(node.args) # Might need to discover whether we need () around tuples...hmm...
    
    def visit_SimpleCallNode(self, node):
        self.put(node.function.name + u"(")
        self.comma_seperated_list(node.args)
        self.put(")")

    def visit_ExprStatNode(self, node):
        self.startline()
        self.visit(node.expr)
        self.endline()
    
    def visit_InPlaceAssignmentNode(self, node):
        self.startline()
        self.visit(node.lhs)
        self.put(" %s= " % node.operator)
        self.visit(node.rhs)
        self.endline()
    
    
