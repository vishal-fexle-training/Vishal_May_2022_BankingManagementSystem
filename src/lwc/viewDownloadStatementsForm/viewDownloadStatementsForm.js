import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTransactions from '@salesforce/apex/ViewDownloadStatementsController.getTransaction';
import sendTransactionEmailAttachment from '@salesforce/apex/ViewDownloadStatementsController.sendTransactionEmailAttachment';

export default class viewDownloadStatementsForm extends LightningElement {
    @api recordId;
    @track stDate;
    @track edDate;
    @track gapBetweenDate;
    @track stDateShow = false;
    @track edDateShow = false;
    @track showRecords = false;
    @track disableButton = true;

    handleDateChange(event){
        const dateName = event.target.name;

        if(event.target.value != null && event.target.value != ''){
            if(dateName === 'startDate'){
                this.stDate = new Date(event.target.value);
                this.stDateShow = true;
            }
            else if(dateName === 'endDate'){
                this.edDate = new Date(event.target.value);
                this.edDateShow = true;
            }
        }
        else{
            this.stDateShow = false;
            this.edDateShow = false;
        }

        if(this.stDateShow && this.edDateShow){
            this.gapBetweenDate = this.stDate - this.edDate;
            this.gapBetweenDate = -(parseInt(this.gapBetweenDate/ (1000*60*60*24)));

            if(this.gapBetweenDate > 183){
                const toastEvent = new ShowToastEvent({
                    title: 'Invalid Date',
                    message: 'Duration can’t be more than 6 months.',
                    variant: 'warning'
                });
                this.dispatchEvent(toastEvent);
            }
            else{
                this.disableButton = false;    
            }
        }
    }

    //Searching records after selecting valid dates
    @track colsTransactions = [{label:'Type', fieldName: 'Type__c'}, {label:'Amount', fieldName: 'Amount__c'}, {label:'Transaction_Date', fieldName: 'Transaction_Date__c'}];
    @track listTransactions;
    @track showButtons = false;

    handleSearchClick(){
        getTransactions({startDate : this.stDate, endDate : this.edDate, recId : this.recordId})
        .then((result) => {
            if(result.length == 0){
                const toastEvent = new ShowToastEvent({
                    title: 'Opps!',
                    message: 'There are no transactions to show in specified date.',
                    variant: 'success'
                });
                this.dispatchEvent(toastEvent);
            }
            else{
                this.showButtons = true;
                this.listTransactions = result; 
                
                this.totalRecords = result.length;
                this.pageSize = this.pageSizeOptions[0];
                this.paginationHelper();
            }
        })
    }

    handleDisplayRecords(){
        this.showRecords = true;
    }

    //For downloading CSV File of Transaction Records
    handleDownloadCSV(){
        let rowEnd = '\n';
        let csvString = '';

        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.listTransactions.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        
        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for(let i=0; i < this.listTransactions.length; i++){
            let colValue = 0;

            // validating keys in data
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if(colValue > 0){
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.listTransactions[i][rowKey] === undefined ? '' : this.listTransactions[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Statement.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }

    //For downloading PDF File of Transaction Records
    handleDownloadPDF(){
        let completeUrl = window.location.href;
        let requiredUrl = completeUrl.substring(0, completeUrl.indexOf(".com/"));
        let stDateString = this.stDate.toISOString().slice(0, 10);
        let edDateString = this.edDate.toISOString().slice(0, 10);
        requiredUrl = requiredUrl.concat('.com/apex/generateTransactionPdf?id='+this.recordId+'&fromDate='+stDateString+'&toDate='+edDateString);

        window.open(requiredUrl);
    }

    //For send PDF File of Transaction Records through mail
    handleEmailStatements(){
        sendTransactionEmailAttachment({startDate : this.stDate, endDate : this.edDate, contactId : this.recordId})

        const toastEvent = new ShowToastEvent({
            title: 'Request Processed',
            message: 'You can now check your Email',
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);
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