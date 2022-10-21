/*
  *  Purpose         :    Helper class for Transaction Entry
  *  Created By      :    Vishal Tourani
  *  Created Date    :    2022/10/08
  *  Revision Logs   :    V_1.0 - Created - 2022/10/08
*/
public class TransactionEntryTriggerHelper{

    /*
      * Created By    :    Vishal Tourani
      * Purpose       :    Method to check Contact Limits
      * Params        :    List<Transaction_Entry__c> newList
      * Return        :    Void
    */
    public static void checkContactLimits(List<Transaction_Entry__c> newList){
        Set<Id> setContactId = new Set<Id>();     
        
        for(Transaction_Entry__c newEntry : newList){
            if(newEntry.Type__c == 'Debit'){
                setContactId.add(newEntry.Contact__c);
            }
        }

        if(!setContactId.isEmpty()){
        Map<Id, Contact> mapContact = new Map<Id, Contact>([Select Id, Transaction_Limit__r.Maximum_Debit_Allowed_per_Day__c, 
                                                            Transaction_Limit__r.Maximum_Debit_Allowed_per_Month__c,Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c,
                                                            Transaction_Limit__r.Maximum_Transactions_Allowed_per_Month__c from Contact 
                                                            where Id IN :setContactId AND Transaction_Limit__r.Id != null]);

        //Getting Records to check per day debit and transaction limit
        List<AggregateResult> listPerDay = [Select SUM(Amount__c) Amount_Total, COUNT(ID) Count_Entry, Contact__r.Id idContact from Transaction_Entry__c 
                                            where Transaction_Date__c = TODAY AND Status__c != 'Cancelled' AND Type__c = 'Debit' Group By Contact__r.Id];
        Map<Id, Decimal> mapContactIdWithPerDayDebit = new Map<Id, Decimal>();
        Map<Id, Decimal> mapContactIdWithPerDayTransaction = new Map<Id, Decimal>();
        for(AggregateResult perDay : listPerDay){
            mapContactIdWithPerDayDebit.put((Id)perDay.get('idContact'), (Decimal)perDay.get('Amount_Total'));
            mapContactIdWithPerDayTransaction.put((Id)perDay.get('idContact'), (Decimal)perDay.get('Count_Entry'));
        }

        //Getting Records to check per month debit and transaction limit
        List<AggregateResult> listPerMonth = [Select SUM(Amount__c) Amount_Total, COUNT(ID) Count_Entry, Contact__r.Id idContact from Transaction_Entry__c 
                                              where Transaction_Date__c = THIS_MONTH AND Status__c != 'Cancelled' AND Type__c = 'Debit' Group By Contact__r.Id];
        Map<Id, Decimal> mapContactIdWithPerMonthDebit = new Map<Id, Decimal>();
        Map<Id, Decimal> mapContactIdWithPerMonthTransaction = new Map<Id, Decimal>();
        for(AggregateResult perMonth : listPerMonth){
            mapContactIdWithPerMonthDebit.put((Id)perMonth.get('idContact'), (Decimal)perMonth.get('Amount_Total'));
            mapContactIdWithPerMonthTransaction.put((Id)perMonth.get('idContact'), (Decimal)perMonth.get('Count_Entry'));
        }

        for(Transaction_Entry__c newEntry : newList){
            Decimal perDayDebitLimit = mapContact.get(newEntry.Contact__c).Transaction_Limit__r.Maximum_Debit_Allowed_per_Day__c;
            Decimal perDayTransactionLimit = mapContact.get(newEntry.Contact__c).Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c;
            Decimal perMonthDebitLimit = mapContact.get(newEntry.Contact__c).Transaction_Limit__r.Maximum_Debit_Allowed_per_Month__c;
            Decimal perMonthTransactionLimit = mapContact.get(newEntry.Contact__c).Transaction_Limit__r.Maximum_Transactions_Allowed_per_Month__c;

            Decimal perDayDebitDone = mapContactIdWithPerDayDebit.get(newEntry.Contact__c);
            Decimal perDayTransactionDone = mapContactIdWithPerDayTransaction.get(newEntry.Contact__c);
            Decimal perMonthDebitDone = mapContactIdWithPerMonthDebit.get(newEntry.Contact__c);
            Decimal perMonthTransactionDone = mapContactIdWithPerMonthTransaction.get(newEntry.Contact__c);

            //Checking per day debit limit
            if(perDayDebitDone != null){
                if(perDayDebitLimit < (perDayDebitDone + newEntry.Amount__c)){
                    newEntry.addError('You have exceeded per day Debit limit');        
                }
                else{
                    mapContactIdWithPerDayDebit.put(newEntry.Contact__c, perDayDebitDone + newEntry.Amount__c);
                }
            }
            else{
                mapContactIdWithPerDayDebit.put(newEntry.Contact__c, newEntry.Amount__c);
            }

            //Checking per day transaction limit
            if(perDayTransactionDone != null){
                if(perDayTransactionLimit == perDayTransactionDone){
                    newEntry.addError('You have exceeded per day Transaction limit');        
                }
                else{
                    mapContactIdWithPerDayTransaction.put(newEntry.Contact__c, perDayTransactionDone+1);
                }
            }
            else{
                mapContactIdWithPerDayTransaction.put(newEntry.Contact__c, 1);
            }

            //Checking per month debit limit
            if(perMonthDebitDone != null){
                if(perMonthDebitLimit < (perMonthDebitDone + newEntry.Amount__c)){
                    newEntry.addError('You have exceeded per month Debit limit');        
                }
                else{
                    mapContactIdWithPerMonthDebit.put(newEntry.Contact__c, perMonthDebitDone+newEntry.Amount__c);
                }
            }
            else{
                mapContactIdWithPerMonthDebit.put(newEntry.Contact__c, newEntry.Amount__c);
            }

            //Checking per month transaction limit
            if(perMonthTransactionDone != null){
                if(perMonthTransactionLimit == perMonthTransactionDone){
                    newEntry.addError('You have exceeded per month Transaction limit');        
                }
                else{
                    mapContactIdWithPerMonthTransaction.put(newEntry.Contact__c, perMonthTransactionDone+1);
                }
            }
            else{
                mapContactIdWithPerMonthTransaction.put(newEntry.Contact__c, 1);    
            }     
        }
        }
    }
}