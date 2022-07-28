// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.stmt.LabeledStmt
import codeql.swift.elements.stmt.StmtCondition

class LabeledConditionalStmtBase extends Ipa::TLabeledConditionalStmt, LabeledStmt {
  StmtCondition getImmediateCondition() {
    result =
      Ipa::convertStmtConditionFromDb(Ipa::convertLabeledConditionalStmtToDb(this)
            .(Db::LabeledConditionalStmt)
            .getCondition())
  }

  final StmtCondition getCondition() { result = getImmediateCondition().resolve() }
}
