// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.ApplyExpr

class BinaryExprBase extends Ipa::TBinaryExpr, ApplyExpr {
  override string getAPrimaryQlClass() { result = "BinaryExpr" }
}
