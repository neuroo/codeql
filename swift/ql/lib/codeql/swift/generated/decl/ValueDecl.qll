// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.decl.Decl
import codeql.swift.elements.type.Type

class ValueDeclBase extends Ipa::TValueDecl, Decl {
  Type getImmediateInterfaceType() {
    result =
      Ipa::convertTypeFromDb(Ipa::convertValueDeclToDb(this).(Db::ValueDecl).getInterfaceType())
  }

  final Type getInterfaceType() { result = getImmediateInterfaceType().resolve() }
}
