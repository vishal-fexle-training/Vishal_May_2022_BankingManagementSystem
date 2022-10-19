import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'; 
import getTransactions from '@salesforce/apex/MiniStatementController.getTransaction';
export default class MiniStatement extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @track value;
    @track selectedOption;
    @track showTable = false;
    @track listTransactions = [];
    totalRecords=0;
    colsTransactions = [{label:'Transaction Name', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, tooltip:'Name', target: '_blank'}}, 
                        {label:'Type', fieldName: 'Type__c'}, 
                        {label:'Amount', fieldName: 'Amount__c'}, 
                        {label:'Transaction_Date', fieldName: 'Transaction_Date__c'}];
    
    //Radio button for no. of records to query
    get radioOptions(){
        return [
            { label: '5' , value: '5'  },
            { label: '10', value: '10' },
            { label: '15', value: '15' },
            { label: '20', value: '20' },
            { label: '25', value: '25' },
        ];
    }

    handleRadioChange(event){
        this.selectedOption = event.detail.value;
        this.displayRecords();
    }

    //Getting records through Apex Class
    displayRecords(){
        getTransactions({num : this.selectedOption, recId : this.recordId})
        .then((result) => {
            var tempTransactionList  = []; 
            this.totalRecords = result.length;
            this.pageSize = this.pageSizeOptions[0]; 
            for (var i = 0; i < result.length; i++) {  
                let tempRecord = Object.assign({}, result[i]); //cloning object  
                tempRecord.linkName = "/" + tempRecord.Id;  
                tempTransactionList.push(tempRecord);  
            }
            this.listTransactions = tempTransactionList;
            this.showTable = true;
            this.paginationHelper();
        })
    }

    //Hyperlink to Transaction Entry records
    handleClick(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Transaction_Entry__c',
                recordId:event.target.name,
                actionName: 'view'
            }
        }).then(url => { window.open(url) });
    }

    //For Pagination
    pageSizeOptions = [5, 10, 15, 20, 25];
    listTransactionsToDisplay = [];
    totalPages;
    pageSize;
    pageNumber = 1;

    paginationHelper(){
        this.listTransactionsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.listTransactionsToDisplay.push(this.listTransactions[i]);
        }
    }

    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }

    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }

    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
}