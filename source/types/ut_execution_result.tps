create or replace type ut_execution_result under ut_execution_result_base
(
  executions           ut_execution_list,
  constructor function ut_execution_result(a_start_time timestamp with time zone default current_timestamp) return self as result,
  member procedure add_execution( self in out nocopy ut_execution_result, an_execution ut_execution_result_base )
)
not final
/
