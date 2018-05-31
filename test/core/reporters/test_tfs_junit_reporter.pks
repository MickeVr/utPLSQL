create or replace package test_tfs_junit_reporter as

  --%suite(ut_tfs_junit_reporter)
  --%suitepath(utplsql.core.reporters)

  --%beforeall
  procedure crate_a_test_package;

  --%test(Escapes special characters from test and suite description)
  procedure escapes_special_chars;

  --%test(Reports only failed expectations and exceptions)
  procedure reports_only_failed_or_errored;

  --%test(Reports failed line of test)
  procedure reports_failed_line;

  --%test(Check that classname is returned correct suite)
  procedure check_classname_suite;
  
  --%test(Check that classname is returned correct suitepath)
  procedure check_classname_suitepath;

  --%test(Check that nested suites are being flatten)
  procedure check_flatten_nested_suites;

  --%test(Reports duration according to XML specification for numbers)
  procedure check_nls_number_formatting;

  --%afterall
  procedure remove_test_package;
end;
/
