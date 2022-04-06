import python
import semmle.python.templates.Templates

/**
 * A file that is detected as being generated.
 */
abstract class GeneratedFile extends File {
  abstract string getTool();
}

/*
 * We distinguish between a "lax" match which just includes "generated by" or similar versus a "strict" match which includes "this file is generated by" or similar
 * "lax" matches are taken to indicate generated file if they occur at the top of a file. "strict" matches can occur anywhere.
 * There is no formal reason for the above, it just seems to work well in practice.
 */

class GenericGeneratedFile extends GeneratedFile {
  GenericGeneratedFile() {
    not this instanceof SpecificGeneratedFile and
    (
      (lax_generated_by(this, _) or lax_generated_from(this, _)) and
      dont_modify(this)
      or
      strict_generated_by(this, _)
      or
      strict_generated_from(this, _)
      or
      auto_generated(this)
    )
  }

  override string getTool() { lax_generated_by(this, result) or strict_generated_by(this, result) }
}

pragma[nomagic]
private int minStmtLine(File file) {
  result =
    min(int line |
      line = any(Stmt s | s.getLocation().getFile() = file).getLocation().getStartLine()
    )
}

pragma[nomagic]
private predicate isCommentAfterCode(Comment c, File f) {
  f = c.getLocation().getFile() and
  minStmtLine(f) < c.getLocation().getStartLine()
}

private string comment_or_docstring(File f, boolean before_code) {
  exists(Comment c |
    c.getLocation().getFile() = f and
    result = c.getText()
  |
    if isCommentAfterCode(c, f) then before_code = false else before_code = true
  )
  or
  exists(Module m | m.getFile() = f |
    result = m.getDocString().getText() and
    before_code = true
  )
}

private predicate lax_generated_by(File f, string tool) {
  exists(string comment | comment = comment_or_docstring(f, _) |
    tool =
      comment
          .regexpCapture("(?is).*\\b(?:(?:auto[ -]?)?generated|created automatically) by (?:the )?([-/\\w.]+[-/\\w]).*",
            1)
  )
}

private predicate lax_generated_from(File f, string src) {
  exists(string comment | comment = comment_or_docstring(f, _) |
    src =
      comment
          .regexpCapture("(?is).*\\b((?:auto[ -]?)?generated|created automatically) from ([-/\\w.]+[-/\\w]).*",
            1)
  )
}

private predicate strict_generated_by(File f, string tool) {
  exists(string comment | comment = comment_or_docstring(f, true) |
    tool =
      comment
          .regexpCapture("(?is)# *(?:this +)?(?:(?:code|file) +)?(?:is +)?(?:(?:auto(?:matically)?[ -]?)?generated|created automatically) by (?:the )?([-/\\w.]+[-/\\w]).*",
            1)
  )
}

private predicate strict_generated_from(File f, string src) {
  exists(string comment | comment = comment_or_docstring(f, true) |
    src =
      comment
          .regexpCapture("(?is)# *(?:this +)?(?:(?:code|file) +)?(?:is +)?(?:(?:auto(?:matically)?[ -]?)?generated|created automatically) from ([-/\\w.]+[-/\\w]).*",
            1)
  )
}

private predicate dont_modify(File f) {
  comment_or_docstring(f, _).regexpMatch("(?is).*\\b(Do not|Don't) (edit|modify|make changes)\\b.*")
}

private predicate auto_generated(File f) {
  exists(Comment c |
    c.getLocation().getFile() = f and
    c.getText()
        .regexpMatch("(?is)# *this +(code|file) +is +(auto(matically)?[ -]?generated|created automatically).*")
  )
}

/**
 * A file generated by a template engine
 */
abstract class SpecificGeneratedFile extends GeneratedFile {
  /*
   * Currently cover Spitfire, Pyxl and Mako.
   *  Django templates are not compiled to Python.
   *  Jinja2 templates are compiled direct to bytecode via the ast.
   */

  }

/** A file generated by the spitfire templating engine */
class SpitfireGeneratedFile extends SpecificGeneratedFile {
  SpitfireGeneratedFile() {
    exists(Module m | m.getFile() = this and not m instanceof SpitfireTemplate |
      exists(ImportMember template_method, ImportExpr spitfire_runtime_template |
        spitfire_runtime_template.getName() = "spitfire.runtime.template" and
        template_method.getModule() = spitfire_runtime_template and
        template_method.getName() = "template_method"
      )
    )
  }

  override string getTool() { result = "spitfire" }
}

/** A file generated by the pyxl templating engine */
class PyxlGeneratedFile extends SpecificGeneratedFile {
  PyxlGeneratedFile() { this.getSpecifiedEncoding() = "pyxl" }

  override string getTool() { result = "pyxl" }
}

/** A file generated by the mako templating engine */
class MakoGeneratedFile extends SpecificGeneratedFile {
  MakoGeneratedFile() {
    exists(Module m | m.getFile() = this |
      from_mako_import(m) = "runtime" and
      from_mako_import(m) = "filters" and
      from_mako_import(m) = "cache" and
      exists(Assign a, Name n |
        a.getScope() = m and a.getATarget() = n and n.getId() = "__M_dict_builtin"
      ) and
      exists(Assign a, Name n |
        a.getScope() = m and a.getATarget() = n and n.getId() = "__M_locals_builtin"
      ) and
      exists(Assign a, Name n |
        a.getScope() = m and a.getATarget() = n and n.getId() = "_magic_number"
      )
    )
  }

  override string getTool() { result = "mako" }
}

string from_mako_import(Module m) {
  exists(ImportMember member, ImportExpr mako |
    member.getScope() = m and
    member.getModule() = mako and
    mako.getName() = "mako"
  |
    result = member.getName()
  )
}

/** A file generated by Google's protobuf tool. */
class ProtobufGeneratedFile extends SpecificGeneratedFile {
  ProtobufGeneratedFile() {
    this.getAbsolutePath().regexpMatch(".*_pb2?.py") and
    exists(Module m | m.getFile() = this |
      exists(ImportExpr imp | imp.getEnclosingModule() = m |
        imp.getImportedModuleName() = "google.net.proto2.python.public"
      ) and
      exists(AssignStmt a, Name n |
        a.getEnclosingModule() = m and
        a.getATarget() = n and
        n.getId() = "DESCRIPTOR"
      )
    )
  }

  override string getTool() { result = "protobuf" }
}
