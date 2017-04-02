create or replace package test_suite_manager is

  --%suite(suite_manager)
  --%suitepath(ut_plsql.core)
  
  --%beforeall
  procedure compile_dummy_packages;
  --%afterall
  procedure drop_dummy_packages;
  
  --%test(Prepare Runner For The Schema)
  procedure test_schema_run;
  
  --%test(Prepare runner for the top 2 package by package user.package_name)
  procedure test_top2_by_name;
  
  --%test(Prepare runner for the top2 package by name cur user)
  procedure test_top2_bt_name_cur_user;
  
  --%test(Prepare runner for the subsuite by path)
  procedure test_by_path_to_subsuite;

  --%test(Prepare runner for the subsuite by path for current user)  
  procedure test_by_path_to_subsuite_cu;
  
  --%test(Prepare runner for the subsuite proc only by path)
  procedure test_subsute_proc_by_path;
  
  --%test(Prepare runner for the subsuite proc only by path for current user)  
  procedure test_subsute_proc_by_path_cu;  
  
  --%test(Prepare runner for the top package by package name)
  procedure test_top_pack_by_name;
  
  --%test(Prepare runner for the top package by package name for current user)
  procedure test_top_pack_by_name_cu;
  
  --%test(Prepare runner for the top package by path)
  procedure test_top_pack_by_path;
  
  --%test(Prepare runner for the top package by path for current user)
  procedure test_top_pack_by_path_cu;
  
  --%test(Prepare runner for the top package procedure by path)
  procedure test_top_pck_proc_by_path;
  
  --%test(Prepare runner for the top package procedure by path for current user)
  procedure test_top_pck_proc_by_path_cu;
  
  --%test(Prepare runner for the top package procedure without sub-suites by package name)
  procedure test_top_pkc_proc_by_name;
  
  --%test(Prepare runner for the top package procedure without sub-suites by package name for current user)
  procedure test_top_pkc_proc_by_name_cu;
  
  --%test(Prepare runner for the top package without sub-suites by package name)
  procedure test_top_pkc_nosub_by_name;
  
  --%test(Prepare runner for the top package without sub-suites by package name for current user)
  procedure test_top_pkc_nosub_by_name_cu;
  
  --%test(Prepare runner for the suites package by path)
  procedure test_top_subpck_by_path;
  
  --%test(Prepare runner for the suites package by path for current user)
  procedure test_top_subpck_by_path_cu;
  
  --%test(Prepare runner for invalid package)
  --%beforetest(compile_invalid_package)
  --%aftertest(drop_invalid_package)
  procedure test_search_invalid_pck;
  procedure compile_invalid_package;
  procedure drop_invalid_package;

end test_suite_manager;
/
create or replace package body test_suite_manager is

  procedure test_schema_run is
    c_path           constant varchar2(100) := USER;
    l_objects_to_run ut_suite_items := ut_suite_items();
    l_all_objects_to_run ut_suite_items;

    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin
    --Act
    l_all_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
    for i in 1..l_all_objects_to_run.count loop
      if l_all_objects_to_run(i).name in ('tests', 'tests2') then
        l_objects_to_run.extend;
        l_objects_to_run(l_objects_to_run.last) := l_all_objects_to_run(i);
      end if;
    end loop;

    --Assert
    ut.expect(l_objects_to_run.count).to_equal(2);

    for i in 1 .. 2 loop
      l_test0_suite := treat(l_objects_to_run(i) as ut_logical_suite);
      ut.expect(l_test0_suite.name in ('tests', 'tests2')).to_be_true;
      
      l_test1_suite := treat(l_test0_suite.items(1) as ut_logical_suite);
    
      case l_test0_suite.name
        when 'tests' then
          ut.expect(l_test1_suite.name).to_equal('test_package_1');
          ut.expect(l_test1_suite.items.count).to_equal(3);
          l_test2_suite := treat(l_test1_suite.items(3) as ut_logical_suite);

          ut.expect(l_test2_suite.name).to_equal('test_package_2');
          ut.expect(l_test2_suite.items.count).to_equal(2);
        when 'tests2' then          
          ut.expect(l_test1_suite.name).to_equal('test_package_3');
          ut.expect(l_test1_suite.items.count).to_equal(3);
      end case;
    
    end loop;

  end;
  
  procedure test_top2_by_name is
    c_path varchar2(100) := USER||'.test_package_2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test2_suite :=  treat(l_test1_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_top2_bt_name_cur_user is
    c_path varchar2(100) := 'test_package_2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test2_suite :=  treat(l_test1_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_by_path_to_subsuite is
    c_path varchar2(100) := USER||':tests.test_package_1.test_package_2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test2_suite :=  treat(l_test1_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_by_path_to_subsuite_cu is
    c_path varchar2(100) := ':tests.test_package_1.test_package_2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test2_suite :=  treat(l_test1_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
   procedure test_subsute_proc_by_path is
    c_path varchar2(100) := USER||':tests.test_package_1.test_package_2.test2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
    l_test_proc ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test2_suite :=  treat(l_test1_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(1);
    
    l_test_proc := treat(l_test2_suite.items(1) as ut_test);   
    ut.expect(l_test_proc.name).to_equal('test2');
    ut.expect(l_test_proc.before_test is not null).to_be_true;
    ut.expect(l_test_proc.after_test is not null).to_be_true;

  end;
  
   procedure test_subsute_proc_by_path_cu is
    c_path varchar2(100) := ':tests.test_package_1.test_package_2.test2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
    l_test_proc ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test2_suite :=  treat(l_test1_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(1);
    
    l_test_proc := treat(l_test2_suite.items(1) as ut_test);   
    ut.expect(l_test_proc.name).to_equal('test2');
    ut.expect(l_test_proc.before_test is not null).to_be_true;
    ut.expect(l_test_proc.after_test is not null).to_be_true;
  end;
  
  procedure test_top_pack_by_name is
    c_path varchar2(100) := USER||'.test_package_1';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_suite;
    l_test2_suite ut_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    
    ut.expect(l_test1_suite.items(1).name).to_equal('test1');
    ut.expect(l_test1_suite.items(1).description).to_equal('Test1 from test package 1');
    ut.expect(treat(l_test1_suite.items(1) as ut_test).before_test.is_defined).to_be_false;
    ut.expect(treat(l_test1_suite.items(1) as ut_test).after_test.is_defined).to_be_false;
    ut.expect(treat(l_test1_suite.items(1) as ut_test).before_each.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(1) as ut_test).DISABLED_FLAG).to_equal(0);
    
    ut.expect(l_test1_suite.items(2).name).to_equal('test2');
    ut.expect(l_test1_suite.items(2).description).to_equal('Test2 from test package 1');
    ut.expect(treat(l_test1_suite.items(2) as ut_test).before_test.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(2) as ut_test).after_test.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(2) as ut_test).before_each.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(2) as ut_test).DISABLED_FLAG).to_equal(0);
    
    -- temporary behavior.
    -- decided that when executed by package, not path, only that package has to execute
    l_test2_suite :=  treat(l_test1_suite.items(3) as ut_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_top_pack_by_name_cu is
    c_path varchar2(100) := 'test_package_1';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_suite;
    l_test2_suite ut_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    
    ut.expect(l_test1_suite.items(1).name).to_equal('test1');
    ut.expect(l_test1_suite.items(1).description).to_equal('Test1 from test package 1');
    ut.expect(treat(l_test1_suite.items(1) as ut_test).before_test.is_defined).to_be_false;
    ut.expect(treat(l_test1_suite.items(1) as ut_test).after_test.is_defined).to_be_false;
    ut.expect(treat(l_test1_suite.items(1) as ut_test).before_each.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(1) as ut_test).DISABLED_FLAG).to_equal(0);
    
    ut.expect(l_test1_suite.items(2).name).to_equal('test2');
    ut.expect(l_test1_suite.items(2).description).to_equal('Test2 from test package 1');
    ut.expect(treat(l_test1_suite.items(2) as ut_test).before_test.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(2) as ut_test).after_test.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(2) as ut_test).before_each.is_defined).to_be_true;
    ut.expect(treat(l_test1_suite.items(2) as ut_test).DISABLED_FLAG).to_equal(0);
    
    -- temporary behavior.
    -- decided that when executed by package, not path, only that package has to execute
    l_test2_suite :=  treat(l_test1_suite.items(3) as ut_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_top_pack_by_path is
    c_path varchar2(100) := USER||':tests';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    l_test2_suite :=  treat(l_test1_suite.items(3) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_top_pack_by_path_cu is
    c_path varchar2(100) := ':tests';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    l_test2_suite :=  treat(l_test1_suite.items(3) as ut_logical_suite);
    
    ut.expect(l_test2_suite.name).to_equal('test_package_2');
    ut.expect(l_test2_suite.items.count).to_equal(2);
  end;
  
  procedure test_top_pck_proc_by_path is
    c_path varchar2(100) := USER||':tests.test_package_1.test2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
    l_test_proc ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test_proc := treat(l_test1_suite.items(1) as ut_test);   
    
    ut.expect(l_test_proc.name).to_equal('test2');
    ut.expect(l_test_proc.description).to_equal('Test2 from test package 1');
    ut.expect(l_test_proc.before_test is not null).to_be_true;
    ut.expect(l_test_proc.after_test is not null).to_be_true;
  end;
  
  procedure test_top_pck_proc_by_path_cu is
    c_path varchar2(100) := ':tests.test_package_1.test2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test2_suite ut_logical_suite;
    l_test_proc ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    l_test_proc := treat(l_test1_suite.items(1) as ut_test);   
    
    ut.expect(l_test_proc.name).to_equal('test2');
    ut.expect(l_test_proc.description).to_equal('Test2 from test package 1');
    ut.expect(l_test_proc.before_test is not null).to_be_true;
    ut.expect(l_test_proc.after_test is not null).to_be_true;
  end;
  
  procedure test_top_pkc_proc_by_name is
    c_path varchar2(100) := USER||'.test_package_1.test2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test_proc ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    
    l_test_proc := treat(l_test1_suite.items(1) as ut_test);   
    ut.expect(l_test_proc.name).to_equal('test2');
    ut.expect(l_test_proc.before_test is not null).to_be_true;
    ut.expect(l_test_proc.after_test is not null).to_be_true;
  end;
  
  procedure test_top_pkc_proc_by_name_cu is
    c_path varchar2(100) := 'test_package_1.test2';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test_proc ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_1');
    ut.expect(l_test1_suite.items.count).to_equal(1);
    
    l_test_proc := treat(l_test1_suite.items(1) as ut_test);   
    ut.expect(l_test_proc.name).to_equal('test2');
    ut.expect(l_test_proc.before_test is not null).to_be_true;
    ut.expect(l_test_proc.after_test is not null).to_be_true;
  end;
  
  procedure test_top_pkc_nosub_by_name is
    c_path varchar2(100) := USER||'.test_package_3';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test1        ut_test;
    l_test3        ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests2');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_3');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    
    l_test1 := treat(l_test1_suite.items(1) as ut_test);
    ut.expect(l_test1.name).to_equal('test1');
    ut.expect(l_test1.DISABLED_FLAG).to_equal(0);
    
    l_test3 := treat(l_test1_suite.items(3) as ut_test);
    ut.expect(l_test3.name).to_equal('disabled_test');
    ut.expect(l_test3.DISABLED_FLAG).to_equal(1);
  end;
  
  procedure test_top_pkc_nosub_by_name_cu is
    c_path varchar2(100) := 'test_package_3';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test1        ut_test;
    l_test3        ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests2');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_3');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    
    l_test1 := treat(l_test1_suite.items(1) as ut_test);
    ut.expect(l_test1.name).to_equal('test1');
    ut.expect(l_test1.DISABLED_FLAG).to_equal(0);
    
    l_test3 := treat(l_test1_suite.items(3) as ut_test);
    ut.expect(l_test3.name).to_equal('disabled_test');
    ut.expect(l_test3.DISABLED_FLAG).to_equal(1);
  end;
  
  procedure test_top_subpck_by_path is
    c_path varchar2(100) := USER||':tests2.test_package_3';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test1        ut_test;
    l_test3        ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests2');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_3');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    
    l_test1 := treat(l_test1_suite.items(1) as ut_test);
    ut.expect(l_test1.name).to_equal('test1');
    ut.expect(l_test1.DISABLED_FLAG).to_equal(0);
    
    l_test3 := treat(l_test1_suite.items(3) as ut_test);
    ut.expect(l_test3.name).to_equal('disabled_test');
    ut.expect(l_test3.DISABLED_FLAG).to_equal(1);
  end;  
  
  procedure test_top_subpck_by_path_cu is
    c_path varchar2(100) := ':tests2.test_package_3';
    l_objects_to_run ut_suite_items;
    
    l_test0_suite ut_logical_suite;
    l_test1_suite ut_logical_suite;
    l_test1        ut_test;
    l_test3        ut_test;
  begin  
  --Act
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list(c_path));
    
  --Assert
    ut.expect(l_objects_to_run.count).to_equal(1);
    l_test0_suite := treat(l_objects_to_run(1) as ut_logical_suite);
    
    ut.expect(l_test0_suite.name).to_equal('tests2');
    ut.expect(l_test0_suite.items.count).to_equal(1);
    l_test1_suite :=  treat(l_test0_suite.items(1) as ut_logical_suite);
    
    ut.expect(l_test1_suite.name).to_equal('test_package_3');
    ut.expect(l_test1_suite.items.count).to_equal(3);
    
    l_test1 := treat(l_test1_suite.items(1) as ut_test);
    ut.expect(l_test1.name).to_equal('test1');
    ut.expect(l_test1.DISABLED_FLAG).to_equal(0);
    
    l_test3 := treat(l_test1_suite.items(3) as ut_test);
    ut.expect(l_test3.name).to_equal('disabled_test');
    ut.expect(l_test3.DISABLED_FLAG).to_equal(1);
  end;  
  
  procedure test_search_invalid_pck is
    l_objects_to_run ut_suite_items;
  begin
    l_objects_to_run := ut_suite_manager.configure_execution_by_path(ut_varchar2_list('failing_invalid_spec'));
    ut.fail('Invalid package didnt raised exception');
  exception
    when others then
      ut.expect(sqlerrm).to_be_like('%failing_invalid_spec%');
  end;
  
  procedure compile_invalid_package is
    ex_compilation_error exception;
    pragma exception_init(ex_compilation_error,-24344);
    pragma autonomous_transaction;
  begin
    begin
      execute immediate q'[create or replace package failing_invalid_spec as
  --%suite
  gv_glob_val non_existing_table.id%type := 0;

  --%beforeall
  procedure before_all;
  --%test
  procedure test1;
  --%test
  procedure test2;
end;]';
    exception when ex_compilation_error then null;
    end;
    begin
      execute immediate q'[create or replace package body failing_invalid_spec as
  procedure before_all is begin gv_glob_val := 1; end;
  procedure test1 is begin ut.expect(1).to_equal(1); end;
  procedure test2 is begin ut.expect(1).to_equal(1); end;
end;]';
    exception when ex_compilation_error then null;
    end;
  end;
  procedure drop_invalid_package is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package failing_invalid_spec';
  end;

  procedure compile_dummy_packages is
    pragma autonomous_transaction;
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

  procedure drop_dummy_packages is
    pragma autonomous_transaction;
  begin
    execute immediate 'drop package test_package_1';
    execute immediate 'drop package test_package_2';
    execute immediate 'drop package test_package_3';
  end;
  
end test_suite_manager;
/
