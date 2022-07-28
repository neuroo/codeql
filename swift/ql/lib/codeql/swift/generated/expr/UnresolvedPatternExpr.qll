// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.pattern.Pattern

class UnresolvedPatternExprBase extends Ipa::TUnresolvedPatternExpr, Expr {
  override string getAPrimaryQlClass() { result = "UnresolvedPatternExpr" }

  Pattern getImmediateSubPattern() {
    result =
      Ipa::convertPatternFromDb(Ipa::convertUnresolvedPatternExprToDb(this)
            .(Db::UnresolvedPatternExpr)
            .getSubPattern())
  }

  final Pattern getSubPattern() { result = getImmediateSubPattern().resolve() }
}
