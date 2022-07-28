// generated by codegen/codegen.py
private import codeql.swift.generated.Ipa
private import codeql.swift.generated.Db
import codeql.swift.elements.decl.AbstractFunctionDecl
import codeql.swift.elements.expr.Expr

class ObjCSelectorExprBase extends Ipa::TObjCSelectorExpr, Expr {
  override string getAPrimaryQlClass() { result = "ObjCSelectorExpr" }

  Expr getImmediateSubExpr() {
    result =
      Ipa::convertExprFromDb(Ipa::convertObjCSelectorExprToDb(this)
            .(Db::ObjCSelectorExpr)
            .getSubExpr())
  }

  final Expr getSubExpr() { result = getImmediateSubExpr().resolve() }

  AbstractFunctionDecl getImmediateMethod() {
    result =
      Ipa::convertAbstractFunctionDeclFromDb(Ipa::convertObjCSelectorExprToDb(this)
            .(Db::ObjCSelectorExpr)
            .getMethod())
  }

  final AbstractFunctionDecl getMethod() { result = getImmediateMethod().resolve() }
}
