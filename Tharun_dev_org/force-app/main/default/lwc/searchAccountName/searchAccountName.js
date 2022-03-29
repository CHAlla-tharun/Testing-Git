import { LightningElement,track,wire,api } from 'lwc';
import getAccountList from '@salesforce/apex/AccountSearchApex.getAccountList';

export default class SearchAccountName extends LightningElement {
     accountName='';
     @track selectedRecords = [];
     @api value = "";
    @track label = "";
    // @track accuntRecord;
     @track accountList= [];
     @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @wire (getAccountList,{
        searchKey:'$accountName'})
        retrieveAccounts({error, data}){
            if(data)
            {
                this.accountList=data;          
            }
            else if(error){
            }
        }
        setSelectedRecord(event) {
            var recId = event.currentTarget.dataset.id;
            var selectName = event.currentTarget.dataset.name;
            let newsObject = { 'recId' : recId ,'recName' : selectName };
            this.selectedRecords.push(newsObject);
            this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            let selRecords = this.selectedRecords;
            this.template.querySelectorAll('lightning-input').forEach(each => {
                each.value = '';
            });
            const selectedEvent = new CustomEvent('selected', { detail: {selRecords}, });
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
        }
          //Method to handle selected options in listbox
    optionsClickHandler(event) {
        const value = event.target.closest('li').dataset.value;
        const label = event.target.closest('li').dataset.label;
        this.setValues(value, label);
        this.toggleOpenDropDown(false);
        const detail = {};
        detail["value"] = value;
        detail["label"] = label;
        this.dispatchEvent(new CustomEvent('change', { detail: detail }));
    }
  
    get isValueSelected() 
    {
        return(this.label && this.label== ? true :false);
    }
       
    searchAccountAction(event){
        this.accountName = event.target.value;
        event.target.selectionStart = 0 ;
        if(event.target.value){
           event.target.selectionStart = event.target.value.toString().length ;
        }else{
           event.target.selectionEnd = 0 ;
        }
        // this.accountName=event.target.value;
        // if(this.accountName!=''){
        //     getAccountList({
        //         searchKey:this.accountName
        //     })
            // .then(result => {
            //     this.accoountRecord = result;
            // }
            // window.clearTimeout(this.delayTimeout);
            // this.delayTimeout = setTimeout(() => {
            //     this.accountName = searchString;
            // }, DELAY);
    }
}