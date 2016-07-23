create or replace type body ut_execution_result is

  constructor function ut_execution_result(a_start_time timestamp with time zone default current_timestamp)
    return self as result is
  begin
    self.start_time := a_start_time;
    self.result := ut_utils.tr_success;
    assertions := ut_assert_list();
    return;
  end ut_execution_result;

  overriding member procedure add_element( self in out nocopy ut_execution_result, an_assertion ut_assert_result_base ) is
  begin
    assertions.extend;
    assertions(assertions.last) := an_assertion;
    self.result := greatest(an_assertion.result, self.result);
  end;

  overriding member function get_element( a_position integer ) return ut_assert_result_base is
  begin
    return assertions(a_position);
  end;

  overriding member function get_elements_count return integer is
  begin
     return cardinality(assertions);
  end;

end;
/
