// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.decl.GenericTypeDecl
import codeql.swift.elements.decl.IterableDeclContext
import codeql.swift.elements.type.Type

class NominalTypeDeclBase extends Ipa::TNominalTypeDecl, GenericTypeDecl, IterableDeclContext {
  Type getImmediateType() {
    result =
      Ipa::convertTypeFromDb(Ipa::convertNominalTypeDeclToDb(this).(Db::NominalTypeDecl).getType())
  }

  final Type getType() { result = getImmediateType().resolve() }
}
