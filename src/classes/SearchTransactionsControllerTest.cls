/*
  *  Purpose         :    Test class for SearchTransactionsController
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/16
  *  Revision Logs   :    V_1.0 - Created - 2022/10/16
*/
@isTest
public class SearchTransactionsControllerTest {
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
    @isTest
    public static void testGetTransactionRecords(){
        Test.startTest();
        Contact objContact = [Select Id, Account_Number__c from Contact LIMIT 1];
        Transaction_Entry__c objEntry = [SELECT Id, Name FROM Transaction_Entry__c LIMIT 1];
        
        SearchTransactionsController objSearchTransaction = new SearchTransactionsController();
        objSearchTransaction.minAmount = 1;
        objSearchTransaction.maxAmount = 1000;
        objSearchTransaction.startDate = Date.Today()-1;
        objSearchTransaction.endDate = Date.Today()+1;
        objSearchTransaction.entryName = objEntry.Name;
        objSearchTransaction.status = 'Completed';
        objSearchTransaction.accNumber = objContact.Account_Number__c;
        objSearchTransaction.getTransactionRecords();
        Test.stopTest();
        
        List<SelectOption> listOptions = objSearchTransaction.getItems();
        System.assertEquals(3, listOptions.size());
        List<Transaction_Entry__c> listEntry = [SELECT Id, Amount__c FROM Transaction_Entry__c WHERE Amount__c >= 100   AND Amount__c <= 600];
        System.assertEquals(5, listEntry.size());
    }
}