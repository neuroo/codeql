// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.ImplicitConversionExpr

class DifferentiableFunctionExprBase extends Ipa::TDifferentiableFunctionExpr,
  ImplicitConversionExpr {
  override string getAPrimaryQlClass() { result = "DifferentiableFunctionExpr" }
}
