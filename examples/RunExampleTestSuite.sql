--Shows how to create a test suite in code and call the test runner.
--No tables are used for this.   
--Suite Management packages are when developed will make this easier.
--Clear Screen
--Set Serveroutput On Size Unlimited

Declare
   testtoexecute ut_single_test;
   Suite Ut_Test_Suite;
   testresults ut_suite_results;
Begin
	 suite := ut_test_suite(a_suite_name => 'Test Suite Name'/*,a_tests => ut_Test_List()*/);
   --Suite.Suite_name := 'Test Suite Name';
   --Suite.Tests := ut_Test_List();
   
	 Testtoexecute := ut_single_test(a_object_name => 'ut_exampletest',a_test_procedure => 'ut_exampletest',a_setup_procedure => 'Setup', a_teardown_procedure => 'TearDown');
   --Testtoexecute.object_name := 'ut_exampletest';
   --Testtoexecute.setup_procedure := 'Setup';
   --TestToExecute.teardown_procedure := 'TearDown';
   --TestToExecute.test_procedure := 'ut_exampletest';

   Suite.add_test(Testtoexecute);
	 --Suite.Tests.extend;
   --Suite.Tests(Suite.Tests.Last) := Testtoexecute;
	 
	 Testtoexecute := ut_single_test(a_object_name => 'ut_exampletest2',a_test_procedure => 'ut_exampletest',a_setup_procedure => 'Setup', a_teardown_procedure => 'TearDown');

   --Testtoexecute.object_name := 'ut_exampletest2';
   --Testtoexecute.setup_procedure := 'Setup';
   --TestToExecute.teardown_procedure := 'TearDown';
   --TestToExecute.test_procedure := 'ut_exampletest';
   
   --Suite.Tests.Extend;   
   --Suite.Tests(Suite.Tests.LAST) := TestToExecute;
   Suite.add_test(Testtoexecute);
   ut_Test_Runner.Execute_Tests(Suite,null,TestResults);
      
   -- No reporter used in this example so outputing the results manually.
   FOR test_idx in TestResults.first .. TestResults.last
   LOOP
       Dbms_Output.Put_Line('---------------------------------------------------');
       Dbms_Output.Put_Line('Test:' || Testresults(Test_Idx).Test.Object_Name || '.' || Testresults(Test_Idx).Test.Test_Procedure ); 
       dbms_output.put_line('Result: ' || Ut_Types.Test_Result_To_Char(TestResults(test_idx).result) );
       Dbms_Output.Put_Line('Assert Results:');
       FOR I in TestResults(test_idx).Assert_Results.First .. TestResults(test_idx).Assert_Results.Last
       Loop
          Dbms_Output.Put_Line(I || ' - result: ' ||  Ut_Types.Test_Result_To_Char(Testresults(Test_Idx).Assert_Results(I).Result) );
          dbms_output.put_line(I || ' - Message: ' ||  TestResults(test_idx).Assert_Results(I).Message);
       END LOOP;   
   END LOOP;
   dbms_output.put_line('---------------------------------------------------');
End;
/

