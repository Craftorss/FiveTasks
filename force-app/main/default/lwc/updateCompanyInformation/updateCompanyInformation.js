import { api, LightningElement, track, wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions'
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import AccountId_FIELD from '@salesforce/schema/Opportunity.AccountId';
export default class UpdateCompanyInformation extends LightningElement {
    @api
    recordId
    
    account

    opportunityAccountId
    @wire(getRecord, {recordId: '$recordId', fields: AccountId_FIELD})
    wiredRecord({ data }) {
        this.opportunityAccountId = getFieldValue(data, AccountId_FIELD)
    }

    handleAccountChange(event){
        this.account = event.detail;
        console.log('Event catched');
        console.log(event.detail);
    }
    closeAction(){
        this.dispatchEvent(
            new CloseActionScreenEvent()
        );
    }
}