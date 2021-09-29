import { api, LightningElement, track, wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions'
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import AccountId_FIELD from '@salesforce/schema/Opportunity.AccountId';
import saveAccountAndContacts from '@salesforce/apex/UpdateCompanyInformationCtrl.saveAccountAndContacts';
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
    }
    handleContactsChange(event){
        this.contacts = event.detail;
        console.log('Updated CONTACTS')
        console.log(this.contacts)
    }

    closeAction(){
        saveAccountAndContacts({accountJson: JSON.stringify(this.account), contactsJson: JSON.stringify(this.contacts)})
        .then(() => {
            this.dispatchEvent(
                new CloseActionScreenEvent()
            );
        })
        .catch(error => {
            this.error = error
        })
    }
}