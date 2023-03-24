package com.semmle.js.ast;

import java.util.List;

import com.semmle.ts.ast.INodeWithSymbol;

/**
 * An import declaration, which can be of one of the following forms:
 *
 * <pre>
 *   import v from "m";
 *   import * as ns from "m";
 *   import {x, y, w as z} from "m";
 *   import v, * as ns from "m";
 *   import v, {x, y, w as z} from "m";
 *   import "m";
 * </pre>
 */
public class ImportDeclaration extends Statement implements INodeWithSymbol {
  /** List of import specifiers detailing how declarations are imported; may be empty. */
  private final List<ImportSpecifier> specifiers;

  /** The module from which declarations are imported. */
  private final Literal source;

  private final Expression assertion;

  private int symbol = -1;

  private boolean hasTypeKeyword;

  public ImportDeclaration(SourceLocation loc, List<ImportSpecifier> specifiers, Literal source, Expression assertion) {
    this(loc, specifiers, source, assertion, false);
  }

  public ImportDeclaration(SourceLocation loc, List<ImportSpecifier> specifiers, Literal source, Expression assertion, boolean hasTypeKeyword) {
    super("ImportDeclaration", loc);
    this.specifiers = specifiers;
    this.source = source;
    this.assertion = assertion;
    this.hasTypeKeyword = hasTypeKeyword;
  }

  public Literal getSource() {
    return source;
  }

  public List<ImportSpecifier> getSpecifiers() {
    return specifiers;
  }

  /** Returns the expression after the <code>assert</code> keyword, if any, such as <code>{ type: "json" }</code>. */
  public Expression getAssertion() {
    return assertion;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public int getSymbol() {
    return this.symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }

  /** Returns true if this is an <code>import type</code> declaration. */
  public boolean hasTypeKeyword() {
    return hasTypeKeyword;
  }
}
