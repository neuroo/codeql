private import codeql_ruby.AST
private import codeql_ruby.ast.Constant
private import internal.AST
private import internal.TreeSitter

/**
 * The base class for classes, singleton classes, and modules.
 */
class ModuleBase extends BodyStmt, TModuleBase {
  /** Gets a method defined in this module/class. */
  MethodBase getAMethod() { result = this.getAStmt() }

  /** Gets the method named `name` in this module/class, if any. */
  MethodBase getMethod(string name) { result = this.getAMethod() and result.getName() = name }

  /** Gets a class defined in this module/class. */
  Class getAClass() { result = this.getAStmt() }

  /** Gets the class named `name` in this module/class, if any. */
  Class getClass(string name) { result = this.getAClass() and result.getName() = name }

  /** Gets a module defined in this module/class. */
  Module getAModule() { result = this.getAStmt() }

  /** Gets the module named `name` in this module/class, if any. */
  Module getModule(string name) { result = this.getAModule() and result.getName() = name }
}

/**
 * A Ruby source file.
 *
 * ```rb
 * def main
 *   puts "hello world!"
 * end
 * main
 * ```
 */
class Toplevel extends ModuleBase, TToplevel {
  private Generated::Program g;

  Toplevel() { this = TToplevel(g) }

  final override string getAPrimaryQlClass() { result = "Toplevel" }

  /**
   * Gets the `n`th `BEGIN` block.
   */
  final BeginBlock getBeginBlock(int n) {
    toTreeSitter(result) =
      rank[n](int i, Generated::BeginBlock b | b = g.getChild(i) | b order by i)
  }

  /**
   * Gets a `BEGIN` block.
   */
  final BeginBlock getABeginBlock() { result = getBeginBlock(_) }

  final override predicate child(string label, AstNode child) {
    ModuleBase.super.child(label, child)
    or
    label = "getBeginBlock" and child = this.getBeginBlock(_)
  }

  final override string toString() { result = g.getLocation().getFile().getBaseName() }
}

/**
 * A class or module definition.
 *
 * ```rb
 * class Foo
 *   def bar
 *   end
 * end
 * module Bar
 *   class Baz
 *   end
 * end
 * ```
 */
class Namespace extends ModuleBase, ConstantWriteAccess, TNamespace {
  override string getAPrimaryQlClass() { result = "Namespace" }

  /**
   * Gets the name of the module/class. In the following example, the result is
   * `"Foo"`.
   * ```rb
   * class Foo
   * end
   * ```
   *
   * N.B. in the following example, where the module/class name uses the scope
   * resolution operator, the result is the name being resolved, i.e. `"Bar"`.
   * Use `getScopeExpr` to get the `Foo` for `Foo`.
   * ```rb
   * module Foo::Bar
   * end
   * ```
   */
  override string getName() { none() }

  /**
   * Gets the scope expression used in the module/class name's scope resolution
   * operation, if any.
   *
   * In the following example, the result is the `Expr` for `Foo`.
   *
   * ```rb
   * module Foo::Bar
   * end
   * ```
   *
   * However, there is no result for the following example, since there is no
   * scope resolution operation.
   *
   * ```rb
   * module Baz
   * end
   * ```
   */
  override Expr getScopeExpr() { none() }

  /**
   * Holds if the module/class name uses the scope resolution operator to access the
   * global scope, as in this example:
   *
   * ```rb
   * class ::Foo
   * end
   * ```
   */
  override predicate hasGlobalScope() { none() }

  override predicate child(string label, AstNode child) {
    ModuleBase.super.child(label, child) or
    ConstantWriteAccess.super.child(label, child)
  }

  final override string toString() { result = ConstantWriteAccess.super.toString() }
}

/**
 * A class definition.
 *
 * ```rb
 * class Foo
 *   def bar
 *   end
 * end
 * ```
 */
class Class extends Namespace, TClass {
  private Generated::Class g;

  Class() { this = TClass(g) }

  final override string getAPrimaryQlClass() { result = "Class" }

  /**
   * Gets the `Expr` used as the superclass in the class definition, if any.
   *
   * In the following example, the result is a `ConstantReadAccess`.
   * ```rb
   * class Foo < Bar
   * end
   * ```
   *
   * In the following example, where the superclass is a call expression, the
   * result is a `Call`.
   * ```rb
   * class C < foo()
   * end
   * ```
   */
  final Expr getSuperclassExpr() { toTreeSitter(result) = g.getSuperclass().getChild() }

  final override string getName() {
    result = g.getName().(Generated::Token).getValue() or
    result = g.getName().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
  }

  final override Expr getScopeExpr() {
    toTreeSitter(result) = g.getName().(Generated::ScopeResolution).getScope()
  }

  final override predicate hasGlobalScope() {
    exists(Generated::ScopeResolution sr |
      sr = g.getName() and
      not exists(sr.getScope())
    )
  }

  final override predicate child(string label, AstNode child) {
    Namespace.super.child(label, child)
    or
    label = "getSuperclassExpr" and child = this.getSuperclassExpr()
  }
}

/**
 * A definition of a singleton class on an object.
 *
 * ```rb
 * class << foo
 *   def bar
 *     p 'bar'
 *   end
 * end
 * ```
 */
class SingletonClass extends ModuleBase, TSingletonClass {
  private Generated::SingletonClass g;

  SingletonClass() { this = TSingletonClass(g) }

  final override string getAPrimaryQlClass() { result = "Class" }

  /**
   * Gets the expression resulting in the object on which the singleton class
   * is defined. In the following example, the result is the `Expr` for `foo`:
   *
   * ```rb
   * class << foo
   * end
   * ```
   */
  final Expr getValue() { toTreeSitter(result) = g.getValue() }

  final override string toString() { result = "class << ..." }

  final override predicate child(string label, AstNode child) {
    ModuleBase.super.child(label, child)
    or
    label = "getValue" and child = this.getValue()
  }
}

/**
 * A module definition.
 *
 * ```rb
 * module Foo
 *   class Bar
 *   end
 * end
 * ```
 *
 * N.B. this class represents a single instance of a module definition. In the
 * following example, classes `Bar` and `Baz` are both defined in the module
 * `Foo`, but in two syntactically distinct definitions, meaning that there
 * will be two instances of `Module` in the database.
 *
 * ```rb
 * module Foo
 *   class Bar; end
 * end
 *
 * module Foo
 *   class Baz; end
 * end
 * ```
 */
class Module extends Namespace, TModule {
  private Generated::Module g;

  Module() { this = TModule(g) }

  final override string getAPrimaryQlClass() { result = "Module" }

  final override string getName() {
    result = g.getName().(Generated::Token).getValue() or
    result = g.getName().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
  }

  final override Expr getScopeExpr() {
    toTreeSitter(result) = g.getName().(Generated::ScopeResolution).getScope()
  }

  final override predicate hasGlobalScope() {
    exists(Generated::ScopeResolution sr |
      sr = g.getName() and
      not exists(sr.getScope())
    )
  }
}
