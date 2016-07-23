create or replace type body ut_dbms_output_suite_reporter is

  static function c_dashed_line return varchar2 is
  begin
    return lpad('-',80,'-');
  end;

  constructor function ut_dbms_output_suite_reporter return self as result is
  begin
    self.name := $$plsql_unit;
    return;
  end;

  member procedure print(msg varchar2) is
  begin
    dbms_output.put_line(msg);
  end print;

  overriding member procedure begin_suite(self in out nocopy ut_dbms_output_suite_reporter, a_suite_name in varchar2) as
  begin
    print(ut_dbms_output_suite_reporter.c_dashed_line);
    print('suite "' || a_suite_name || '" started.');
  end;

  overriding member procedure begin_test(self in out nocopy ut_dbms_output_suite_reporter, a_test_name in varchar2, a_test_call_params in ut_test_call_params) as
  begin
    print(ut_dbms_output_suite_reporter.c_dashed_line);
    print('test  ' || a_test_name || ' (' ||
            ut_metadata.form_name(a_test_call_params.owner_name
                                 ,a_test_call_params.object_name
                                 ,a_test_call_params.test_procedure
            ) || ')'
         );
    print('asserts:');
  end;

  overriding member procedure begin_assert(self in out nocopy ut_dbms_output_suite_reporter, an_assert_message in varchar2) as
  begin
    null;
  end;

  overriding member procedure end_assert(self in out nocopy ut_dbms_output_suite_reporter, an_assert ut_assert_result)as
  begin
      print(result_to_char( an_assert.result ) ||
            ', ' ||an_assert.message ||
            ', expected: ' || an_assert.expected ||
            ', actual: ' || an_assert.actual
           );
  end;

  overriding member procedure end_test(self in out nocopy ut_dbms_output_suite_reporter, a_test_name in varchar2, a_test_call_params in ut_test_call_params, a_execution_result in ut_execution_result) as
  begin
    print('test  result: ' || result_to_char(a_execution_result.result) );
  end;

  overriding member procedure end_suite(self in out nocopy ut_dbms_output_suite_reporter, a_suite_name in varchar2, a_suite_execution_result in ut_execution_result) as
  begin
    --todo: report total suite result here with pretty message
    print(ut_dbms_output_suite_reporter.c_dashed_line);
    print('suite "' || a_suite_name || '" ended.');
    print(ut_dbms_output_suite_reporter.c_dashed_line);
  end;

  overriding member function result_to_char(a_result integer) return varchar2 is
  begin
    return case a_result
             when ut_utils.tr_success then ut_utils.tr_success_char
             when ut_utils.tr_failure then ut_utils.tr_failure_char
             when ut_utils.tr_error   then ut_utils.tr_error_char
             else 'Unknown(' || coalesce(a_result,'NULL') || ')'
           end;
  end result_to_char;

end;
/
