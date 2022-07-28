// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.stmt.BraceStmt
import codeql.swift.elements.Element
import codeql.swift.elements.decl.ParamDecl

class CallableBase extends Ipa::TCallable, Element {
  ParamDecl getImmediateParam(int index) {
    result =
      Ipa::convertParamDeclFromDb(Ipa::convertCallableToDb(this).(Db::Callable).getParam(index))
  }

  final ParamDecl getParam(int index) { result = getImmediateParam(index).resolve() }

  final ParamDecl getAParam() { result = getParam(_) }

  final int getNumberOfParams() { result = count(getAParam()) }

  BraceStmt getImmediateBody() {
    result = Ipa::convertBraceStmtFromDb(Ipa::convertCallableToDb(this).(Db::Callable).getBody())
  }

  final BraceStmt getBody() { result = getImmediateBody().resolve() }

  final predicate hasBody() { exists(getBody()) }
}
