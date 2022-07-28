// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.Expr

class DynamicTypeExprBase extends Ipa::TDynamicTypeExpr, Expr {
  override string getAPrimaryQlClass() { result = "DynamicTypeExpr" }

  Expr getImmediateBaseExpr() {
    result =
      Ipa::convertExprFromDb(Ipa::convertDynamicTypeExprToDb(this)
            .(Db::DynamicTypeExpr)
            .getBaseExpr())
  }

  final Expr getBaseExpr() { result = getImmediateBaseExpr().resolve() }
}
