@isTest
public class MonthlyFlowControlerTest {
    @isTest
    static void testExecute(){
        Test.StartTest();
        MonthlyFlowControler schedulerObj = new MonthlyFlowControler ();
        String scheduleJob = '0 0 23 * * ?';
     	System.Schedule('Test status Check', scheduleJob, schedulerObj );
        Test.stopTest();
    }
}