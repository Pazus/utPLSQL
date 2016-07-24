create or replace package body ut_assert_buffer is

  current_test_results ut_execution_result;
  current_reporter     ut_suite_reporter;

  -- PUBLIC
  procedure start_new_test( a_reporter ut_suite_reporter) is
  begin
    current_reporter :=  a_reporter;
    current_test_results := ut_execution_result();
  end;

  function get_test_results return ut_execution_result is
  begin
    current_test_results.end_time := current_timestamp;
    return current_test_results;
  end;

  procedure begin_assert(a_message varchar2) is
  begin
    if current_reporter is not null then
      current_reporter.begin_assert(a_message);
    end if;
  end;

  procedure end_assert(an_assertion ut_assert_result) is
  begin
    current_test_results.add_execution(an_assertion);
    if current_reporter is not null then
      current_reporter.end_assert(an_assertion);
    end if;
  end;

end ut_assert_buffer;
/
