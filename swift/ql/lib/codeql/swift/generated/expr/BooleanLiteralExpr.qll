// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.BuiltinLiteralExpr

class BooleanLiteralExprBase extends Ipa::TBooleanLiteralExpr, BuiltinLiteralExpr {
  override string getAPrimaryQlClass() { result = "BooleanLiteralExpr" }

  boolean getValue() {
    result = Ipa::convertBooleanLiteralExprToDb(this).(Db::BooleanLiteralExpr).getValue()
  }
}
