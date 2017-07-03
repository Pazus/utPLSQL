create or replace package test_output_buffer is

  --%suite(output_buffer)
  --%suitepath(ut_plsql.core)
  
  --%test(Recieves a line from buffer table and deletes)
  procedure test_recieve;
  
  --%test(Does not send line if null reporter id given)
  procedure test_doesnt_send_on_null_id;
  
  --%test(Does not send line if null text given)
  procedure test_doesnt_send_on_null_text;
  
  --%test(Sends a line into buffer table)
  procedure test_send_line;
  
  --%test(Waits For The Data To Appear For Specified Time)
  procedure test_waiting_for_data;

end test_output_buffer;
/
create or replace package body test_output_buffer is

  procedure test_recieve is
    l_result   varchar2(4000);
    l_remaining integer;
    l_expected varchar2(4000);
    l_reporter ut_reporter_base := ut_documentation_reporter();
  begin
  --Act
    l_expected := lpad('a text',4000,',a text');
    ut_output_buffer.send_line(l_reporter, l_expected);

    select * into l_result from table(ut_output_buffer.get_lines(l_reporter.reporter_id,0));

    ut.expect(l_result).to_equal(l_expected);

    select count(1) into l_remaining from ut_output_buffer_tmp where reporter_id = l_reporter.reporter_id;

    ut.expect(l_remaining).to_equal(0);
  end;
  
  procedure test_doesnt_send_on_null_id is
    l_cur sys_refcursor;
  begin
    delete from ut_output_buffer_tmp;
    --Act
    ut_output_buffer.send_line(null,'a text to send');
    
    open l_cur for select * from ut_output_buffer_tmp;

    ut.expect(l_cur).to_be_empty;
  end;
  
  procedure test_doesnt_send_on_null_text is
    l_cur sys_refcursor;
    l_result integer;
    l_reporter ut_reporter_base := ut_documentation_reporter();
  begin
    delete from ut_output_buffer_tmp;
    --Act
    ut_output_buffer.send_line(l_reporter,null);

    open l_cur for select * from ut_output_buffer_tmp;
    ut.expect(l_cur).to_be_empty;
  end;
  
  procedure test_send_line is
    l_result   varchar2(4000);
    c_expected constant varchar2(4000) := lpad('a text',4000,',a text');
    l_reporter ut_reporter_base := ut_documentation_reporter();
  begin
    ut_output_buffer.send_line(l_reporter, c_expected);

    select text into l_result from ut_output_buffer_tmp where reporter_id = l_reporter.reporter_id;

    ut.expect(l_result).to_equal(c_expected);
  end;
  
  procedure test_waiting_for_data is
    l_result   varchar2(4000);
    l_remaining integer;
    l_expected varchar2(4000);
    l_reporter ut_reporter_base := ut_documentation_reporter();
  begin
  --Act
    l_expected := lpad('a text',4000,',a text');
    ut_output_buffer.send_line(l_reporter, l_expected);

    select * into l_result from table(ut_output_buffer.get_lines(l_reporter.reporter_id,0));

    ut.expect(l_result).to_equal(l_expected);

    select count(1) into l_remaining from ut_output_buffer_tmp where reporter_id = l_reporter.reporter_id;

    ut.expect(l_remaining).to_equal(0);
    
  end;
  
end test_output_buffer;
/
