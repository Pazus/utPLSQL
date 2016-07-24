create or replace type body ut_execution_result is

  constructor function ut_execution_result(a_start_time timestamp with time zone default current_timestamp)
    return self as result is
  begin
    self.start_time := a_start_time;
    self.result := ut_utils.tr_success;
    executions := ut_execution_list();
    return;
  end ut_execution_result;

  member procedure add_execution( self in out nocopy ut_execution_result, an_execution ut_execution_result_base ) is
  begin
    executions.extend;
    executions(executions.last) := an_execution;
    self.result := greatest(an_execution.result, self.result);
  end;

end;
/
