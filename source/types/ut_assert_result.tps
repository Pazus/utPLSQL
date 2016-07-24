create or replace type ut_assert_result under ut_execution_result_base
(
  expected varchar2(4000 char),
  actual   varchar2(4000 char),
  constructor function ut_assert_result(self in out nocopy ut_assert_result, a_result integer, a_name varchar2, an_expected varchar2, an_actual varchar2, an_end_time timestamp with time zone) return self as result
)
not final
/
