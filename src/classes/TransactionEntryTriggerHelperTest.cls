/*
  *  Purpose         :    Test class for TransactionEntryTriggerHelper
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/16
  *  Revision Logs   :    V_1.0 - Created - 2022/10/16
*/
@isTest
public class TransactionEntryTriggerHelperTest {
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    It will check if per day transaction limit exceeds
      * Params        :    Void
      * Return        :    Void
    */
    @isTest static void checkPerDayTransactionLimit(){
        Test.startTest();
        
        Transaction_Limit__c testLimit = new Transaction_Limit__c(Name = 'VIP', Maximum_Debit_Allowed_per_Transaction__c = 2000, 
                                                                  Maximum_Debit_Allowed_per_Day__c = 2000, Maximum_Debit_Allowed_per_Month__c = 10000, 
                                                                  Maximum_Transactions_Allowed_per_Day__c = 1, Maximum_Transactions_Allowed_per_Month__c = 2);  
        Insert testLimit;
        
        Contact testContact = new Contact(FirstName = 'Contact Record for', LastName = 'Test', Status__c = 'Active', Available_Balance__c = 500000, Transaction_Limit__c = testLimit.Id, Email = 'test@fexle.com');
    	Insert testContact;
        Transaction_Entry__c testEntry1 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 100);
        Insert testEntry1;
        Transaction_Entry__c testEntry2 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 200);

        try 
        {
            Insert testEntry2;
        }
        catch(Exception e){
            Boolean isErrorReceived = false;
            if(e.getMessage().contains('You have exceeded per day Transaction limit')){
                isErrorReceived = true;
            }
            System.AssertEquals(true, isErrorReceived);
        }
        Test.stopTest();
    }
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    It will check if per day debit limit exceeds
      * Params        :    Void
      * Return        :    Void
    */
    @isTest static void checkPerDayDebitLimit(){
        Test.startTest();
        Transaction_Limit__c testLimit = new Transaction_Limit__c(Name = 'VIP', Maximum_Debit_Allowed_per_Transaction__c = 2000, 
                                                                  Maximum_Debit_Allowed_per_Day__c = 2000, Maximum_Debit_Allowed_per_Month__c = 10000, 
                                                                  Maximum_Transactions_Allowed_per_Day__c = 2, Maximum_Transactions_Allowed_per_Month__c = 2);  
        Insert testLimit;
        
        Contact testContact = new Contact(FirstName = 'Contact Record for', LastName = 'Test', Status__c = 'Active', Available_Balance__c = 500000, Transaction_Limit__c = testLimit.Id, Email = 'test@fexle.com');
    	Insert testContact;
        
        Transaction_Entry__c testEntry1 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 1000);
        Insert testEntry1;
        Transaction_Entry__c testEntry2 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 2000);
        
        try 
        {
            Insert testEntry2;
        }
        catch(Exception e){
            Boolean isErrorReceived = false;
            if(e.getMessage().contains('You have exceeded per day Debit limit')){
                isErrorReceived = true;
            }
            System.AssertEquals(true, isErrorReceived);
        }
        Test.stopTest();
    }
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    It will check if per month transaction limit exceeds
      * Params        :    Void
      * Return        :    Void
    */
    @isTest static void checkPerMonthTransactionLimit(){
        Test.startTest();
        
        Transaction_Limit__c testLimit = new Transaction_Limit__c(Name = 'VIP', Maximum_Debit_Allowed_per_Transaction__c = 2000, 
                                                                  Maximum_Debit_Allowed_per_Day__c = 2000, Maximum_Debit_Allowed_per_Month__c = 10000, 
                                                                  Maximum_Transactions_Allowed_per_Day__c = 3, Maximum_Transactions_Allowed_per_Month__c = 1);  
        Insert testLimit;
        
        Contact testContact = new Contact(FirstName = 'Contact Record for', LastName = 'Test', Status__c = 'Active', Available_Balance__c = 500000, Transaction_Limit__c = testLimit.Id, Email = 'test@fexle.com');
    	Insert testContact;
        Transaction_Entry__c testEntry1 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 100);
        Insert testEntry1;
        Transaction_Entry__c testEntry2 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 200);

        try 
        {
            Insert testEntry2;
        }
        catch(Exception e){
            Boolean isErrorReceived = false;
            if(e.getMessage().contains('You have exceeded per month Transaction limit')){
                isErrorReceived = true;
            }
            System.AssertEquals(true, isErrorReceived);
        }
        Test.stopTest();
    }
    
     /*
      * Created By    :    Vishal Tourani
      * Purpose       :    It will check if per month debit limit exceeds
      * Params        :    Void
      * Return        :    Void
    */
    @isTest static void checkPerMonthDebitLimit(){
        Test.startTest();
        Transaction_Limit__c testLimit = new Transaction_Limit__c(Name = 'VIP', Maximum_Debit_Allowed_per_Transaction__c = 20000, 
                                                                  Maximum_Debit_Allowed_per_Day__c = 20000, Maximum_Debit_Allowed_per_Month__c = 10000, 
                                                                  Maximum_Transactions_Allowed_per_Day__c = 2, Maximum_Transactions_Allowed_per_Month__c = 2);  
        Insert testLimit;
        
        Contact testContact = new Contact(FirstName = 'Contact Record for', LastName = 'Test', Status__c = 'Active', Available_Balance__c = 500000, Transaction_Limit__c = testLimit.Id, Email = 'test@fexle.com');
    	Insert testContact;
        
        Transaction_Entry__c testEntry1 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 8000);
        Insert testEntry1;
        Transaction_Entry__c testEntry2 = new Transaction_Entry__c(Contact__c = testContact.Id, Type__c = 'Debit', Transaction_Date__c = Date.Today(), Status__c = 'Completed', Amount__c = 6000);
        
        try 
        {
            Insert testEntry2;
        }
        catch(Exception e){
            Boolean isErrorReceived = false;
            if(e.getMessage().contains('You have exceeded per month Debit limit')){
                isErrorReceived = true;
            }
            System.AssertEquals(true, isErrorReceived);
        }
        Test.stopTest();
    }
}