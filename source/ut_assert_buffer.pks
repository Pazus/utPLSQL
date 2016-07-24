create or replace package ut_assert_buffer authid current_user as

  procedure start_new_test(a_reporter ut_suite_reporter);
  function get_test_results return ut_execution_result;

  procedure begin_assert(a_message varchar2);
  procedure end_assert(an_assertion ut_assert_result);

end ut_assert_buffer;
/
