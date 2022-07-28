// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.Expr

class VarargExpansionExprBase extends Ipa::TVarargExpansionExpr, Expr {
  override string getAPrimaryQlClass() { result = "VarargExpansionExpr" }

  Expr getImmediateSubExpr() {
    result =
      Ipa::convertExprFromDb(Ipa::convertVarargExpansionExprToDb(this)
            .(Db::VarargExpansionExpr)
            .getSubExpr())
  }

  final Expr getSubExpr() { result = getImmediateSubExpr().resolve() }
}
