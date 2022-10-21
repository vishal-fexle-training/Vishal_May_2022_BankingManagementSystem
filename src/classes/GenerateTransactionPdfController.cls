/*
  *  Purpose         :    Controller class for generateTransactionPdf Page
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/11
  *  Revision Logs   :    V_1.0 - Created - 2022/10/11
*/
public class GenerateTransactionPdfController {
    public List<Transaction_Entry__c> listTransactions {get;set;}
    public String stringStartDate {set;get;}
    public String stringEndDate {set;get;}
    public Contact recContact{set;get;}

    public GenerateTransactionPdfController()
    {
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=BankStatement.pdf');
    }

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to query Tranction Entries
      * Params        :    Void
      * Return        :    Void
    */
    public void generatePdf(){
        Id contactId = ApexPages.currentPage().getParameters().get('id');

        String newStartDate = ApexPages.currentPage().getParameters().get('fromDate');
        String newEndDate = ApexPages.currentPage().getParameters().get('toDate');

        Date startDate = Date.valueOf(newStartDate);
        Date endDate = Date.valueOf(newEndDate);

        stringStartDate = String.valueOf(date.newinstance(startDate.year(), startDate.month(), startDate.day()));
        stringEndDate = String.valueOf(date.newinstance(endDate.year(), endDate.month(), endDate.day()));

        listTransactions = [Select Type__c, Amount__c, Transaction_Date__c from Transaction_Entry__c 
                            where Transaction_Date__c > :startDate AND Transaction_Date__c < :endDate AND Contact__r.Id = :contactId
                            Order By Transaction_Date__c];

        recContact = [Select Id, Title, Name, Account_Number__c, Email from Contact where Id = :contactId];
    }
}