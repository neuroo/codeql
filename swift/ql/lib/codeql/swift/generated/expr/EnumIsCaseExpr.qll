// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.decl.EnumElementDecl
import codeql.swift.elements.expr.Expr

class EnumIsCaseExprBase extends Ipa::TEnumIsCaseExpr, Expr {
  override string getAPrimaryQlClass() { result = "EnumIsCaseExpr" }

  Expr getImmediateSubExpr() {
    result =
      Ipa::convertExprFromDb(Ipa::convertEnumIsCaseExprToDb(this).(Db::EnumIsCaseExpr).getSubExpr())
  }

  final Expr getSubExpr() { result = getImmediateSubExpr().resolve() }

  EnumElementDecl getImmediateElement() {
    result =
      Ipa::convertEnumElementDeclFromDb(Ipa::convertEnumIsCaseExprToDb(this)
            .(Db::EnumIsCaseExpr)
            .getElement())
  }

  final EnumElementDecl getElement() { result = getImmediateElement().resolve() }
}
