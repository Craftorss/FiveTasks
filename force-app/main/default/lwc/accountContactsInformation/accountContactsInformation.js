import { api, LightningElement } from 'lwc';
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Phone from '@salesforce/schema/Contact.Phone';
import Email from '@salesforce/schema/Contact.Email';

const columns = [
    {label: FirstName.fieldApiName, fieldName:'firstName', editable: true},
    {label: LastName.fieldApiName, fieldName:'lastName', editable: true},
    {label: Phone.fieldApiName, fieldName:'phone', type:'phone', ditable: true},
    {label: Email.fieldApiName, fieldName:'email', type:'email', editable: true}
]

export default class AccountContactsInformation extends LightningElement {
    accountIdStored

    @api
    get opportunityAccountId(){
        return this.accountIdStored
    }
    set opportunityAccountId(value){
        this.accountIdStored = value;
    }
}