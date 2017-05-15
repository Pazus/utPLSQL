# utPLSQL v3<sub><sup> | Powerful PL/SQL Unit Testing Framework </sup></sub>

[![latest-release](https://img.shields.io/github/release/utPLSQL/utPLSQL.svg)](https://github.com/utPLSQL/utPLSQL/releases)
[![license](http://img.shields.io/badge/license-apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![chat](http://img.shields.io/badge/slack-team--chat-blue.svg)](http://utplsql-slack-invite.herokuapp.com/)
[![twitter](https://img.shields.io/twitter/follow/utPLSQL.svg?style=social&label=Follow)](https://twitter.com/utPLSQL)

[![build](https://img.shields.io/travis/utPLSQL/utPLSQL/master.svg?label=master%20branch)](https://travis-ci.org/utPLSQL/utPLSQL)
[![build](https://img.shields.io/travis/utPLSQL/utPLSQL/develop.svg?label=develop%20branch)](https://travis-ci.org/utPLSQL/utPLSQL)
[![sonar](https://sonarqube.com/api/badges/gate?key=utPLSQL%3AutPLSQL%3Adevelop)](https://sonarqube.com/dashboard/index?id=utPLSQL%3AutPLSQL%3Adevelop)
[![Coveralls coverage](https://coveralls.io/repos/github/utPLSQL/utPLSQL/badge.svg?branch=develop)](https://coveralls.io/github/utPLSQL/utPLSQL?branch=develop)

----------
utPLSQL version 3 is a complete rewrite of utPLSQL v2 from scratch.
Version 2 still supports older versions of Oracle that are no longer available. 
The community that had developed on GitHub, decided that a new internal architecture was needed, from that version 3 was born.  

# Introduction
utPLSQL is a Unit Testing framework for Oracle PL/SQL and SQL. 
The framework follows industry standards and best patterns of modern Unit Testing frameworks like [JUnit](http://junit.org/junit4/) and [RSpec](http://rspec.info/)


# Key features

- multiple ways to compare data with [matchers](docs/userguide/expectations.md)
- native comparison of complex types (objects/collections/cursors)
- in-depth and consistent reporting of failures and errors for tests
- tests identified and configured by [annotations](docs/userguide/annotations.md)
- hierarchies of test suites configured with annotations
- automatic (configurable) transaction control
- Build-in [coverage](docs/userguide/coverage.md) reporting
- Integration with SonarQube, Coveralls, Jenkins and Teamcity with [reporters](docs/userguide/reporters.md)
- plugin architecture for reporters and matchers
- flexible and simple test invocation
- multi-reporting from test-run from [command line](docs/userguide/ut_run-script.md)

# Primary features
 - Support for all basic scalar data-types except ROWID and RAW
 - Support for User Defined Object Types and Collections
 - Support for native cursors both strong and weak
 - Data-type aware testing - number 1 is not equal to string '1'
 - [Annotations](docs/userguide/annotations.md) are used to define and configure tests
 - Extensible [expectations](docs/userguide/expectations.md)
 - Extensible reporting formats
 - Extensible output providers
 - Support for multi-reporting
 - Code coverage reporting (with different formats)
 - Runtime reporting of test execution progress
 - Well-defined API
 - Easy to call from current PL/SQL development tools
 - More permissive License to allow vendors to integrate utPLSQL without violation of license 
 - Published upgrade/conversion path from version 2 ( TODO )

Requirements:
 - Version of Oracle under [extended support](http://www.oracle.com/us/support/library/lifetime-support-technology-069183.pdf) (Currently 11.2 and above)

# Download

Published releases are available for download on the [utPLSQL GitHub Releases Page.](https://github.com/utPLSQL/utPLSQL/releases)

# Documentation

Full documentation of the project is automatically published on [utPLSQL github pages](https://utplsql.github.io/utPLSQL/)

# Contributing to the project

We welcome new developers to join our community and contribute to the utPLSQL project.
If you are interested in helping please read our [guide to contributing](docs/about/CONTRIBUTING.md)
The best place to start is to read the documentation and get familiar existing with code base.
A [slack chat](https://utplsql.slack.com/) is the place to go isf you want to talk with team members.
To sign up to the chat use [this link](http://utplsql-slack-invite.herokuapp.com/)


[__Authors__](docs/about/authors.md)

__Version 2 to Version 3 Comparison__

If you have great feature in mind, that you would like to see in utPLSQL v3 please create an [issue on GitHub](https://github.com/utPLSQL/utPLSQL/issues) or discuss it with us in the [Slack chat rooms](http://utplsql-slack-invite.herokuapp.com/).  


| Feature                                | Version 2              | Version 3              |
| -------------------------------------- | ---------------------- | ---------------------- |
| Easy to install                        | Yes                    | Yes                    |
| Documentation                          | Yes                    | Yes                    |
| License                                | GPL v2                 | Apache 2.0             |
| **Tests Creation**                     |                        |                        |
| Declarative test configuration         | No                     | Yes - Annotations<sup>1</sup>|
| Tests as Packages                      | Yes                    | Yes                    |
| Multiple Tests in a single Package     | Yes                    | Yes                    |
| Optional Setup/Teardown                | No                     | Yes                    |
| Different Setup/Teardown <br/> For Each Test in a Single Package| No  | Yes - Annotations<sup>1</sup> |
| Suite Definition Storage               | Tables                 | Package - Annotations<sup>1</sup> |
| Multiple Suites                        | Yes                    | Yes                    |
| Suites can contain Suites              | No                     | Yes                    |
| Automatic Test detection               | No                     | Yes - Annotations<sup>1</sup>|
| Unconstrained naming of Test packages  | No - prefixes          | Yes - name not relevant|
| Require Prefix on Test procedures      | No - prefixes          | Yes - name not relevant|
| Auto Compilation of Tests              | Yes                    | No (Let us know if you use this) | 
| Assertion Library                      | 30 assertions<sup>2</sup> | 26 matchers (13 + 13 megated) |
| Extendable assertions                  | No                     | Yes - custom matchers  |
| PLSQL Record Assertions	             | generated code through **utRecEq** Package | [possible on Oracle 12c](https://oracle-base.com/articles/12c/using-the-table-operator-with-locally-defined-types-in-plsql-12cr1) using [cursor matchers](docs/userguide/expectations.md#comparing-cursors)| 
| Test Skeleton Generation               | Yes                    | On Roadmap             |
| **Test Execution<sup>3</sup>**         |                        |                        |
| Single Test Package Execution          |  Yes                   | Yes                    | 
| Single Test Procedure Execution        |  No                    | Yes                    | 
| Test Suite Execution                   |  Yes                   | Yes                    |
| Subset of Suite Execution              |  No                    | Yes                    |
| Multiple Suite Execution               |  No                    | Yes                    |
| Organizing Suites into hierarchies     |  No                    | Yes                    |
| **Code Coverage Reporting**            |  No                    | Yes                    |
| Html Coverage Report                   |  No                    | Yes                    |
| Sonar XML Coverage Report              |  No                    | Yes                    |
| Coveralls Json Coverage Report         |  No                    | Yes                    |
| Framework Transaction Control          |  No                    | Yes - Annotations<sup>1</sup> | 
| **Test Output**                        |                        |                        |
| Real-time test execution progress reporting | No                | Yes                    |
| Multiple Output Reporters can be used during test execution | No| Yes                    |
| DBMS_OUTPUT                            | Yes                    | Yes (clean formatting) |
| File                                   | Yes (to db server only)| Yes (on client side)   |
| Stored in Table                        | Yes                    | No (can be added as custom reporter)
| XUnit format support                   | No                     | Yes                    |
| HTML Format                            | Yes                    | No                     |
| Custom Output reporter                 | Yes-needs configuration| Yes - no config needed |

<sup>1</sup> Annotations are specially formatted comments in your package specification.  This enables *declarative* test configuration that is coupled with the source code.   See Documentation for more details. 

<sup>2</sup> **utAssert2** package - Contains 59 Assertions - 2 Not implemented = 57, 28 are duplicated only change on outcome_in parameter 57-28 = 29, **utPipe** package - Contains 1 Assertion 29 + 1 = 30

<sup>3</sup> Test execution comparison is in a single call so the results are combined.   We know it was always possible group in any way with multiple calls.  But that may not be desired under CI system where you want a single JUnit XML Output.

# Installation

To simply install the utPLSQL into a new database schema and grant it to public, execute the script `install_headless.sql`.

This will create a new user `UT3` with password `UT3`, grant all needed privileges to that user and create PUBLIC synonyms needed tu sue the utPLSQL framework.

Example invocation of the script from command line:
```bash
cd source
sqlplus admin/admins_password@xe @@install_headless.sql  
```

For detailed instructions on other install options see the [Install Guide](docs/userguide/install.md)

# Example unit test packages

The below test package is a fully-functional Unit Test package for testing a [`betwnstr` function](examples/between_string/betwnstr.sql).
Package specification is [annotated](docs/userguide/annotations.md) with special comments.
Annotations define that a package is a unit test suite, they also allow defining a description for the suite as well as the test itself.
Package body consists of procedures containing unit test code. To validate [an expectation](docs/userguide/expectations.md) in test, use `ut.expect( actual_data ).to_( ... )` syntax.

```sql
create or replace package test_between_string as

  -- %suite(Between string function)

  -- %test(Returns substring from start position to end position)
  procedure normal_case;

  -- %test(Returns substring when start position is zero)
  procedure zero_start_position;

  -- %test(Returns string until end if end position is greater than string length)
  procedure big_end_position;

  -- %test(Returns null for null input string value)
  procedure null_string;
end;
/

create or replace package body test_between_string as

  procedure normal_case is
  begin
    ut.expect( betwnstr( '1234567', 2, 5 ) ).to_( equal('2345') );
  end;

  procedure zero_start_position is
  begin
    ut.expect( betwnstr( '1234567', 0, 5 ) ).to_( equal('12345') );
  end;

  procedure big_end_position is
  begin
    ut.expect( betwnstr( '1234567', 0, 500 ) ).to_( equal('1234567') );
  end;

  procedure null_string is
  begin
    ut.expect( betwnstr( null, 2, 5 ) ).to_( be_null );
  end;

end;
/
```

Have a look at the [utPLSQL demo project](https://github.com/utPLSQL/utPLSQL-demo-project/).
The project is installing few example packages from the [source directory](https://github.com/utPLSQL/utPLSQL-demo-project/tree/develop/source),
installing the test packages from [test directory](https://github.com/utPLSQL/utPLSQL-demo-project/tree/develop/test)
and finally executing all the tests using [Travis CI](https://travis-ci.org/utPLSQL/utPLSQL-demo-project).
The [test results](https://sonarqube.com/component_measures/metric/tests/list?id=utPLSQL%3AutPLSQL-demo-project)
 together with [code coverage](https://sonarqube.com/component_measures/metric/coverage/list?id=utPLSQL%3AutPLSQL-demo-project)
 are published to the [projects Sonar page](https://sonarqube.com/dashboard?id=utPLSQL%3AutPLSQL-demo-project) after every successful build.  

# Running tests

To execute using development IDE (TOAD/SQLDeveloper/PLSQLDeveloper/other) just run the following.
```sql
begin
  ut.run();
end;
/
```
Will run all the suites in the current schema and provide documentation report using dbms_output

```
Between string function
  Returns substring from start position to end position
  Returns substring when start position is zero
  Returns string until end if end position is greater than string length
  Returns null for null input string value

Finished in .036027 seconds
4 tests, 0 failures
```

To execute your tests from command line, you will need a oracle sql client like SQLPlus or [SQLcl](http://www.oracle.com/technetwork/developer-tools/sqlcl/overview/index.html)
You may benefit from using the [ut_run.sql](client_source/sqlplus/ut_run.sql) to execute your tests if you want to achieve one of the following:
* see the progress of test execution for long-running tests
* have output to screen with one output format (text) and at the same time have output to file in other format (xunit)

Example:
```
c:\my_work\>sqlplus /nolog @ut_run hr/hr@xe 
```
Will run all the suites in the current schema (hr) and provide documentation report into screen.
Invoking this script will show the progress after each test.

__Project Directories__

* .travis - contains files needed for travis-ci integration
* client_source - Sources to be used on the client-side. Developer workstation or CI platform to run the tests.
* development - Set of useful scripts and utilities for development and debugging of utPLSQL 
* docs - Documentation of the project 
* examples - Example source code and unit tests
* source - The installation code for utPLSQL
* tests - Tests for utPLSQL framework
