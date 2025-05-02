/**
 * @name HTTP header injection
 * @description User-controlled data used in HTTP headers can lead to HTTP header injection vulnerabilities.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/http-header-injection
 * @tags security
 *       external/cwe/cwe-113
 */

import javascript
import DataFlow::PathGraph

/**
 * A data flow source for HTTP header injection vulnerabilities.
 */
class HeaderInjectionSource extends DataFlow::Node {
  HeaderInjectionSource() {
    this instanceof DataFlow::ParameterNode or
    this.(DataFlow::PropRead).getPropertyName() = "url" or
    this = DataFlow::globalVarRef("location") or
    this.(DataFlow::PropRead).getPropertyName() = "location"
  }
}

/**
 * A data flow sink for HTTP header injection vulnerabilities.
 */
class HeaderInjectionSink extends DataFlow::Node {
  HeaderInjectionSink() {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "setHeader" and
      this = call.getArgument(1)
    )
  }
}

/**
 * A sanitizer for HTTP header injection.
 */
class HeaderInjectionSanitizer extends DataFlow::Node {
  HeaderInjectionSanitizer() {
    exists(DataFlow::CallNode call |
      call.getCalleeName() = ["encodeURIComponent", "encodeURI"] and
      this = call
    )
  }
}

/**
 * A configuration for tracking HTTP header injection.
 */
class HeaderInjectionConfiguration extends DataFlow::Configuration {
  HeaderInjectionConfiguration() { this = "HeaderInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof HeaderInjectionSource
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof HeaderInjectionSink
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof HeaderInjectionSanitizer
  }
}

from HeaderInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "HTTP header value depends on a $@.", source.getNode(), "user-provided value" 