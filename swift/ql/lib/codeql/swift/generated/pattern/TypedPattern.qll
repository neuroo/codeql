// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.pattern.Pattern
import codeql.swift.elements.type.TypeRepr

class TypedPatternBase extends Ipa::TTypedPattern, Pattern {
  override string getAPrimaryQlClass() { result = "TypedPattern" }

  Pattern getImmediateSubPattern() {
    result =
      Ipa::convertPatternFromDb(Ipa::convertTypedPatternToDb(this)
            .(Db::TypedPattern)
            .getSubPattern())
  }

  final Pattern getSubPattern() { result = getImmediateSubPattern().resolve() }

  TypeRepr getImmediateTypeRepr() {
    result =
      Ipa::convertTypeReprFromDb(Ipa::convertTypedPatternToDb(this).(Db::TypedPattern).getTypeRepr())
  }

  final TypeRepr getTypeRepr() { result = getImmediateTypeRepr().resolve() }

  final predicate hasTypeRepr() { exists(getTypeRepr()) }
}
