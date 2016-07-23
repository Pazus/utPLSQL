create or replace type ut_execution_result under ut_assert_result_base
(
  start_time       timestamp with time zone,
  assertions       ut_assert_list,

  constructor function ut_execution_result(a_start_time timestamp with time zone default current_timestamp) return self as result,
  overriding member procedure add_element( self in out nocopy ut_execution_result, an_assertion ut_assert_result_base ),
  overriding member function get_element( a_position integer ) return ut_assert_result_base,
  overriding member function get_elements_count return integer
)
not final
/
