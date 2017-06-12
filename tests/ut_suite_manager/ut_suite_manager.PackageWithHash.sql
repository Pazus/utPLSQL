set termout off
create or replace package tst_package_with#hash as
  --%suite

  --%test
  procedure test1;
end;
/

create or replace package body tst_package_with#hash as
  procedure test1 is begin ut.expect(1).to_equal(1); end;
  procedure test2 is begin ut.expect(1).to_equal(1); end;
end;
/

set termout on

declare
  l_objects_to_run ut_suite_items;
begin

  --act
  l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list('tst_package_with#hash'));
  
  if ut_expectation_processor.get_status = ut_utils.tr_success then
    :test_result := ut_utils.tr_success;
  end if;

end;
/

drop package tst_package_with#hash
/
