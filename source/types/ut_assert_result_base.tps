create or replace type ut_assert_result_base as object
(
  result   integer(1),
  message  varchar2(4000 char),
  expected varchar2(4000 char),
  actual   varchar2(4000 char),
  end_time timestamp with time zone,
  not instantiable member procedure add_element( self in out nocopy ut_assert_result_base, an_assertion ut_assert_result_base ),
  not instantiable member function get_element( a_position integer ) return ut_assert_result_base,
  not instantiable member function get_elements_count return integer
)
not final not instantiable
/
