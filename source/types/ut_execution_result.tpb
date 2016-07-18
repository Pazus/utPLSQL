create or replace type body ut_execution_result is

  constructor function ut_execution_result(a_test ut_single_test, a_start_time timestamp with time zone default current_timestamp)
    return self as result is
  begin
    self.test       := a_test;
    self.start_time := a_start_time;
    return;
  end ut_execution_result;

  member function result_to_char(self in ut_execution_result) return varchar2 is
  begin
    return ut_types.test_result_to_char(self.result);
  end result_to_char;

end;
/
