/*
  *  Purpose         :    Class to send mail to all bank customers
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/09
  *  Revision Logs   :    V_1.0 - Created - 2022/10/09
*/
global class MonthlyFlowControler implements Schedulable{
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    execute method to send mail
      * Params        :    Database.BatchableContext bc
      * Return        :    Void
    */
    global void execute(SchedulableContext sc){
        Flow.Interview.Send_Monthly_Statement monthlyFlow = new Flow.Interview.Send_Monthly_Statement(new Map<String, Object>());
        monthlyFlow.start();
    }
    
}