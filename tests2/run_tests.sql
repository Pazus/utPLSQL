prompt Installing test packages

set trimspool on
set echo off
set feedback off
set verify off
set linesize 32767
set pagesize 0
set long 200000000
set longchunksize 1000000
set serveroutput on size unlimited format truncated

@@test_annotations.pck

var l_result number;
declare 
  l_run ut_run;
  l_reporter ut_documentation_reporter := ut_documentation_reporter();
begin 
  l_run := ut_runner.run(ut_varchar2_list(user||'.test_annotations'), ut_reporters(l_reporter));
  ut_output_buffer.lines_to_dbms_output(l_reporter.reporter_id);
  :l_result := case when l_run.RESULT =ut_utils.tr_success then 0 else 1 end;
end;
/

exit :l_result
