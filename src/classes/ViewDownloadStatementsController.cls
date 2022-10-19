/*
  *  Purpose         :    Controller class for viewDownloadStatements Component
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/10
  *  Revision Logs   :    V_1.0 - Created - 2022/10/10
*/
public class ViewDownloadStatementsController{
    public static List<Transaction_Entry__c> listTransactions;

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to query Tranction Entries
      * Params        :    Date startDate, Date endDate, String recId
      * Return        :    List<Transaction_Entry__c>
    */
	@AuraEnabled(cacheable=true)
    public static List<Transaction_Entry__c> getTransaction(Date startDate, Date endDate, String recId){
        listTransactions = [Select Type__c, Amount__c, Transaction_Date__c from Transaction_Entry__c 
                            where Transaction_Date__c > :startDate AND Transaction_Date__c < :endDate AND Contact__r.Id = :recId
                            Order By Transaction_Date__c];
                             
        return listTransactions;
    }
    
    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to create CSV File of Transaction Entries
      * Params        :    Void
      * Return        :    Void
    */
    @AuraEnabled(cacheable=true)
    public static void getTransactionCsv(){
        String fileHeader = 'Type,Amount,Date\n';
        String completeFile = fileHeader;

        for(Transaction_Entry__c transactionEntry : listTransactions){
            String fileRows = transactionEntry.Type__c + ',' + transactionEntry.Amount__c + ',' + transactionEntry.Transaction_Date__c + '\n';
            completeFile = completeFile + fileHeader;
        }   
    }

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to send Email of Transaction Entries
      * Params        :    String startDate, String endDate, Id contactId
      * Return        :    Void
    */
    @AuraEnabled(cacheable=true)
    public static void sendTransactionEmailAttachment(String startDate, String endDate, Id contactId){
        PageReference transactionPdfPage = new PageReference('/apex/generateTransactionPdf');
        transactionPdfPage.getParameters().put('id', contactId);
        transactionPdfPage.getParameters().put('fromDate', startDate);
        transactionPdfPage.getParameters().put('toDate', endDate);
		Blob body;
        if(!test.isRunningTest()){
        	body = transactionPdfPage.getContent();    
        }
        else{
            Blob.valueOf('Test');
        }    	

        Messaging.EmailFileAttachment attachTransactionPdf = new Messaging.EmailFileAttachment();
        attachTransactionPdf.setContentType('application/pdf');
        attachTransactionPdf.setFileName('Transaction_Statement.pdf');
        attachTransactionPdf.setBody(body);

        Contact recContact = [Select Id, Name, Email, Account_Number__c from Contact where Id = :contactId];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string>{recContact.Email};
        String subject ='Transaction(s)';
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('Dear Customer,\nBelow is the Transaction file attached from date '+startDate+' to '+endDate+' of A/c no. '+recContact.Account_Number__c);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachTransactionPdf});

        Messaging.SendEmailResult [] emails = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}