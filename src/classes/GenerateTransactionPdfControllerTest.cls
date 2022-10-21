/*
  *  Purpose         :    Test class for GenerateTransactionPdfController
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/16
  *  Revision Logs   :    V_1.0 - Created - 2022/10/16
*/
@isTest 
public class GenerateTransactionPdfControllerTest {
   
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
      * Purpose       :    To test PDF generetes through apex page
      * Params        :    Void
      * Return        :    Void
    */
    @isTest static void testGeneratePdf(){
        Test.startTest();
        Contact objContact = [Select Id from Contact LIMIT 1];
        
        PageReference transactionPdfPage = new PageReference('/apex/generateTransactionPdf');
        transactionPdfPage.getParameters().put('id', objContact.Id);
        transactionPdfPage.getParameters().put('fromDate', '2022-10-01');
        transactionPdfPage.getParameters().put('toDate', '2022-10-30');
        
        Test.setCurrentPage(transactionPdfPage);
        
        GenerateTransactionPdfController objPdfController = new GenerateTransactionPdfController();
        objPdfController.generatePdf();
        Test.stopTest();

        List<Transaction_Entry__c> listTransactionEntry = [Select Id from Transaction_Entry__c Where Contact__r.Id = :objContact.Id];
        System.assertEquals(5, listTransactionEntry.size());
    } 
   
}