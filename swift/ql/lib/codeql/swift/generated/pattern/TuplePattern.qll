// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.pattern.Pattern

class TuplePatternBase extends Ipa::TTuplePattern, Pattern {
  override string getAPrimaryQlClass() { result = "TuplePattern" }

  Pattern getImmediateElement(int index) {
    result =
      Ipa::convertPatternFromDb(Ipa::convertTuplePatternToDb(this)
            .(Db::TuplePattern)
            .getElement(index))
  }

  final Pattern getElement(int index) { result = getImmediateElement(index).resolve() }

  final Pattern getAnElement() { result = getElement(_) }

  final int getNumberOfElements() { result = count(getAnElement()) }
}
