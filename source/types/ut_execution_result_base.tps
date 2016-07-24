create or replace type ut_execution_result_base as object
(
  name          varchar2(4000 char),
  result        integer(1),
  error_message varchar2(4000 char),
  start_time    timestamp with time zone,
  end_time      timestamp with time zone
)
not final not instantiable
/
