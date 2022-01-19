/**
 * Provides classes and predicates to reason about Intent URI permission manipulation
 * vulnerabilities on Android.
 */

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.frameworks.android.Intent

/**
 * A sink for Intent URI permission manipulation vulnerabilities in Android,
 * that is, method calls that return an Intent as the result of an Activity.
 */
abstract class IntentUriPermissionManipulationSink extends DataFlow::Node { }

/**
 * A sanitizer that makes sure that an Intent is safe to be returned to another Activity.
 *
 * Usually, this is done by setting the Intent's data URI and/or its flags to safe values.
 */
abstract class IntentUriPermissionManipulationSanitizer extends DataFlow::Node { }

/**
 * A guard that makes sure that an Intent is safe to be returned to another Activity.
 *
 * Usually, this is done by checking that the Intent's data URI and/or its flags contain
 * expected values.
 */
abstract class IntentUriPermissionManipulationGuard extends DataFlow::BarrierGuard { }

private class DefaultIntentUriPermissionManipulationSink extends IntentUriPermissionManipulationSink {
  DefaultIntentUriPermissionManipulationSink() {
    exists(MethodAccess ma | ma.getMethod() instanceof ActivitySetResultMethod |
      ma.getArgument(1) = this.asExpr()
    )
  }
}

/**
 * Sanitizer that prevents access to arbitrary content providers by modifying the Intent in one of
 * the following ways:
 * * Removing the flags `FLAG_GRANT_READ_URI_PERMISSION` and `FLAG_GRANT_WRITE_URI_PERMISSION`.
 * * Setting the flags to a combination that doesn't include `FLAG_GRANT_READ_URI_PERMISSION` or
 * `FLAG_GRANT_WRITE_URI_PERMISSION`.
 * * Replacing the data URI.
 */
private class IntentFlagsOrDataChangedSanitizer extends IntentUriPermissionManipulationSanitizer {
  IntentFlagsOrDataChangedSanitizer() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeIntent and
      this.asExpr() = ma.getQualifier()
    |
      m.hasName("removeFlags") and
      TaintTracking::localExprTaint(any(GrantReadUriPermissionFlag f).getAnAccess(),
        ma.getArgument(0)) and
      TaintTracking::localExprTaint(any(GrantWriteUriPermissionFlag f).getAnAccess(),
        ma.getArgument(0))
      or
      m.hasName("setFlags") and
      not TaintTracking::localExprTaint(any(GrantUriPermissionFlag f).getAnAccess(),
        ma.getArgument(0))
      or
      m.hasName("setData")
    )
  }
}

/**
 * A guard that checks an Intent's flags or data URI to make sure they are trusted.
 * It matches the following patterns:
 *
 * ```java
 * if (intent.getData().equals("trustedValue")) {}
 *
 * if (intent.getFlags() & Intent.FLAG_GRANT_READ_URI_PERMISSION == 0 &&
 *      intent.getFlags() & Intent.FLAG_GRANT_WRITE_URI_PERMISSION == 0) {}
 *
 * if (intent.getFlags() & Intent.FLAG_GRANT_READ_URI_PERMISSION != 0 ||
 *      intent.getFlags() & Intent.FLAG_GRANT_WRITE_URI_PERMISSION != 0) {}
 * ```
 */
private class IntentFlagsOrDataCheckedGuard extends IntentUriPermissionManipulationGuard {
  Expr condition;

  IntentFlagsOrDataCheckedGuard() { intentFlagsOrDataChecked(this, _, _) }

  override predicate checks(Expr e, boolean branch) { intentFlagsOrDataChecked(this, e, branch) }
}

/**
 * Holds if `g` checks `intent` when the result of an `intent.getFlags` or `intent.getData` call
 * is equality-tested.
 */
private predicate intentFlagsOrDataChecked(Guard g, Expr intent, boolean branch) {
  exists(MethodAccess ma, Method m, Expr checkedValue |
    ma.getQualifier() = intent and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeIntent and
    m.hasName(["getFlags", "getData"]) and
    TaintTracking::localExprTaint(ma, checkedValue)
  |
    bitwiseCheck(g, branch) and
    checkedValue = g.(EqualityTest).getAnOperand().(AndBitwiseExpr)
    or
    g.(MethodAccess).getMethod() instanceof EqualsMethod and
    branch = true and
    checkedValue = [g.(MethodAccess).getArgument(0), g.(MethodAccess).getQualifier()]
  )
}

/**
 * Holds if `g` is a bitwise check. `branch` is `true` when the expected value is `0`
 * and `false` otherwise.
 */
private predicate bitwiseCheck(Guard g, boolean branch) {
  exists(CompileTimeConstantExpr operand | operand = g.(EqualityTest).getAnOperand() |
    if operand.getIntValue() = 0
    then g.(EqualityTest).polarity() = branch
    else g.(EqualityTest).polarity().booleanNot() = branch
  )
}
