create or replace package body ut_assert is


  --PRIVATE
  procedure report_assert(assert_result in integer, message in varchar2, expected in varchar2 default null, actual in varchar2 default null) is
  begin
    $if $$ut_trace $then
    dbms_output.put_line('ut_assert.report_assert :' || assert_result || ':' || message);
    $end
    ut_assert_buffer.end_assert(
      ut_assert_result(assert_result, message,expected, actual, current_timestamp)
    );
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
    ut_assert_buffer.begin_assert(msg);
    if expected = actual then
      report_success(msg, expected, actual);
    else
      report_failure(msg, expected, actual);
    end if;
  end;

end ut_assert;
/
