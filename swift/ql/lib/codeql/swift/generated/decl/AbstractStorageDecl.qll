// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.decl.AccessorDecl
import codeql.swift.elements.decl.ValueDecl

class AbstractStorageDeclBase extends Ipa::TAbstractStorageDecl, ValueDecl {
  AccessorDecl getImmediateAccessorDecl(int index) {
    result =
      Ipa::convertAccessorDeclFromDb(Ipa::convertAbstractStorageDeclToDb(this)
            .(Db::AbstractStorageDecl)
            .getAccessorDecl(index))
  }

  final AccessorDecl getAccessorDecl(int index) {
    result = getImmediateAccessorDecl(index).resolve()
  }

  final AccessorDecl getAnAccessorDecl() { result = getAccessorDecl(_) }

  final int getNumberOfAccessorDecls() { result = count(getAnAccessorDecl()) }
}
