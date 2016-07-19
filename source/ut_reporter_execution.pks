create or replace package ut_reporter_execution as
  function get_default_reporters return ut_suite_reporters;
  
  -- these are in spec to make testing a reporter easier
  procedure begin_suite(a_reporter in ut_suite_reporter, a_suite in ut_test_suite);
  procedure end_suite(a_reporter in ut_suite_reporter, a_suite in ut_test_suite, a_results in ut_suite_results);
  procedure begin_test(a_reporter in ut_suite_reporter, a_test in ut_single_test, a_in_suite in boolean);
  procedure end_test(a_reporter in ut_suite_reporter, a_test in ut_single_test,  a_in_suite in boolean);

  -- these are the ones called when a test/suite is run.
  procedure begin_suite(a_reporters in ut_suite_reporters, a_suite in ut_test_suite);
  procedure end_suite(a_reporters in ut_suite_reporters, a_suite in ut_test_suite, a_results in ut_suite_results);
  procedure begin_test(a_reporters in ut_suite_reporters, a_test in ut_single_test, a_in_suite in boolean);
  procedure end_test(a_reporters in ut_suite_reporters, a_test in ut_single_test, a_in_suite in boolean);
end;
/
