create or replace package ut_assert authid current_user as

  procedure report_error(message in varchar2);
  /* Just need something to play with for now */
  procedure are_equal(expected in number, actual in number);
  procedure are_equal(msg in varchar2, expected in number, actual in number);

end ut_assert;
/
