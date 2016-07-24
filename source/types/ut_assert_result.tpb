create or replace type body ut_assert_result is
  
  constructor function ut_assert_result(self in out nocopy ut_assert_result, a_result integer, a_name varchar2, an_expected varchar2, an_actual varchar2, an_end_time timestamp with time zone) return self as result as
  begin
    self.result := a_result;
    self.name := a_name;
    self.expected := an_expected;
    self.actual := an_actual;
    self.end_time := an_end_time;
    return;
  end;

end;
/
