// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.AbstractClosureExpr

class ClosureExprBase extends Ipa::TClosureExpr, AbstractClosureExpr {
  override string getAPrimaryQlClass() { result = "ClosureExpr" }
}
