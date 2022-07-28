// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.Expr

class IfExprBase extends Ipa::TIfExpr, Expr {
  override string getAPrimaryQlClass() { result = "IfExpr" }

  Expr getImmediateCondition() {
    result = Ipa::convertExprFromDb(Ipa::convertIfExprToDb(this).(Db::IfExpr).getCondition())
  }

  final Expr getCondition() { result = getImmediateCondition().resolve() }

  Expr getImmediateThenExpr() {
    result = Ipa::convertExprFromDb(Ipa::convertIfExprToDb(this).(Db::IfExpr).getThenExpr())
  }

  final Expr getThenExpr() { result = getImmediateThenExpr().resolve() }

  Expr getImmediateElseExpr() {
    result = Ipa::convertExprFromDb(Ipa::convertIfExprToDb(this).(Db::IfExpr).getElseExpr())
  }

  final Expr getElseExpr() { result = getImmediateElseExpr().resolve() }
}
