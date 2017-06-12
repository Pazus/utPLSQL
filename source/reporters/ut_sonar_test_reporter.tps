create or replace type ut_sonar_test_reporter under ut_reporter_base(
  /*
  utPLSQL - Version X.X.X.X
  Copyright 2016 - 2017 utPLSQL Project

  Licensed under the Apache License, Version 2.0 (the "License"):
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */
  file_mappings ut_file_mappings,

  constructor function ut_sonar_test_reporter(
    self in out nocopy ut_sonar_test_reporter
  ) return self as result,

  overriding member procedure before_calling_run(self in out nocopy ut_sonar_test_reporter, a_run in ut_run),
  overriding member procedure before_calling_suite(self in out nocopy ut_sonar_test_reporter, a_suite ut_logical_suite),
  overriding member procedure after_calling_test(self in out nocopy ut_sonar_test_reporter, a_test ut_test),
  overriding member procedure after_calling_suite(self in out nocopy ut_sonar_test_reporter, a_suite ut_logical_suite),
  overriding member procedure after_calling_run(self in out nocopy ut_sonar_test_reporter, a_run in ut_run)
)
not final
/
