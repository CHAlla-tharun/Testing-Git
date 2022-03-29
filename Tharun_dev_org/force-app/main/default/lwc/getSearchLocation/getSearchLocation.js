import { LightningElement, track, wire } from 'lwc';
import getRecords from '@salesforce/apex/GetSearch.getRecords';
export default class getSearchLocation extends LightningElement {
  @track tharu = [];
  searchValue = '';
  @track page = 1; //this will initialize 1st page
   data ; //data to be displayed in the table
  @track startingRecord = 1; //start record position per page
  @track endingRecord = 0; //end record position per page
  @track pageSize = 5; //default value we are assigning
  @track totalRecountCount = 0; //total record count received from all retrieved records
  @track totalPage = 0; //total number of page is needed to display all records
  // @track url = '/sfc/servlet.shepherd/version/download/0685j000006IL3LAAW'
  handleSearch(event) {
    this.searchValue = event.target.value;
   console.log('name', this.searchValue);
  }
  submitDetails() {
 getRecords({value:this.searchValue})
      .then(result => {
        // console.log('Result ==> '+JSON.stringify(result));
        var records = result.listings;
        //  console.log('Records ==> '+JSON.stringify(records));
        var isData = result.recordIdToCvid;
        //  console.log('Data ==> '+JSON.stringify(isData));
        for (let lis in records) {
          for (let key in isData) {
            if (records[lis].Id == key) {
              this.tharu.push({
                Id: records[lis].Id,
                Name: records[lis].Name,
                state: records[lis].State2__c,
                Category: records[lis].Category__c,
                Duration: records[lis].Duration__c,
                BasePrice: records[lis].BasePrice__c,
                url : isData[key]
              })
            }
          }
        }
        console.log('Result ==> : ' + JSON.stringify(this.tharu));
        this.totalRecountCount = data.length; //here it is 23
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); //here it is 5
        this.data = this.tharu.slice(0, this.recordSize);
            console.log('data ==> : '+JSON.stringify(this.data)) ;  
            this.end = this.recordSize;
        })
  }
  previousHandler() {
    if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1`
        this.displayRecordPerPage(this.page);
    }
}

//clicking on next button this method will be called
nextHandler() {
    if((this.page<this.totalPage) && this.page !== this.totalPage){
        this.page = this.page + 1; //increase page by 1
        this.displayRecordPerPage(this.page);            
    } 
    this.startingRecord = ((page -1) * this.pageSize) ;
    this.endingRecord = (this.pageSize * page);

    this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                        ? this.totalRecountCount : this.endingRecord; 

    this.data = this.tharu.slice(this.startingRecord, this.endingRecord);   
    this.startingRecord = this.startingRecord + 1;         
}

}