/*
  *  Purpose         :    Trigger for TransactionEntry object
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/08
  *  Revision Logs   :    V_1.0 - Created - 2022/10/08
*/
trigger Trigger_TransactionEntry on Transaction_Entry__c (before insert){
    if(Trigger.isBefore){
        if(Trigger.isInsert){
     		TransactionEntryTriggerHelper.checkContactLimits(Trigger.new);	       
        }
    }
}