// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.decl.AssociatedTypeDecl
import codeql.swift.elements.type.Type

class DependentMemberTypeBase extends Ipa::TDependentMemberType, Type {
  override string getAPrimaryQlClass() { result = "DependentMemberType" }

  Type getImmediateBaseType() {
    result =
      Ipa::convertTypeFromDb(Ipa::convertDependentMemberTypeToDb(this)
            .(Db::DependentMemberType)
            .getBaseType())
  }

  final Type getBaseType() { result = getImmediateBaseType().resolve() }

  AssociatedTypeDecl getImmediateAssociatedTypeDecl() {
    result =
      Ipa::convertAssociatedTypeDeclFromDb(Ipa::convertDependentMemberTypeToDb(this)
            .(Db::DependentMemberType)
            .getAssociatedTypeDecl())
  }

  final AssociatedTypeDecl getAssociatedTypeDecl() {
    result = getImmediateAssociatedTypeDecl().resolve()
  }
}
