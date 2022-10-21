/*
  *  Purpose         :    Test class for MiniStatementController
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/16
  *  Revision Logs   :    V_1.0 - Created - 2022/10/16
*/
@isTest
public class MiniStatementControllerTest {
	/*
      * Created By    :    Vishal Tourani
      * Purpose       :    Setup method to create records
      * Params        :    Void
      * Return        :    Void
    */
    @testSetup 
    public static void setup(){
        Transaction_Limit__c testLimit = new Transaction_Limit__c(Name = 'VIP', Maximum_Debit_Allowed_per_Transaction__c = 2000, 
                                                                  Maximum_Debit_Allowed_per_Day__c = 2000, Maximum_Debit_Allowed_per_Month__c = 10000, 
                                                                  Maximum_Transactions_Allowed_per_Day__c = 6, Maximum_Transactions_Allowed_per_Month__c = 10);  
        Insert testLimit;
        Contact testContact = new Contact(FirstName = 'Contact Record', LastName = 'for Test', Status__c = 'Active', Available_Balance__c = 500000, Transaction_Limit__c = testLimit.Id, Email = 'test@fexle.com');
    	Insert testContact;
        
        List<Transaction_Entry__c> listTransactionEntry = new List<Transaction_Entry__c>(); 
        for(Integer i=100; i<600; i+=100){
        	Transaction_Entry__c testEntry = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Credit', Transaction_Date__c = Date.today(), Status__c = 'Completed', Amount__c = i);
            listTransactionEntry.add(testEntry);
        }
    	Insert listTransactionEntry;
    }
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    To test queried records
      * Params        :    Void
      * Return        :    Void
    */
    @isTest static void testGetTransaction(){
        Test.startTest();
        Contact objContact = [Select Id from Contact LIMIT 1];
        List<Transaction_Entry__c> listEntry = MiniStatementController.getTransaction(5, objContact.Id);
        System.AssertEquals(5, listEntry.size());
        Test.stopTest();
    }
}