create or replace package test_run is

  --%suite(run)
  --%suitepath(ut_plsql.core)
  
  --%test
  procedure test1;
  
  --%beforeall
  procedure compile_dummy_packages;
  --%afterall
  procedure drop_dummy_packages;
end test_run;
/
create or replace package body test_run is

  procedure compile_dummy_packages is
  begin
    execute immediate q'[create or replace package test_package_1 is

  --%suite
  --%suitepath(tests)

  gv_glob_val number;

  --%beforeeach
  procedure global_setup;

  --%aftereach
  procedure global_teardown;

  --%test
  --%displayname(Test1 from test package 1)
  procedure test1;

  --%test(Test2 from test package 1)
  --%beforetest(test2_setup)
  --%aftertest(test2_teardown)
  procedure test2;

  procedure test2_setup;

  procedure test2_teardown;

end test_package_1;]';

  execute immediate q'[create or replace package body test_package_1 is

  gv_var_1 number;

  gv_var_1_temp number;

  procedure global_setup is
  begin
    gv_var_1    := 1;
    gv_glob_val := 1;
  end;

  procedure global_teardown is
  begin
    gv_var_1    := 0;
    gv_glob_val := 0;
  end;

  procedure test1 is
  begin
    ut.expect(gv_var_1).to_equal(1);
  end;

  procedure test2 is
  begin
    ut.expect(gv_var_1).to_equal(2);
  end;

  procedure test2_setup is
  begin
    gv_var_1_temp := gv_var_1;
    gv_var_1      := 2;
  end;

  procedure test2_teardown is
  begin
    gv_var_1      := gv_var_1_temp;
    gv_var_1_temp := null;
  end;

end test_package_1;]';

    execute immediate q'[create or replace package test_package_2 is

  --%suite
  --%suitepath(tests.test_package_1)

  gv_glob_val varchar2(1);

  --%beforeeach
  procedure global_setup;

  --%aftereach
  procedure global_teardown;

  --%test
  procedure test1;

  --%test
  --%beforetest(test2_setup)
  --%aftertest(test2_teardown)
  procedure test2;

  procedure test2_setup;

  procedure test2_teardown;

end test_package_2;]';
execute immediate q'[create or replace package body test_package_2 is

  gv_var_1 varchar2(1);

  gv_var_1_temp varchar2(1);

  procedure global_setup is
  begin
    gv_var_1    := 'a';
    gv_glob_val := 'z';
  end;

  procedure global_teardown is
  begin
    gv_var_1    := 'n';
    gv_glob_val := 'n';
  end;

  procedure test1 is
  begin
    ut.expect(gv_var_1).to_equal('a');
  end;

  procedure test2 is
  begin
    ut.expect(gv_var_1).to_equal('b');
  end;

  procedure test2_setup is
  begin
    gv_var_1_temp := gv_var_1;
    gv_var_1      := 'b';
  end;

  procedure test2_teardown is
  begin
    gv_var_1      := gv_var_1_temp;
    gv_var_1_temp := null;
  end;

end test_package_2;]';

    execute immediate q'[create or replace package test_package_3 is

  --%suite
  --%suitepath(tests2)

  gv_glob_val number;

  --%beforeeach
  procedure global_setup;

  --%aftereach
  procedure global_teardown;

  --%test
  procedure test1;

  --%test
  --%beforetest(test2_setup)
  --%aftertest(test2_teardown)
  procedure test2;

  procedure test2_setup;

  procedure test2_teardown;
  
  --%test
  --%disabled
  procedure disabled_test;

end test_package_3;]';
    execute immediate q'[create or replace package body test_package_3 is

  gv_var_1 number;

  gv_var_1_temp number;

  procedure global_setup is
  begin
    gv_var_1    := 1;
    gv_glob_val := 1;
  end;

  procedure global_teardown is
  begin
    gv_var_1    := 0;
    gv_glob_val := 0;
  end;

  procedure test1 is
  begin
    ut.expect(gv_var_1).to_equal(1);
  end;

  procedure test2 is
  begin
    ut.expect(gv_var_1).to_equal(2);
  end;

  procedure test2_setup is
  begin
    gv_var_1_temp := gv_var_1;
    gv_var_1      := 2;
  end;

  procedure test2_teardown is
  begin
    gv_var_1      := gv_var_1_temp;
    gv_var_1_temp := null;
  end;
  
  procedure disabled_test is
  begin
    null;
  end;

end test_package_3;]';
  end;
  --%afterall
  procedure drop_dummy_packages is
  begin
    execute immediate 'drop package test_package_1';
    execute immediate 'drop package test_package_2';
    execute immediate 'drop package test_package_3';
  end;

  procedure test1 is
    l_packages_executed integer;
  begin
    --act
    select count(*) into l_packages_executed
      from table(ut.run(ut_varchar2_list(':tests',':tests2'), ut_teamcity_reporter()))
      where column_value like '%Finished %''test\_package\_1''%'
      or column_value like '%Finished %''test_package_2''%'
      or column_value like '%Finished %''test_package_3''%' ;
    
    ut.expect(l_packages_executed,'Packages executed').to_equal(3);
  end;
end test_run;
/
