import { api, LightningElement, track, wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions'
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import AccountId_FIELD from '@salesforce/schema/Opportunity.AccountId';
import saveAccountAndContacts from '@salesforce/apex/UpdateCompanyInformationCtrl.saveAccountAndContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import refreshApex from '@salesforce/apex'

export default class UpdateCompanyInformation extends LightningElement {
    @api
    recordId
    account
    contacts
    error

    opportunityAccountId
    @wire(getRecord, {recordId: '$recordId', fields: AccountId_FIELD})
    wiredRecord({ data }) {
        this.opportunityAccountId = getFieldValue(data, AccountId_FIELD)
    }

    handleAccountChange(event){
        this.account = event.detail;
        console.log(JSON.stringify(this.account))
    }
    handleContactsChange(event){
        this.contacts = event.detail;
    }

    closeAction(){
        this.dispatchEvent(
            new CloseActionScreenEvent()
        );
    }
    
    saveAction(){
        console.log(this.account)
        saveAccountAndContacts({accountJson: JSON.stringify(this.account), contactsJson: JSON.stringify(this.contacts)})
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Successfully updated company information',
                variant: 'success'
            }));
            let toRefreshClasses = this.template.querySelectorAll('.toRefresh');
            try{
                toRefreshClasses.forEach(element => {
                    element.refresh(); 
                });
            }catch(err){
                console.log(err)
            }
           
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: error.statusText,
                message: error.body.message,
                variant: 'error'
            }));
        })
    }
}