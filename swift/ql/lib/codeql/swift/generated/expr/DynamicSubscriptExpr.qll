// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.DynamicLookupExpr

class DynamicSubscriptExprBase extends Ipa::TDynamicSubscriptExpr, DynamicLookupExpr {
  override string getAPrimaryQlClass() { result = "DynamicSubscriptExpr" }
}
