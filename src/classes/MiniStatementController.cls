/*
  *  Purpose         :    Controller class for miniStatement Component
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/10
  *  Revision Logs   :    V_1.0 - Created - 2022/10/10
*/
public class MiniStatementController {

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to query Tranction Entries
      * Params        :    List<Transaction_Entry__c>
      * Return        :    Void
    */
    @AuraEnabled(cacheable=true)
    public static List<Transaction_Entry__c> getTransaction(Integer num, String recId){
        return [Select Id, Name, Type__c, Amount__c, Transaction_Date__c from Transaction_Entry__c where Contact__r.Id = :recId AND Status__c != 'Cancelled' Order By Transaction_Date__c Limit :num];
    }
}