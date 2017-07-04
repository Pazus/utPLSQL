create or replace package test_ut_reporters is

  --%suite
  --%suitepath(ut_plsql.reporters)
  
  --%beforeall
  procedure setup_all;
  
  --%afterall
  procedure drop_all;
  
  --%test(ut_coverage_sonar_reporter Accepts File Mapping)
  procedure test_coverage_sonar_1;
  
  --%test(ut_coverage_sonar_reporter Builds Sonar Coverage Report)
  procedure test_coverage_sonar_2;
  
  --%test(ut_documentation_reporter provides Correct Line From Stacktrace)
  procedure test_docum_stack_corr_line;
  
  --%test(ut_html_reporter Default Schema Coverage)
  procedure test_html_rep_schema_cov;
  
  --%test(ut_html_reporter User Override Schema Coverage)
  procedure test_html_rep_other_user;  
  
  --%test(ut_sonar_test_reporter Accepts File Mapping)
  procedure test_sonar_file_mapping;
  
  --%test(ut_sonar_test_reporter Produces Expected Outputs)
  procedure test_sonar_1;
  
  --%test(ut_teamcity_reporter Produces Expected Outputs)
  procedure test_teamcity_reporter_1;
  
  --%test(ut_xunit_reporter Produces Expected Outputs)
  procedure test_xunit_reporter_1;
  
  --%test(ut_documentation_reporter report Multiple Warnings)
  --%beforetest(setup_docum_multi_warn)
  --%aftertest(clean_docum_multi_warn)
  procedure test_docum_multi_warn;  
  procedure setup_docum_multi_warn;
  procedure clean_docum_multi_warn;
  
  --%test(ut_documentation_reporter report Test Timing)
  --%beforetest(setup_docum_timings)
  --%aftertest(clean_docum_timings)
  procedure test_docum_timings;  
  procedure setup_docum_timings;
  procedure clean_docum_timings;
  
  --%test(ut_xunit_reporter Report On Suite Without Desc)
  --%beforetest(setup_xunit_nodesc_suite)
  --%aftertest(clean_xunit_nodesc_suite)
  procedure test_xunit_nodesc_suite;
  procedure setup_xunit_nodesc_suite;
  procedure clean_xunit_nodesc_suite;
  
  --%test(ut_xunit_reporter Report On Test Without Desc)
  --%beforetest(setup_xunit_nodesc_test)
  --%aftertest(clean_xunit_nodesc_test)
  procedure test_xunit_nodesc_test;
  procedure setup_xunit_nodesc_test;
  procedure clean_xunit_nodesc_test;

end test_ut_reporters;
/
create or replace package body test_ut_reporters is

  ex_insuffisient_privs exception;
  ex_user_doesnt_exist exception;
  ex_package_doesnt_exist exception;
  pragma exception_init(ex_insuffisient_privs, -1031);
  pragma exception_init(ex_user_doesnt_exist, -1435);
  pragma exception_init(ex_package_doesnt_exist, -4043);
  

  procedure setup_all is
    pragma autonomous_transaction;
  begin
    execute immediate q'[create or replace package test_reporters
as
  --%suite(A suite for testing different outcomes from reporters)

  --%beforeall
  procedure beforeall;

  --%beforeeach
  procedure beforeeach;

  --%test
  --%beforetest(beforetest)
  --%aftertest(aftertest)
  procedure passing_test;

  procedure beforetest;

  procedure aftertest;

  --%test(a test with failing assertion)
  procedure failing_test;

  --%test(a test raising unhandled exception)
  procedure erroring_test;

  --%test(a disabled test)
  --%disabled
  procedure disabled_test;

  --%aftereach
  procedure aftereach;

  --%afterall
  procedure afterall;

end;]';

    execute immediate 'create or replace package body test_reporters
as

  procedure beforetest is
  begin
    dbms_output.put_line(''<!beforetest!>'');
  end;

  procedure aftertest
  is
  begin
    dbms_output.put_line(''<!aftertest!>'');
  end;

  procedure beforeeach is
  begin
    dbms_output.put_line(''<!beforeeach!>'');
  end;

  procedure aftereach is
  begin
    dbms_output.put_line(''<!aftereach!>'');
  end;

  procedure passing_test
  is
  begin
    dbms_output.put_line(''<!passing test!>'');
    ut.expect(1,''Test 1 Should Pass'').to_equal(1);
  end;

  procedure failing_test
  is
  begin
    dbms_output.put_line(''<!failing test!>'');
    ut.expect(1,''Fails as values are different'').to_equal(2);
  end;

  procedure erroring_test
  is
    l_variable integer;
  begin
    dbms_output.put_line(''<!erroring test!>'');
    l_variable := ''a string'';
    ut.expect(l_variable).to_equal(1);
  end;

  procedure disabled_test
  is
  begin
    dbms_output.put_line(''<!this should not execute!>'');
    ut.expect(1,''this should not execute'').to_equal(1);
  end;

  procedure beforeall is
  begin
    dbms_output.put_line(''<!beforeall!>'');
  end;

  procedure afterall is
  begin
    dbms_output.put_line(''<!afterall!>'');
  end;

end;';

    begin
      execute immediate 'CREATE OR REPLACE PACKAGE ut3$user#.html_coverage_test IS

   -- Author  : LUW07
   -- Created : 23/05/2017 09:37:29
   -- Purpose : Supporting html coverage procedure

   -- Public type declarations
   PROCEDURE run_if_statment(o_result OUT NUMBER);
END HTML_COVERAGE_TEST;';
      execute immediate 'CREATE OR REPLACE PACKAGE BODY ut3$user#.html_coverage_test IS

   -- Private type declarations
   PROCEDURE run_if_statment(o_result OUT NUMBER) IS
      l_testedvalue NUMBER := 1;
      l_success     NUMBER := 0;
   BEGIN
      IF l_testedvalue = 1 THEN
         l_success := 1;
      END IF;
      
      o_result := l_success;
   END run_if_statment;
END HTML_COVERAGE_TEST;';
    exception 
      when ex_user_doesnt_exist then
        dbms_output.put_line('Check ut3$user# is created and '||user||' have create any procedure privilage');
    end;

    execute immediate 'create or replace package test_reporters_1
as
  --%suite(A suite for testing html coverage options)
  
  --%test(a test calling package outside schema)
  procedure diffrentowner_test;

end;';

    execute immediate 'create or replace package body test_reporters_1
as
  procedure diffrentowner_test
  is
    l_result number;
  begin
    ut3$user#.html_coverage_test.run_if_statment(l_result);
    ut.expect(l_result).to_equal(1);
  end;
end;';


  end;
  
  procedure drop_all is
    pragma autonomous_transaction;
  begin
    begin
      execute immediate 'drop package test_reporters';
    exception
      when ex_package_doesnt_exist then
        null;
    end;
    begin
      execute immediate 'drop package test_reporters_1';
    exception
      when ex_package_doesnt_exist then
        null;
    end;
    begin
      execute immediate 'drop package ut3$user#.html_coverage_test';
    exception
      when ex_package_doesnt_exist or ex_insuffisient_privs then
        null;
    end;
  end;

  procedure restore_asserts(a_assert_results ut_expectation_results) is
  begin
    ut_expectation_processor.clear_expectations;
  
    if a_assert_results is not null then
      for i in 1 .. a_assert_results.count loop
        ut_expectation_processor.add_expectation_result(a_assert_results(i));
      end loop;
    end if;
  end;

  procedure test_coverage_sonar_1 is
    l_results ut_varchar2_list;
    l_clob    clob;
    l_expected varchar2(32767);
  begin
    l_expected := '<coverage version="1">%</coverage>';
    select *
    bulk collect into l_results
    from table(
      ut.run(
        'test_reporters',
        ut_coverage_sonar_reporter(),
        a_source_file_mappings => ut_file_mapper.build_file_mappings( user, ut_varchar2_list(
          'tests/helpers/test_reporters.pkb' )
        )
      )
    );
    l_clob := ut_utils.table_to_clob(l_results);
    
    ut.expect(l_clob).to_be_like(l_expected);
  end;
  
  procedure test_coverage_sonar_2 is
    l_results ut_varchar2_list;
    l_clob    clob;
    l_expected varchar2(32767);
  begin
    l_expected := '<coverage version="1">%</coverage>';
    select *
      bulk collect into l_results
      from table(ut.run('test_reporters',ut_coverage_sonar_reporter(), a_include_objects => ut_varchar2_list('test_reporters')));
    l_clob := ut_utils.table_to_clob(l_results);

     ut.expect(l_clob).to_be_like(l_expected);
  end;
  
  procedure test_docum_stack_corr_line is
    l_output_data       ut_varchar2_list;
    l_output            varchar2(32767);
    l_expected          varchar2(32767);
  begin
    l_expected := q'[%
%Failures:%
%1)%failing_test%
%"Fails as values are different"%
%Actual: 1 (number) was expected to equal: 2 (number)%
%at "%.TEST_REPORTERS%", line%
%2)%erroring_test%
%ORA-06502%
%ORA-06512%
Finished %
4 tests, 1 failed, 1 errored%]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('test_reporters',ut_documentation_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);

    --assert
    ut.expect(l_output).to_be_like(l_expected);
  end;
  
  procedure test_html_rep_schema_cov is
    l_results  ut_varchar2_list;
    l_clob     clob;
    l_expected varchar2(32767);
  begin
    l_expected := '%<h3>UT3.TEST_REPORTERS_1</h3>%';
    select * bulk collect into l_results from table(ut.run('test_reporters_1', ut_coverage_html_reporter()));
    /*
    for i in 1..l_results.count loop
      dbms_output.put_line(l_results(i));
    end loop;*/
    
    l_clob := ut3.ut_utils.table_to_clob(l_results);

    ut.expect(l_clob).to_be_like(l_expected);
  end;
  
  procedure test_html_rep_other_user is
   l_results  ut_varchar2_list;
   l_clob     CLOB;
   l_expected VARCHAR2(32767);
  BEGIN
   l_expected := '%<h3>UT3$USER#.HTML_COVERAGE_TEST</h3>%';
   SELECT * BULK COLLECT
   INTO   l_results
   FROM   TABLE(ut.run('test_reporters_1', ut_coverage_html_reporter(),
                       a_coverage_schemes => ut_varchar2_list('ut3$user#')));
   l_clob := ut3.ut_utils.table_to_clob(l_results);

    ut.expect(l_clob).to_be_like(l_expected);
  end;
  
  procedure test_sonar_file_mapping is
    l_output_data       ut_varchar2_list;
    l_output            clob;
    l_expected          varchar2(32767);
  begin
    l_expected := q'[<testExecutions version="1">
<file path="tests/helpers/test_reporters.pkb">
<testCase name="passing_test" duration="%" >%</testCase>
<testCase name="failing_test" duration="%" >%<failure message="some expectations have failed">%</failure>%</testCase>
<testCase name="erroring_test" duration="%" >%<error message="encountered errors">%</error>%</testCase>
<testCase name="disabled_test" duration="0" >%<skipped message="skipped"/>%</testCase>
</file>
</testExecutions>]';

    --act
    select *
    bulk collect into l_output_data
    from table(
      ut.run(
        'test_reporters',
        ut_sonar_test_reporter(),
        a_test_file_mappings => ut_file_mapper.build_file_mappings( user, ut_varchar2_list('tests/helpers/test_reporters.pkb'))
      )
    );

    l_output := ut_utils.table_to_clob(l_output_data);
    ut.expect(l_output).to_be_like(l_expected);
  end;
  
  procedure test_sonar_1 is
    l_output_data       ut_varchar2_list;
    l_output            clob;
    l_expected          varchar2(32767);
  begin
    l_expected := q'[<testExecutions version="1">
<file path="tests/helpers/test_reporters.pkb">
<testCase name="passing_test" duration="%" >%</testCase>
<testCase name="failing_test" duration="%" >%<failure message="some expectations have failed">%</failure>%</testCase>
<testCase name="erroring_test" duration="%" >%<error message="encountered errors">%</error>%</testCase>
<testCase name="disabled_test" duration="0" >%<skipped message="skipped"/>%</testCase>
</file>
</testExecutions>]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('test_reporters',ut_sonar_test_reporter(),a_source_files=> null, a_test_files=>ut_varchar2_list('tests/helpers/test_reporters.pkb')));

    l_output := ut_utils.table_to_clob(l_output_data);
    ut.expect(l_output).to_be_like(l_expected);
  end;
  
  procedure test_teamcity_reporter_1 is
    l_output_data       ut_varchar2_list;
    l_output            clob;
    l_expected          varchar2(32767);
  begin
    l_expected := q'{##teamcity[testSuiteStarted timestamp='%' name='A suite for testing different outcomes from reporters']
%##teamcity[testStarted timestamp='%' captureStandardOutput='true' name='ut3.test_reporters.passing_test']
<!beforeeach!>
<!beforetest!>
<!passing test!>
<!aftertest!>
<!aftereach!>
%##teamcity[testFinished timestamp='%' duration='%' name='ut3.test_reporters.passing_test']
%##teamcity[testStarted timestamp='%' captureStandardOutput='true' name='ut3.test_reporters.failing_test']
<!beforeeach!>
<!failing test!>
<!aftereach!>
%##teamcity[testFailed timestamp='%' message='Fails as values are different' name='ut3.test_reporters.failing_test']
%##teamcity[testFinished timestamp='%' duration='%' name='ut3.test_reporters.failing_test']
%##teamcity[testStarted timestamp='%' captureStandardOutput='true' name='ut3.test_reporters.erroring_test']
<!beforeeach!>
<!erroring test!>
<!aftereach!>
%##teamcity[testStdErr timestamp='%' name='ut3.test_reporters.erroring_test' out='Test exception:|rORA-06512: at |"UT3.TEST_REPORTERS|", line %|rORA-06512: at %|r|r']
%##teamcity[testFailed timestamp='%' details='Test exception:|rORA-06512: at |"UT3.TEST_REPORTERS|", line %|rORA-06512: at %|r|r' message='Error occured' name='ut3.test_reporters.erroring_test']
%##teamcity[testFinished timestamp='%' duration='%' name='ut3.test_reporters.erroring_test']
%##teamcity[testStarted timestamp='%' captureStandardOutput='true' name='ut3.test_reporters.disabled_test']
%##teamcity[testIgnored timestamp='%' name='ut3.test_reporters.disabled_test']
%##teamcity[testSuiteFinished timestamp='%' name='A suite for testing different outcomes from reporters']}';
    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('test_reporters',ut_teamcity_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);
    ut.expect(l_output).to_be_like(l_expected);
  end;
  
  procedure test_xunit_reporter_1 is
    l_output_data       ut_varchar2_list;
    l_output            clob;
    l_expected          varchar2(32767);
  begin
    l_expected := q'[<testsuites tests="4" skipped="1" error="1" failure="1" name="%" time="%" >
<testsuite tests="4" id="1" package="test_reporters"  skipped="1" error="1" failure="1" name="%" time="%" >
<system-out>%<!beforeall!>%<!afterall!>%</system-out>
<testcase classname="test_reporters"  assertions="1" skipped="0" error="0" failure="0" name="%" time="%" >
<system-out>%<!beforeeach!>%<!beforetest!>%<!passing test!>%<!aftertest!>%<!aftereach!>%</system-out>
</testcase>
<testcase classname="test_reporters"  assertions="1" skipped="0" error="0" failure="1" name="%" time="%"  status="Failure">
<failure>%"Fails as values are different"
Actual: 1 (number) was expected to equal: 2 (number)%</failure>
<system-out>%</system-out>
</testcase>
<testcase classname="test_reporters"  assertions="0" skipped="0" error="1" failure="0" name="%" time="%"  status="Error">
<error>%ORA-06502:%</error>
<system-out>%</system-out>
</testcase>
<testcase classname="test_reporters"  assertions="0" skipped="1" error="0" failure="0" name="%" time="0"  status="Disabled">
<skipped/>
</testcase>
</testsuite>
</testsuites>]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('test_reporters',ut_xunit_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);
    ut.expect(l_output).to_be_like(l_expected);
  end;
  
  procedure test_docum_multi_warn is
    l_test_report ut_varchar2_list;
    l_output_data       ut_varchar2_list;
    l_output            varchar2(32767);
    l_expected          varchar2(32767);
  begin
    l_expected := q'[%Warnings:
%1)%tst_documrep_mult_warn%
%2)%tst_documrep_mult_warn%]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run(ut_varchar2_list('tst_documrep_mult_warn','tst_documrep_mult_warn2'),ut_documentation_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);

    --assert
    ut.expect(l_output).to_be_like(l_expected);
  end;
  
  procedure setup_docum_multi_warn is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package tst_documrep_mult_warn as
    --%suite

    --%test
    procedure test1;
  end;';
    execute immediate 'create or replace package body tst_documrep_mult_warn as
    procedure test1 is begin commit; end;
  end;';
    execute immediate 'create or replace package tst_documrep_mult_warn2 as
    --%suite

    --%test
    procedure test1;
  end;';

    execute immediate 'create or replace package body tst_documrep_mult_warn2 as
    procedure test1 is begin commit; end;
  end;';
  end;
  procedure clean_docum_multi_warn is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package tst_documrep_mult_warn';
    execute immediate 'drop package tst_documrep_mult_warn2';
  end;
  
  procedure test_docum_timings is
    l_test_report ut_varchar2_list;
    l_output_data       ut_varchar2_list;
    l_output            varchar2(32767);
    l_expected          varchar2(32767);
  begin
    l_expected := q'[tst_doc_reporter_timing
%test1 [%sec]
%test2 [%sec] (FAILED - 1)
%Failures:%
Finished in % seconds
2 tests, 1 failed, 0 errored, 0 disabled, 0 warning(s)%]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('tst_doc_reporter_timing',ut_documentation_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);

    --assert
    ut.expect(l_output).to_be_like(l_expected);
  end;
  procedure setup_docum_timings is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package tst_doc_reporter_timing as
  --%suite

  --%test
  procedure test1;
  
  --%test
  procedure test2;
end;';

    execute immediate 'create or replace package body tst_doc_reporter_timing as
  procedure test1 is begin ut.expect(1).to_equal(1); end;
  procedure test2 is begin ut.expect(1).to_equal(2); end;
end;';

  end;
  procedure clean_docum_timings is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package tst_doc_reporter_timing';
  end;
  
  procedure test_xunit_nodesc_suite is
    l_test_report ut_varchar2_list;
    l_output_data       ut_varchar2_list;
    l_output            clob;
    l_expected          varchar2(32767);
  begin
    l_expected := q'[<testsuites tests="1" skipped="0" error="0" failure="0" name="" time="%" >
<testsuite tests="1" id="1" package="tst_package_xunit_nodesc"  skipped="0" error="0" failure="0" name="tst_package_xunit_nodesc" time="%" >
<testcase classname="tst_package_xunit_nodesc"  assertions="1" skipped="0" error="0" failure="0" name="Test name" time="%" >
</testcase>
</testsuite>
</testsuites>]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('tst_package_xunit_nodesc',ut_xunit_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);
    --assert
    ut.expect(l_output).to_be_like(l_expected);
  end;
  procedure setup_xunit_nodesc_suite is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package tst_package_xunit_nodesc as
  --%suite

  --%test(Test name)
  procedure test1;
end;';

execute immediate 'create or replace package body tst_package_xunit_nodesc as
  procedure test1 is begin ut.expect(1).to_equal(1); end;
  procedure test2 is begin ut.expect(1).to_equal(1); end;
end;';
  end;
  procedure clean_xunit_nodesc_suite is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package tst_package_xunit_nodesc';
  end;
  
  
  procedure test_xunit_nodesc_test is
    l_test_report ut_varchar2_list;
    l_output_data       ut_varchar2_list;
    l_output            varchar2(32767);
    l_expected          varchar2(32767);
  begin
    l_expected := q'[<testsuites tests="2" skipped="0" error="0" failure="0" name="" time="%" >
<testsuite tests="2" id="1" package="tst_package_xunit_nodesc"  skipped="0" error="0" failure="0" name="Suite name" time="%" >
<testcase classname="tst_package_xunit_nodesc"  assertions="1" skipped="0" error="0" failure="0" name="test1" time="%" >
</testcase>
<testcase classname="tst_package_xunit_nodesc"  assertions="1" skipped="0" error="0" failure="0" name="Test name" time="%" >
</testcase>
</testsuite>
</testsuites>]';

    --act
    select *
    bulk collect into l_output_data
    from table(ut.run('tst_package_xunit_nodesc',ut_xunit_reporter()));

    l_output := ut_utils.table_to_clob(l_output_data);

    --assert
    ut.expect(l_output).to_be_like(l_expected);
  end;
  procedure setup_xunit_nodesc_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'create or replace package tst_package_xunit_nodesc as
  --%suite(Suite name)

  --%test
  procedure test1;
  
  --%test(Test name)
  procedure test2;  
end;';

    execute immediate 'create or replace package body tst_package_xunit_nodesc as
  procedure test1 is begin ut.expect(1).to_equal(1); end;
  procedure test2 is begin ut.expect(1).to_equal(1); end;
end;';
  end;
  procedure clean_xunit_nodesc_test is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package tst_package_xunit_nodesc';
  end;

  
end test_ut_reporters;
/
