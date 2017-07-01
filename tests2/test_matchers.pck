create or replace package test_matchers is

  --%suite(matchers)
  --%suitepath(ut_plsql.core)
  
  --%test
  procedure test_be_less_than;  
  --%test
  procedure test_be_greater_or_equal;
  --%test
  procedure test_be_greater_than;
  --%test
  procedure test_be_less_or_equal;
  --%test
  procedure test_be_between;
  --%test
  procedure test_be_between2;
  --%test
  procedure test_match;
  --%test
  procedure test_be_empty_cursor;
  --%test
  procedure test_be_nonempty_cursor;
  --%test
  procedure test_be_empty_collection;
  --%test
  procedure test_be_nonempty_collection;
  --%test
  --%disabled
  procedure test_be_empty_others;

end test_matchers;
/
create or replace package body test_matchers is

  procedure restore_asserts(a_assert_results ut_expectation_results) is
  begin
    ut_expectation_processor.clear_expectations;
  
    if a_assert_results is not null then
      for i in 1 .. a_assert_results.count loop
        ut_expectation_processor.add_expectation_result(a_assert_results(i));
      end loop;
    end if;
  end;

  procedure exec_matcher(a_type varchar2, a_actual_value varchar2, a_expected_value varchar2, a_matcher varchar2, a_result integer, a_prefix varchar2 default null) is
    l_assert_results ut_expectation_results;
    l_result         integer;
    l_statement      varchar2(32767);
  begin
    l_assert_results := ut_expectation_processor.get_expectations_results;
    l_statement := 'declare  
  l_value1 '||a_type||' := '||a_actual_value||';
  l_value2 '||a_type||' := '||a_expected_value||';
begin ut.expect(l_value1).'||a_prefix||'to_'||a_matcher||'(l_value2); end;';
    execute immediate l_statement;
    l_result := ut_expectation_processor.get_status();
    restore_asserts(l_assert_results);
    ut.expect(l_result, 'exec_'||a_matcher||':'||chr(10)||l_statement).to_equal(a_result);
  end exec_matcher;
  
  procedure exec_be_between(a_type varchar2, a_actual_value varchar2, a_expected1_value varchar2, a_expected2_value varchar2,a_result integer) is
    l_assert_results ut_expectation_results;
    l_result         integer;
    l_statement      varchar2(32767);
  begin
    l_assert_results := ut_expectation_processor.get_expectations_results;
    l_statement := 'declare  
  l_actual_value '||a_type||' := '||a_actual_value||';
  l_value1 '||a_type||' := '||a_expected1_value||';
  l_value2 '||a_type||' := '||a_expected2_value||';
begin ut.expect(l_actual_value).to_(be_between(l_value1, l_value2)); end;';
    execute immediate l_statement;
    l_result := ut_expectation_processor.get_status();
    restore_asserts(l_assert_results);
    ut.expect(l_result, 'exec_be_between:'||chr(10)||l_statement).to_equal(a_result);
  end exec_be_between;
  
  procedure exec_be_less_than(a_type varchar2, a_actual_value varchar2, a_expected_value varchar2, a_result integer, a_prefix varchar2 default null)
    is
  begin
    exec_matcher(a_type, a_actual_value, a_expected_value, 'be_less_than',a_result, a_prefix);
  end;
  
  procedure exec_be_less_or_equal(a_type varchar2, a_actual_value varchar2, a_expected_value varchar2, a_result integer, a_prefix varchar2 default null)
    is
  begin
    exec_matcher(a_type, a_actual_value, a_expected_value, 'be_less_or_equal',a_result, a_prefix);
  end;
  
  procedure exec_be_greater_than(a_type varchar2, a_actual_value varchar2, a_expected_value varchar2, a_result integer, a_prefix varchar2 default null)
    is
  begin
    exec_matcher(a_type, a_actual_value, a_expected_value, 'be_greater_than',a_result, a_prefix);
  end;
  
  procedure exec_be_greater_or_equal(a_type varchar2, a_actual_value varchar2, a_expected_value varchar2, a_result integer, a_prefix varchar2 default null)
    is
  begin
    exec_matcher(a_type, a_actual_value, a_expected_value, 'be_greater_or_equal',a_result, a_prefix);
  end;
  
  procedure exec_be_between2(a_type varchar2, a_actual_value varchar2, a_expected1_value varchar2, a_expected2_value varchar2,a_result integer, a_not_prefix varchar2 default null) is
    l_assert_results ut_expectation_results;
    l_result         integer;
    l_statement      varchar2(32767);
  begin
    l_assert_results := ut_expectation_processor.get_expectations_results;
    l_statement := 'declare  
  l_actual_value '||a_type||' := '||a_actual_value||';
  l_value1 '||a_type||' := '||a_expected1_value||';
  l_value2 '||a_type||' := '||a_expected2_value||';
begin ut.expect(l_actual_value).'||a_not_prefix||'to_be_between(l_value1, l_value2); end;';
    execute immediate l_statement;
    l_result := ut_expectation_processor.get_status();
    restore_asserts(l_assert_results);
    ut.expect(l_result, 'exec_be_between2:'||chr(10)||l_statement).to_equal(a_result);
  end exec_be_between2;
  
  procedure exec_match(a_type varchar2, a_actual_value varchar2, a_pattern varchar2, a_modifiers varchar2, a_result integer, a_not_prefix varchar2 default null) is
    l_statement      varchar2(32767);
    l_assert_results ut_expectation_results;
    l_result         integer;
  begin
    l_assert_results := ut_expectation_processor.get_expectations_results;
    l_statement := 'declare
  l_actual    '||a_type||' := '||a_actual_value||';
  l_pattern   varchar2(32767) := :a_pattern;
  l_modifiers varchar2(32767) := :a_modifiers;
  l_result    integer;
begin ut.expect( l_actual ).'||a_not_prefix||'to_match(l_pattern, l_modifiers); end;';
    execute immediate l_statement using a_pattern, a_modifiers;
    l_result := ut_expectation_processor.get_status();
    restore_asserts(l_assert_results);
    ut.expect(l_result, 'exec_match:'||chr(10)||l_statement).to_equal(a_result);
  end;

  procedure test_be_less_than is
  begin
    
    exec_be_less_than('date', 'sysdate', 'sysdate-1', ut_utils.tr_failure, '');
    exec_be_less_than('number', '2.0', '1.99', ut_utils.tr_failure, '');
    exec_be_less_than('interval year to month', '''2-1''', '''2-0''', ut_utils.tr_failure, '');
    exec_be_less_than('interval day to second', '''2 01:00:00''', '''2 00:59:59''', ut_utils.tr_failure, '');
    exec_be_less_than('timestamp', 'to_timestamp(''1997 13'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_failure, '');
    exec_be_less_than('timestamp with time zone', 'to_timestamp_tz(''1997 12 +01:00'',''YYYY FF TZR'')', 'to_timestamp_tz(''1997 12 +02:00'',''YYYY FF TZR'')', ut_utils.tr_failure, '');
    exec_be_less_than('timestamp with local time zone', 'to_timestamp_tz(''1997 12 +01:00'',''YYYY FF TZR'')', 'to_timestamp_tz(''1997 12 +02:00'',''YYYY FF TZR'')', ut_utils.tr_failure, '');

    exec_be_less_than('date', 'sysdate-1', 'sysdate', ut_utils.tr_success, '');
    exec_be_less_than('number', '1.0', '1.01', ut_utils.tr_success, '');
    exec_be_less_than('interval year to month', '''2-1''', '''2-2''', ut_utils.tr_success, '');
    exec_be_less_than('interval day to second', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_success, '');
    exec_be_less_than('timestamp', 'to_timestamp(''1997 12'',''YYYY FF'')', 'to_timestamp(''1997 13'',''YYYY FF'')', ut_utils.tr_success, '');
    exec_be_less_than('timestamp with time zone', 'to_timestamp_tz(''1997 12 +03:00'',''YYYY FF TZR'')', 'to_timestamp_tz(''1997 12 +02:00'',''YYYY FF TZR'')', ut_utils.tr_success, '');
    exec_be_less_than('timestamp with local time zone', 'to_timestamp_tz(''1997 12 +03:00'',''YYYY FF TZR'')', 'to_timestamp_tz(''1997 12 +02:00'',''YYYY FF TZR'')', ut_utils.tr_success, '');

    exec_be_less_than('date', 'sysdate', 'sysdate-1', ut_utils.tr_success, 'not_');
    exec_be_less_than('number', '2.0', '1.99', ut_utils.tr_success, 'not_');
    exec_be_less_than('interval year to month', '''2-1''', '''2-0''', ut_utils.tr_success, 'not_');
    exec_be_less_than('interval day to second', '''2 01:00:00''', '''2 00:59:59''', ut_utils.tr_success, 'not_');
    exec_be_less_than('timestamp', 'to_timestamp(''1997 13'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_success, 'not_');
    exec_be_less_than('timestamp with time zone', 'to_timestamp_tz(''1997 12 +01:00'',''YYYY FF TZR'')', 'to_timestamp_tz(''1997 12 +02:00'',''YYYY FF TZR'')', ut_utils.tr_success, 'not_');
    exec_be_less_than('timestamp with local time zone', 'to_timestamp_tz(''1997 12 +01:00'',''YYYY FF TZR'')', 'to_timestamp_tz(''1997 12 +02:00'',''YYYY FF TZR'')', ut_utils.tr_success, 'not_');    
    
  end;  
  
  procedure test_be_greater_or_equal is
  begin
    exec_be_greater_or_equal('date', 'sysdate', 'sysdate-1', ut_utils.tr_success);
    exec_be_greater_or_equal('number', '2.0', '1.99', ut_utils.tr_success);
    exec_be_greater_or_equal('interval year to month', '''2-1''', '''2-0''', ut_utils.tr_success);
    exec_be_greater_or_equal('interval day to second', '''2 01:00:00''', '''2 00:59:59''', ut_utils.tr_success);
    exec_be_greater_or_equal('timestamp', 'to_timestamp(''1997-01 09:26:50.13'',''YYYY-MM HH24.MI.SS.FF'')', 'to_timestamp(''1997-01 09:26:50.12'',''YYYY-MM HH24.MI.SS.FF'')', ut_utils.tr_success);
    exec_be_greater_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success);
    exec_be_greater_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success);

    exec_be_greater_or_equal('date', 'sysdate', 'sysdate', ut_utils.tr_success);
    exec_be_greater_or_equal('number', '1.99', '1.99', ut_utils.tr_success);
    exec_be_greater_or_equal('interval year to month', '''2-0''', '''2-0''', ut_utils.tr_success);
    exec_be_greater_or_equal('INTERVAL DAY TO SECOND', '''2 00:59:01''', '''2 00:59:01''', ut_utils.tr_success);
    exec_be_greater_or_equal('timestamp', 'to_timestamp(''1997 09:26:50.12'',''YYYY HH24.MI.SS.FF'')', 'to_timestamp(''1997 09:26:50.12'',''YYYY HH24.MI.SS.FF'')', ut_utils.tr_success, '');
    exec_be_greater_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', ut_utils.tr_success, '');
    exec_be_greater_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', ut_utils.tr_success, '');

    exec_be_greater_or_equal('date', 'sysdate-1', 'sysdate', ut_utils.tr_failure, '');
    exec_be_greater_or_equal('number', '1.0', '1.01', ut_utils.tr_failure, '');
    exec_be_greater_or_equal('interval year to month', '''2-1''', '''2-2''', ut_utils.tr_failure, '');
    exec_be_greater_or_equal('interval day to second', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_failure, '');
    exec_be_greater_or_equal('timestamp', 'to_timestamp(''1997 09:26:50.12'',''YYYY HH24.MI.SS.FF'')', 'to_timestamp(''1997 09:26:50.13'',''YYYY HH24.MI.SS.FF'')', ut_utils.tr_failure, '');
    exec_be_greater_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_failure, '');
    exec_be_greater_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_failure, '');

    exec_be_greater_or_equal('date', 'sysdate-2', 'sysdate-1', ut_utils.tr_success, 'not_');
    exec_be_greater_or_equal('number', '1.0', '1.99', ut_utils.tr_success, 'not_');
    exec_be_greater_or_equal('interval year to month', '''1-1''', '''2-0''', ut_utils.tr_success, 'not_');
    exec_be_greater_or_equal('interval day to second', '''1 01:00:00''', '''2 00:59:59''', ut_utils.tr_success, 'not_');
    exec_be_greater_or_equal('timestamp', 'to_timestamp(''1997-01 09:26:50.11'',''YYYY-MM HH24.MI.SS.FF'')', 'to_timestamp(''1997-01 09:26:50.12'',''YYYY-MM HH24.MI.SS.FF'')', ut_utils.tr_success, 'not_');
    exec_be_greater_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, 'not_');
    exec_be_greater_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, 'not_');

  end;
  
  procedure test_be_greater_than is
  begin
    
    exec_be_greater_than('date', 'sysdate', 'sysdate-1', ut_utils.tr_success, '');
    exec_be_greater_than('number', '2.0', '1.99', ut_utils.tr_success, '');
    exec_be_greater_than('interval year to month', '''2-1''', '''2-0''', ut_utils.tr_success, '');
    exec_be_greater_than('interval day to second', '''2 01:00:00''', '''2 00:59:59''', ut_utils.tr_success, '');
    exec_be_greater_than('timestamp', 'to_timestamp(''1997 13'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_success, '');
    exec_be_greater_than('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, '');
    exec_be_greater_than('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, '');

    exec_be_greater_than('date', 'sysdate', 'sysdate', ut_utils.tr_failure, '');
    exec_be_greater_than('number', '1.0', '1.0', ut_utils.tr_failure, '');
    exec_be_greater_than('interval year to month', '''2-1''', '''2-1''', ut_utils.tr_failure, '');
    exec_be_greater_than('interval day to second', '''2 00:59:58''', '''2 00:59:58''', ut_utils.tr_failure, '');
    exec_be_greater_than('timestamp', 'to_timestamp(''1997 12'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_failure, '');
    exec_be_greater_than('timestamp with time zone', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997+02:00'',''YYYY TZR'')', ut_utils.tr_failure, '');
    exec_be_greater_than('timestamp with local time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', ut_utils.tr_failure, '');

    exec_be_greater_than('date', 'sysdate-1', 'sysdate-1', ut_utils.tr_success, 'not_');
    exec_be_greater_than('number', '1', '1.99', ut_utils.tr_success, 'not_');
    exec_be_greater_than('interval year to month', '''1-1''', '''2-0''', ut_utils.tr_success, 'not_');
    exec_be_greater_than('interval day to second', '''2 01:00:00''', '''2 01:00:00''', ut_utils.tr_success, 'not_');
    exec_be_greater_than('timestamp', 'to_timestamp(''1997 13'',''YYYY FF'')', 'to_timestamp(''1997 13'',''YYYY FF'')', ut_utils.tr_success, 'not_');
    exec_be_greater_than('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', ut_utils.tr_success, 'not_');
    exec_be_greater_than('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', ut_utils.tr_success, 'not_');    
    
  end;
  
  procedure test_be_less_or_equal is
  begin
    
    exec_be_less_or_equal('date', 'sysdate', 'sysdate-1', ut_utils.tr_failure, '');
    exec_be_less_or_equal('number', '2.0', '1.99', ut_utils.tr_failure, '');
    exec_be_less_or_equal('interval year to month', '''2-1''', '''2-0''', ut_utils.tr_failure, '');
    exec_be_less_or_equal('interval day to second', '''2 01:00:00''', '''2 00:59:59''', ut_utils.tr_failure, '');
    exec_be_less_or_equal('timestamp', 'to_timestamp(''1997 13'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_failure, '');
    exec_be_less_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_failure, '');
    exec_be_less_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_failure, '');

    exec_be_less_or_equal('date', 'sysdate', 'sysdate', ut_utils.tr_success, '');
    exec_be_less_or_equal('number', '1.99', '1.99', ut_utils.tr_success, '');
    exec_be_less_or_equal('interval year to month', '''2-0''', '''2-0''', ut_utils.tr_success, '');
    exec_be_less_or_equal('interval day to second', '''2 00:59:01''', '''2 00:59:01''', ut_utils.tr_success, '');
    exec_be_less_or_equal('timestamp', 'to_timestamp(''1997 12'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_success, '');
    exec_be_less_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', ut_utils.tr_success, '');
    exec_be_less_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', ut_utils.tr_success, '');

    exec_be_less_or_equal('date', 'sysdate-1', 'sysdate', ut_utils.tr_success, '');
    exec_be_less_or_equal('number', '1.0', '1.01', ut_utils.tr_success, '');
    exec_be_less_or_equal('interval year to month', '''2-1''', '''2-2''', ut_utils.tr_success, '');
    exec_be_less_or_equal('interval day to second', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_success, '');
    exec_be_less_or_equal('timestamp', 'to_timestamp(''1997 12'',''YYYY FF'')', 'to_timestamp(''1997 13'',''YYYY FF'')', ut_utils.tr_success, '');
    exec_be_less_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, '');
    exec_be_less_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +03:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, '');

    exec_be_less_or_equal('date', 'sysdate', 'sysdate-1', ut_utils.tr_success, 'not_');
    exec_be_less_or_equal('number', '2.0', '1.99', ut_utils.tr_success, 'not_');
    exec_be_less_or_equal('interval year to month', '''2-1''', '''2-0''', ut_utils.tr_success, 'not_');
    exec_be_less_or_equal('interval day to second', '''2 01:00:00''', '''2 00:59:59''', ut_utils.tr_success, 'not_');
    exec_be_less_or_equal('timestamp', 'to_timestamp(''1997 13'',''YYYY FF'')', 'to_timestamp(''1997 12'',''YYYY FF'')', ut_utils.tr_success, 'not_');
    exec_be_less_or_equal('timestamp with time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, 'not_');
    exec_be_less_or_equal('timestamp with local time zone', 'to_timestamp_tz(''1997 +01:00'',''YYYY TZR'')', 'to_timestamp_tz(''1997 +02:00'',''YYYY TZR'')', ut_utils.tr_success, 'not_');    
    
  end;
  
  procedure test_be_between is
  begin

    exec_be_between('date', 'sysdate', 'sysdate-2', 'sysdate-1', ut_utils.tr_failure);
    exec_be_between('number', '2.0', '1.99', '1.999', ut_utils.tr_failure);
    exec_be_between('varchar2(1)', '''c''', '''a''', '''b''', ut_utils.tr_failure);
    exec_be_between('interval year to month', '''2-2''', '''2-0''', '''2-1''', ut_utils.tr_failure);
    exec_be_between('interval day to second', '''2 01:00:00''', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_failure);
    exec_be_between('timestamp', 'to_timestamp(''1997-01-31 09:26:50.13'',''YYYY-MM-DD HH24.MI.SS.FF'')', 'to_timestamp(''1997-01-31 09:26:50.11'',''YYYY-MM-DD HH24.MI.SS.FF'')', 'to_timestamp(''1997-01-31 09:26:50.12'',''YYYY-MM-DD HH24.MI.SS.FF'')', ut_utils.tr_failure);
    exec_be_between('timestamp with local time zone', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +01:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +02:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +03:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', ut_utils.tr_failure);
    exec_be_between('timestamp with time zone', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +01:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +02:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +03:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', ut_utils.tr_failure);

    exec_be_between('date', 'sysdate', 'sysdate-1', 'sysdate+1', ut_utils.tr_success);
    exec_be_between('number', '2.0', '1.99', '2.01', ut_utils.tr_success);
    exec_be_between('varchar2(1)', '''b''', '''a''', '''c''', ut_utils.tr_success);
    exec_be_between('interval year to month', '''2-1''', '''2-0''', '''2-2''', ut_utils.tr_success);
    exec_be_between('interval day to second', '''2 01:00:00''', '''2 00:59:58''', '''2 01:00:01''', ut_utils.tr_success);
    exec_be_between('timestamp', 'to_timestamp(''1997-01-31 09:26:50.13'',''YYYY-MM-DD HH24.MI.SS.FF'')', 'to_timestamp(''1997-01-31 09:26:50.11'',''YYYY-MM-DD HH24.MI.SS.FF'')', 'to_timestamp(''1997-01-31 09:26:50.14'',''YYYY-MM-DD HH24.MI.SS.FF'')', ut_utils.tr_success);
    exec_be_between('timestamp with local time zone', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +02:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +03:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +01:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', ut_utils.tr_success);
    exec_be_between('timestamp with time zone', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +02:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +03:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', 'to_timestamp_tz(''1997-01-31 09:26:50.12 +01:00'',''YYYY-MM-DD HH24.MI.SS.FF TZR'')', ut_utils.tr_success);
  end;
  
  procedure test_be_between2 is
  begin

    --failure when value out of range
    exec_be_between2('date', 'sysdate', 'sysdate-2', 'sysdate-1', ut_utils.tr_failure, '');
    exec_be_between2('number', '2.0', '1.99', '1.999', ut_utils.tr_failure, '');
    exec_be_between2('varchar2(1)', '''c''', '''a''', '''b''', ut_utils.tr_failure, '');
    exec_be_between2('timestamp', 'systimestamp+1', 'systimestamp-1', 'systimestamp', ut_utils.tr_failure, '');
    exec_be_between2('timestamp with local time zone', 'systimestamp+1', 'systimestamp-1', 'systimestamp', ut_utils.tr_failure, '');
    exec_be_between2('timestamp with time zone', 'systimestamp+1', 'systimestamp-1', 'systimestamp', ut_utils.tr_failure, '');
    exec_be_between2('interval year to month', '''2-2''', '''2-0''', '''2-1''', ut_utils.tr_failure, '');
    exec_be_between2('interval day to second', '''2 01:00:00''', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_failure, '');

    --success when value in range
    exec_be_between2('date', 'sysdate', 'sysdate-1', 'sysdate+1', ut_utils.tr_success, '');
    exec_be_between2('number', '2.0', '1.99', '2.01', ut_utils.tr_success, '');
    exec_be_between2('varchar2(1)', '''b''', '''a''', '''c''', ut_utils.tr_success, '');
    exec_be_between2('timestamp', 'systimestamp', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_success, '');
    exec_be_between2('timestamp with local time zone', 'systimestamp', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_success, '');
    exec_be_between2('timestamp with time zone', 'systimestamp', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_success, '');
    exec_be_between2('interval year to month', '''2-1''', '''2-0''', '''2-2''', ut_utils.tr_success, '');
    exec_be_between2('interval day to second', '''2 01:00:00''', '''2 00:59:58''', '''2 01:00:01''', ut_utils.tr_success, '');

    --success when value not in range
    exec_be_between2('date', 'sysdate', 'sysdate-2', 'sysdate-1', ut_utils.tr_success, 'not_');
    exec_be_between2('number', '2.0', '1.99', '1.999', ut_utils.tr_success, 'not_');
    exec_be_between2('varchar2(1)', '''c''', '''a''', '''b''', ut_utils.tr_success, 'not_');
    exec_be_between2('timestamp', 'systimestamp+1', 'systimestamp-1', 'systimestamp', ut_utils.tr_success, 'not_');
    exec_be_between2('timestamp with local time zone', 'systimestamp+1', 'systimestamp-1', 'systimestamp', ut_utils.tr_success, 'not_');
    exec_be_between2('timestamp with time zone', 'systimestamp+1', 'systimestamp-1', 'systimestamp', ut_utils.tr_success, 'not_');
    exec_be_between2('interval year to month', '''2-2''', '''2-0''', '''2-1''', ut_utils.tr_success, 'not_');
    exec_be_between2('interval day to second', '''2 01:00:00''', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_success, 'not_');

    --failure when value not out of range
    exec_be_between2('date', 'sysdate', 'sysdate-1', 'sysdate+1', ut_utils.tr_failure, 'not_');
    exec_be_between2('number', '2.0', '1.99', '2.01', ut_utils.tr_failure, 'not_');
    exec_be_between2('varchar2(1)', '''b''', '''a''', '''c''', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp', 'systimestamp', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp with local time zone', 'systimestamp', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp with time zone', 'systimestamp', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_failure, 'not_');
    exec_be_between2('interval year to month', '''2-1''', '''2-0''', '''2-2''', ut_utils.tr_failure, 'not_');
    exec_be_between2('interval day to second', '''2 01:00:00''', '''2 00:59:58''', '''2 01:00:01''', ut_utils.tr_failure, 'not_');

    --failure when value is null
    exec_be_between2('date', 'null', 'sysdate-1', 'sysdate+1', ut_utils.tr_failure, '');
    exec_be_between2('number', 'null', '1.99', '2.01', ut_utils.tr_failure, '');
    exec_be_between2('varchar2(1)', 'null', '''a''', '''c''', ut_utils.tr_failure, '');
    exec_be_between2('timestamp', 'null', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_failure, '');
    exec_be_between2('timestamp with local time zone', 'null', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_failure, '');
    exec_be_between2('timestamp with time zone', 'null', 'systimestamp-1', 'systimestamp+1', ut_utils.tr_failure, '');
    exec_be_between2('interval year to month', 'null', '''2-0''', '''2-2''', ut_utils.tr_failure, '');
    exec_be_between2('interval day to second', 'null', '''2 00:59:58''', '''2 01:00:01''', ut_utils.tr_failure, '');
    exec_be_between2('date', 'null', 'sysdate-2', 'sysdate-1', ut_utils.tr_failure, 'not_');
    exec_be_between2('number', 'null', '1.99', '1.999', ut_utils.tr_failure, 'not_');
    exec_be_between2('varchar2(1)', 'null', '''a''', '''b''', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp', 'null', 'systimestamp-1', 'systimestamp', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp with local time zone', 'null', 'systimestamp-1', 'systimestamp', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp with time zone', 'null', 'systimestamp-1', 'systimestamp', ut_utils.tr_failure, 'not_');
    exec_be_between2('interval year to month', 'null', '''2-0''', '''2-1''', ut_utils.tr_failure, 'not_');
    exec_be_between2('interval day to second', 'null', '''2 00:59:58''', '''2 00:59:59''', ut_utils.tr_failure, 'not_');

    --failure when lower bound is null
    exec_be_between2('date', 'sysdate', 'null', 'sysdate+1', ut_utils.tr_failure, '');
    exec_be_between2('number', '2.0', 'null', '2.01', ut_utils.tr_failure, '');
    exec_be_between2('varchar2(1)', '''b''', 'null', '''c''', ut_utils.tr_failure, '');
    exec_be_between2('timestamp', 'systimestamp', 'null', 'systimestamp+1', ut_utils.tr_failure, '');
    exec_be_between2('timestamp with local time zone', 'systimestamp', 'null', 'systimestamp+1', ut_utils.tr_failure, '');
    exec_be_between2('timestamp with time zone', 'systimestamp', 'null', 'systimestamp+1', ut_utils.tr_failure, '');
    exec_be_between2('interval year to month', '''2-1''', 'null', '''2-2''', ut_utils.tr_failure, '');
    exec_be_between2('interval day to second', '''2 01:00:00''', 'null', '''2 01:00:01''', ut_utils.tr_failure, '');
    exec_be_between2('date', 'sysdate', 'null', 'sysdate-1', ut_utils.tr_failure, 'not_');
    exec_be_between2('number', '2.0', 'null', '1.999', ut_utils.tr_failure, 'not_');
    exec_be_between2('varchar2(1)', '''b''', 'null', '''b''', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp', 'systimestamp+1', 'null', 'systimestamp', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp with local time zone', 'systimestamp+1', 'null', 'systimestamp', ut_utils.tr_failure, 'not_');
    exec_be_between2('timestamp with time zone', 'systimestamp+1', 'null', 'systimestamp', ut_utils.tr_failure, 'not_');
    exec_be_between2('interval year to month', '''2-2''', 'null', '''2-1''', ut_utils.tr_failure, 'not_');
    exec_be_between2('interval day to second', '''2 01:00:00''', 'null', '''2 00:59:59''', ut_utils.tr_failure, 'not_');
  end;
  
  procedure test_match is
  begin
    exec_match('varchar2(100)', '''Stephen''', '^Ste(v|ph)en$', '', ut_utils.tr_success, '');
    exec_match('varchar2(100)', '''sTEPHEN''', '^Ste(v|ph)en$', 'i', ut_utils.tr_success, '');
    exec_match('clob', 'rpad('', '',32767)||''Stephen''', 'Ste(v|ph)en$', '', ut_utils.tr_success, '');
    exec_match('clob', 'rpad('', '',32767)||''sTEPHEN''', 'Ste(v|ph)en$', 'i', ut_utils.tr_success, '');

    exec_match('varchar2(100)', '''Stephen''', '^Steven$', '', ut_utils.tr_failure, '');
    exec_match('varchar2(100)', '''sTEPHEN''', '^Steven$', 'i', ut_utils.tr_failure, '');
    exec_match('clob', 'to_clob(rpad('', '',32767)||''Stephen'')', '^Stephen', '', ut_utils.tr_failure, '');
    exec_match('clob', 'to_clob(rpad('', '',32767)||''sTEPHEN'')', '^Stephen', 'i', ut_utils.tr_failure, '');

    exec_match('varchar2(100)', '''Stephen''', '^Ste(v|ph)en$', '', ut_utils.tr_failure, 'not_');
    exec_match('varchar2(100)', '''sTEPHEN''', '^Ste(v|ph)en$', 'i', ut_utils.tr_failure, 'not_');
    exec_match('clob', 'rpad('', '',32767)||''Stephen''', 'Ste(v|ph)en$', '', ut_utils.tr_failure, 'not_');
    exec_match('clob', 'rpad('', '',32767)||''sTEPHEN''', 'Ste(v|ph)en$', 'i', ut_utils.tr_failure, 'not_');

    exec_match('varchar2(100)', '''Stephen''', '^Steven$', '', ut_utils.tr_success, 'not_');
    exec_match('varchar2(100)', '''sTEPHEN''', '^Steven$', 'i', ut_utils.tr_success, 'not_');
    exec_match('clob', 'to_clob(rpad('', '',32767)||''Stephen'')', '^Stephen', '', ut_utils.tr_success, 'not_');
    exec_match('clob', 'to_clob(rpad('', '',32767)||''sTEPHEN'')', '^Stephen', 'i', ut_utils.tr_success, 'not_');
  end;
  
  procedure test_be_empty_cursor is
    l_cursor sys_refcursor;
    l_result         integer;
  begin
    open l_cursor for select * from dual where 1 = 1;
    ut.expect(l_cursor).to_(be_empty);
    close l_cursor;
    l_result := ut_expectation_processor.get_status;
    ut_expectation_processor.clear_expectations;
    
    ut.expect(l_result).to_equal(ut_utils.tr_failure);
    
    open l_cursor for select * from dual where 1 != 1;
    ut.expect(l_cursor).to_(be_empty);
    close l_cursor;
  end;
  
  procedure test_be_nonempty_cursor is
    l_cursor sys_refcursor;
    l_result         integer;
  begin
    open l_cursor for select * from dual where 1 != 1;
    ut.expect(l_cursor).not_to(be_empty);
    close l_cursor;
    l_result := ut_expectation_processor.get_status;
    ut_expectation_processor.clear_expectations;
    
    ut.expect(l_result).to_equal(ut_utils.tr_failure);
    
    open l_cursor for select * from dual where 1 = 1;
    ut.expect(l_cursor).not_to(be_empty);
    close l_cursor;
  end;
  
  procedure test_be_empty_collection is
    l_result         integer;
  begin
    ut.expect(anydata.convertcollection(ora_mining_varchar2_nt('a'))).to_(be_empty());
    l_result := ut_expectation_processor.get_status;
    ut_expectation_processor.clear_expectations;
    
    ut.expect(l_result).to_equal(ut_utils.tr_failure);
    
    ut.expect(anydata.convertcollection(ora_mining_varchar2_nt())).to_(be_empty());
  end;
  
  procedure test_be_nonempty_collection is
    l_result         integer;
  begin
    ut.expect(anydata.convertcollection(ora_mining_varchar2_nt())).not_to(be_empty());
    l_result := ut_expectation_processor.get_status;
    ut_expectation_processor.clear_expectations;
    
    ut.expect(l_result).to_equal(ut_utils.tr_failure);
    
    ut.expect(anydata.convertcollection(ora_mining_varchar2_nt('a'))).not_to(be_empty());
  end;
  
  procedure test_be_empty_others is
  begin
    ut.expect(anydata.ConvertObject(ut_data_value_number(1))).not_to(be_empty());
    ut.expect(anydata.ConvertObject(cast(null as ut_data_value_number))).to_(be_empty());
  end;

end test_matchers;
/
