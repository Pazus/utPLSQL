create or replace type body ut_assert_result is
  
  overriding member procedure add_element( self in out nocopy ut_assert_result, an_assertion ut_assert_result_base ) as
  begin
    null;
  end;

  overriding member function get_element( a_position integer ) return ut_assert_result_base as
  begin
    return self;
  end;

  overriding member function get_elements_count return integer as
  begin
    return 1;
  end;
  
end;
/
