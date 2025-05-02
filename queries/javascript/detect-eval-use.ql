/**
 * @name Use of eval
 * @description Using 'eval' or 'Function' constructor with string arguments can lead to code injection vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.0
 * @precision high
 * @id js/eval-use
 * @tags security
 *       external/cwe/cwe-95
 *       external/cwe/cwe-676
 *       external/cwe/cwe-94
 */

import javascript

/**
 * Holds if `expr` is either an indirect eval, or a direct eval with more than one argument.
 */
predicate isEvalCall(CallExpr expr) {
  exists(string name |
    expr.getCalleeName() = name and
    (
      name = "eval" or
      name = "Function" or
      name = "setTimeout" or
      name = "setInterval"
    )
  )
}

from CallExpr evalCall
where isEvalCall(evalCall)
select evalCall, "Avoid using eval or Function constructor as it can lead to code injection attacks." 