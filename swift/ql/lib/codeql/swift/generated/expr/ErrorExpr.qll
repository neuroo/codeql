// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.Expr

class ErrorExprBase extends Ipa::TErrorExpr, Expr {
  override string getAPrimaryQlClass() { result = "ErrorExpr" }
}
