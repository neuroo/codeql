// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.ErrorElement
import codeql.swift.elements.expr.Expr

module Generated {
  class UnresolvedDotExpr extends Synth::TUnresolvedDotExpr, Expr, ErrorElement {
    override string getAPrimaryQlClass() { result = "UnresolvedDotExpr" }

    /**
     * Gets the base of this unresolved dot expression.
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Expr getImmediateBase() {
      result =
        Synth::convertExprFromRaw(Synth::convertUnresolvedDotExprToRaw(this)
              .(Raw::UnresolvedDotExpr)
              .getBase())
    }

    /**
     * Gets the base of this unresolved dot expression.
     */
    final Expr getBase() { result = getImmediateBase().resolve() }

    /**
     * Gets the name of this unresolved dot expression.
     */
    string getName() {
      result = Synth::convertUnresolvedDotExprToRaw(this).(Raw::UnresolvedDotExpr).getName()
    }
  }
}
