/**
 * @name Insecure randomness
 * @description Using Math.random() for security-sensitive operations can be dangerous
 *              as it is not cryptographically secure.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.0
 * @precision high
 * @id js/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 *       external/cwe/cwe-330
 */

import javascript

/**
 * Holds if `call` is a call to `Math.random()`.
 */
predicate isMathRandomCall(DataFlow::CallNode call) {
  call.getCalleeName() = "random" and call.getReceiver().toString() = "Math"
}

/**
 * Holds if `node` is used in a security-sensitive context.
 */
predicate isSecuritySensitiveContext(DataFlow::Node node) {
  // Used in a password-related context
  exists(DataFlow::Node context |
    (
      // Variable or property name suggests password usage
      exists(string name |
        (
          context.(DataFlow::VarDeclaration).getVariableName() = name or
          context.(DataFlow::PropWrite).getPropertyName() = name or
          context.(DataFlow::CallNode).getArgument(0).toString() = name
        ) and
        name.toLowerCase().regexpMatch(".*(password|secret|token|key|auth|cred|secure).*")
      )
    ) and
    node.getASuccessor*() = context
  )
  or
  // Used in a security-related function
  exists(Function f |
    (
      f.getName().toLowerCase().regexpMatch(".*(auth|login|verify|validate|sign|encrypt|hash).*") or
      f.getFile().getAbsolutePath().regexpMatch(".*(auth|security|crypto|login).*")
    ) and
    node.getASuccessor*() = DataFlow::valueNode(f)
  )
}

from DataFlow::CallNode call
where
  isMathRandomCall(call) and
  isSecuritySensitiveContext(call)
select call, "Math.random() should not be used for security-sensitive operations as it is not cryptographically secure. Use crypto.randomBytes() instead." 