// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.AstNode
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.Locatable

class IfConfigClauseBase extends Ipa::TIfConfigClause, Locatable {
  override string getAPrimaryQlClass() { result = "IfConfigClause" }

  Expr getImmediateCondition() {
    result =
      Ipa::convertExprFromDb(Ipa::convertIfConfigClauseToDb(this)
            .(Db::IfConfigClause)
            .getCondition())
  }

  final Expr getCondition() { result = getImmediateCondition().resolve() }

  final predicate hasCondition() { exists(getCondition()) }

  AstNode getImmediateElement(int index) {
    result =
      Ipa::convertAstNodeFromDb(Ipa::convertIfConfigClauseToDb(this)
            .(Db::IfConfigClause)
            .getElement(index))
  }

  final AstNode getElement(int index) { result = getImmediateElement(index).resolve() }

  final AstNode getAnElement() { result = getElement(_) }

  final int getNumberOfElements() { result = count(getAnElement()) }

  predicate isActive() { Ipa::convertIfConfigClauseToDb(this).(Db::IfConfigClause).isActive() }
}
