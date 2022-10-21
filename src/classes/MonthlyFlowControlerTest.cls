/*
  *  Purpose         :    Test class for MonthlyFlowController
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/16
  *  Revision Logs   :    V_1.0 - Created - 2022/10/16
*/
@isTest
public class MonthlyFlowControlerTest {

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    To test scheduled job
      * Params        :    Void
      * Return        :    Void
    */
    @isTest
    static void testExecute(){
        Test.StartTest();
        MonthlyFlowControler schedulerObj = new MonthlyFlowControler ();
        String scheduleJob = '0 0 23 * * ?';
     	String jobId = System.Schedule('Test status Check', scheduleJob, schedulerObj );
        CronTrigger ct = [Select Id, CronExpression, TimesTriggered From CronTrigger Where Id = :jobId];

        System.assertEquals(scheduleJob, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}