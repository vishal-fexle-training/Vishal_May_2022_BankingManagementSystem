/*
  *  Purpose         :    Test class for SearchTransactionsController
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/17
  *  Revision Logs   :    V_1.0 - Created - 2022/10/17
*/
@isTest
public class ViewDownloadStatementsControllerTest {
	
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
        List<Transaction_Entry__c> listEntry = ViewDownloadStatementsController.getTransaction(Date.Today()-1, Date.Today()+1, objContact.Id);
        Test.stopTest();
        System.assertEquals(5, listEntry.size());
    }
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    To Csv file generation of Transaction records
      * Params        :    Void
      * Return        :    Void
    */
    @isTest
    public static void testGetTransactionCsv(){
        Test.startTest();
        Contact objContact = [Select Id, Account_Number__c from Contact LIMIT 1];
        List<Transaction_Entry__c> listEntry = ViewDownloadStatementsController.getTransaction(Date.Today()-1, Date.Today()+1, objContact.Id);
        ViewDownloadStatementsController.getTransactionCsv();
        Test.stopTest();
    }
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    To Csv file generation of Transaction records
      * Params        :    Void
      * Return        :    Void
    */
    @isTest
    public static void testSendTransactionEmailAttachment(){
        Test.startTest();   
        Contact objContact = [Select Id, Account_Number__c from Contact LIMIT 1];
        ViewDownloadStatementsController.sendTransactionEmailAttachment((Date.Today()-1).format(), (Date.Today()+1).format(), objContact.Id);
        Test.stopTest();
    }
}