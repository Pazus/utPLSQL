create or replace type ut_suite_reporter force as object
(
  name varchar2(250 char),
  --TODO - add override of default constructor to avoid misuse
  not instantiable member procedure begin_suite(self in out nocopy ut_suite_reporter, a_suite_name in varchar2),
  not instantiable member procedure begin_test(self in out nocopy ut_suite_reporter, a_test_name in varchar2, a_test_call_params in ut_test_call_params),
  not instantiable member procedure begin_assert(self in out nocopy ut_suite_reporter, an_assert_message in varchar2),
  not instantiable member procedure end_assert(self in out nocopy ut_suite_reporter, an_assert ut_assert_result),
  not instantiable member procedure end_test(self in out nocopy ut_suite_reporter, a_test_name in varchar2, a_test_call_params in ut_test_call_params, a_execution_result in ut_execution_result),
  not instantiable member procedure end_suite(self in out nocopy ut_suite_reporter, a_suite_name in varchar2, a_suite_execution_result in ut_execution_result),
  not instantiable member function result_to_char(a_result integer) return varchar2
)
not instantiable not final
/
