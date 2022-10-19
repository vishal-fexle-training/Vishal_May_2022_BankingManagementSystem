public class SearchTransactionsController{    
    public Decimal minAmount {set;get;}
    public Decimal maxAmount {set;get;}
    public Date startDate {set;get;}
    public Date endDate {set;get;}
    public String entryName {set;get;}
    public String status {set;get;}
    public String accNumber {set;get;}
    public List<Transaction_Entry__c> listTransactions {set;get;}

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to get Transaction Status options
      * Params        :    Void
      * Return        :    List<SelectOption>
    */
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Pending', 'Pending'));
        options.add(new SelectOption('Completed', 'Completed'));
        options.add(new SelectOption('Cancelled', 'Cancelled'));
        return options;
    }

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to query Transaction records
      * Params        :    Void
      * Return        :    Void
    */
    public void getTransactionRecords()
    {
        String stringQuery = 'SELECT Name, Amount__c, Type__c, Transaction_Date__c, Status__c, Contact__r.Account_Number__c FROM Transaction_Entry__c WHERE Contact__r.Account_Number__c = \'' + accNumber + '\'' ;

        if((minAmount != null) && (maxAmount != null)){   
            stringQuery = stringQuery +' AND Amount__c >= '+ minAmount + ' AND Amount__c <= '+ maxAmount +' ';
        }
        
        if((startDate != null) && (endDate != null)){
            //Converting date to string 
            Date sDate = date.newinstance(startDate.year(), startDate.month(), startDate.day());
			String startDateString = String.valueOf(sDate);
            
            Date eDate = date.newinstance(endDate.year(), endDate.month(), endDate.day());
			String endDateString = String.valueOf(endDate);
            
            
            stringQuery = stringQuery +' AND Transaction_Date__c >= '+ startDateString + ' AND Transaction_Date__c <= '+ endDateString +' ';
        }
        
        if(!String.isBlank(entryName)){
            stringQuery = stringQuery +' AND Name = \'' + entryName + '\''  ;
        }
        
        if(status != null){
            stringQuery = stringQuery +' AND Status__c = \'' + status + '\''  ;
        }
		
        //Assigning SOQL to list
        listTransactions = Database.query(stringQuery);
    } 

    
}