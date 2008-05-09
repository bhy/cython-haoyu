# Note: Work in progress

import os
import re
import time
import codecs
from StringIO import StringIO

import Version
from Code import CCodeWriter
from Cython import Utils

# need one-characters subsitutions (for now) so offsets aren't off
special_chars = [(u'<', u'\xF0', u'&lt;'),
                 (u'>', u'\xF1', u'&gt;'), 
                 (u'&', u'\xF2', u'&amp;')]

class AnnotationCCodeWriter(CCodeWriter):

    def __init__(self, f):
        CCodeWriter.__init__(self, self)
        self.buffer = StringIO()
        self.real_f = f
        self.annotations = []
        self.last_pos = None
        self.code = {}
        
    def getvalue(self):
        return self.real_f.getvalue()
        
    def write(self, s):
        self.real_f.write(s)
        self.buffer.write(s)
        
    def mark_pos(self, pos):
#        if pos is not None:
#            CCodeWriter.mark_pos(self, pos)
#        return
        if self.last_pos:
            try:
                code = self.code[self.last_pos[1]]
            except KeyError:
                code = ""
            self.code[self.last_pos[1]] = code + self.buffer.getvalue()
        self.buffer = StringIO()
        self.last_pos = pos

    def annotate(self, pos, item):
        self.annotations.append((pos, item))
        
    def save_annotation(self, filename):
        self.mark_pos(None)
        f = Utils.open_source_file(filename)
        lines = f.readlines()
        for k in range(len(lines)):
            line = lines[k]
            for c, cc, html in special_chars:
                line = line.replace(c, cc)
            lines[k] = line
        f.close()
        all = []
        for pos, item in self.annotations:
            if pos[0] == filename:
                start = item.start()
                size, end = item.end()
                if size:
                    all.append((pos, start))
                    all.append(((filename, pos[1], pos[2]+size), end))
                else:
                    all.append((pos, start+end))
                
        all.sort()
        all.reverse()
        for pos, item in all:
            _, line_no, col = pos
            line_no -= 1
            col += 1
            line = lines[line_no]
            lines[line_no] = line[:col] + item + line[col:]
        
        f = codecs.open("%s.html" % filename, "w", encoding="UTF-8")
        f.write(u'<html>\n')
        f.write(u"""
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">

body { font-family: courier; font-size: 12; }

.code  { font-size: 9; color: #444444; display: none; margin-left: 20px; }
.py_api  { color: red; }
.pyx_api  { color: #FF3000; }
.py_macro_api  { color: #FF8000; }
.error_goto  { color: #FF8000; }

.tag  {  }

.coerce  { color: #008000; border: 1px dotted #008000 }

.py_attr { color: #FF0000; font-weight: bold; }
.c_attr  { color: #0000FF; }

.py_call { color: #FF0000; font-weight: bold; }
.c_call  { color: #0000FF; }

.line { margin: 0em }

</style>
<script>
function toggleDiv(id) {
    theDiv = document.getElementById(id);
    if (theDiv.style.display == 'none') theDiv.style.display = 'block';
    else theDiv.style.display = 'none';
}
</script>
</head>
        """)
        f.write(u'<body>\n')
        f.write(u'<p>Generated by Cython %s on %s\n' % (Version.version, time.asctime()))
        c_file = Utils.encode_filename(os.path.basename(filename)[:-3] + 'c')
        f.write(u'<p>Raw output: <a href="%s">%s</a>\n' % (c_file, c_file))
        k = 0
        
        py_c_api = re.compile(u'(Py[A-Z][a-z]+_[A-Z][a-z][A-Za-z_]+)')
        pyx_api = re.compile(u'(__Pyx[A-Za-z_]+)\(')
        py_marco_api = re.compile(u'(Py[A-Za-z]*_[A-Z][A-Z_]+)')
        error_goto = re.compile(ur'((; *if .*)? \{__pyx_filename = .*goto __pyx_L\w+;\})')
        
        for line in lines:

            k += 1
            try:
                code = self.code[k]
            except KeyError:
                code = ''
                
            code, c_api_calls = py_c_api.subn(ur"<span class='py_api'>\1</span>", code)
            code, pyx_api_calls = pyx_api.subn(ur"<span class='pyx_api'>\1</span>(", code)
            code, macro_api_calls = py_marco_api.subn(ur"<span class='py_macro_api'>\1</span>", code)
            code, error_goto_calls = error_goto.subn(ur"<span class='error_goto'>\1</span>", code)
            
            code = code.replace(u"<span class='error_goto'>;", u";<span class='error_goto'>")
            
            color = u"FFFF%02x" % int(255/(1+(5*c_api_calls+2*pyx_api_calls+macro_api_calls)/10.0))
            f.write(u"<pre class='line' style='background-color: #%s' onclick='toggleDiv(\"line%s\")'>" % (color, k))

            f.write(u" %d: " % k)
            for c, cc, html in special_chars:
                line = line.replace(cc, html)
            f.write(line.rstrip())
                
            f.write(u'</pre>\n')
            f.write(u"<pre id='line%s' class='code' style='background-color: #%s'>%s</pre>" % (k, color, code))
        f.write(u'</body></html>\n')
        f.close()
        

# TODO: make this cleaner
def escape(raw_string):
    raw_string = raw_string.replace(u"\'", ur"&#146;")
    raw_string = raw_string.replace(u'\"', ur'&quot;')
    raw_string = raw_string.replace(u'\n', ur'<br>\n')
    raw_string = raw_string.replace(u'\t', ur'\t')
    return raw_string


class AnnotationItem:
    
    def __init__(self, style, text, tag="", size=0):
        self.style = style
        self.text = text
        self.tag = tag
        self.size = size
        
    def start(self):
        return u"<span class='tag %s' title='%s'>%s" % (self.style, self.text, self.tag)
    
    def end(self):
        return self.size, u"</span>"
