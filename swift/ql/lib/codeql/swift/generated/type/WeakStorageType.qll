// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.type.ReferenceStorageType

class WeakStorageTypeBase extends Ipa::TWeakStorageType, ReferenceStorageType {
  override string getAPrimaryQlClass() { result = "WeakStorageType" }
}
