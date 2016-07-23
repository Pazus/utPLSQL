create or replace type ut_assert_result under ut_assert_result_base
(
  overriding member procedure add_element( self in out nocopy ut_assert_result, an_assertion ut_assert_result_base ),
  overriding member function get_element( a_position integer ) return ut_assert_result_base,
  overriding member function get_elements_count return integer
)
not final
/
