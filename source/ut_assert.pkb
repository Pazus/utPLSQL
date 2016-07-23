create or replace package body ut_assert is

  current_test_results ut_execution_result;
  current_reporter     ut_suite_reporter;

  --PRIVATE
  procedure report_assert(assert_result in integer, message in varchar2, expected in varchar2 default null, actual in varchar2 default null) is
    v_result ut_assert_result;
  begin
    $if $$ut_trace $then
    dbms_output.put_line('ut_assert.report_assert :' || assert_result || ':' || message);
    $end
    v_result := ut_assert_result(assert_result, message,expected, actual, current_timestamp);
    current_test_results.add_element(v_result);
    if current_reporter is not null then
      current_reporter.end_assert(v_result);
    end if;
  end;

  procedure report_success(message in varchar2, expected in varchar2, actual in varchar2) is
  begin
    report_assert(ut_utils.tr_success ,message, expected, actual);
  end;

  procedure report_failure(message in varchar2, expected in varchar2, actual in varchar2) is
  begin
    report_assert(ut_utils.tr_failure, message, expected, actual);
  end;

  -- PUBLIC
  function start_new_test( a_reporter ut_suite_reporter) return ut_execution_result is
  begin
    current_reporter :=  a_reporter;
    current_test_results := ut_execution_result();
    return current_test_results;
  end;

  function get_test_results return ut_execution_result is
  begin
    return current_test_results;
  end;

  procedure report_error(message in varchar2) is
  begin
    report_assert(ut_utils.tr_error, message);
  end;

  procedure are_equal(expected in number, actual in number) is
  begin
    are_equal('Equality test', expected, actual);
  end;

  procedure are_equal(msg in varchar2, expected in number, actual in number) is
  begin
    if current_reporter is not null then
      current_reporter.begin_assert(msg);
    end if;
    if expected = actual then
      report_success(msg, expected, actual);
    else
      report_failure(msg, expected, actual);
    end if;
  end;

end ut_assert;
/
