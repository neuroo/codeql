// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.IdentityExpr

class DotSelfExprBase extends Ipa::TDotSelfExpr, IdentityExpr {
  override string getAPrimaryQlClass() { result = "DotSelfExpr" }
}
