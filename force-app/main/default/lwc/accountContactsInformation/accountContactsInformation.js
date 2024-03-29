import { api, LightningElement, wire } from 'lwc';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/UpdateCompanyInformationCtrl.getContacts';
import refreshApex from '@salesforce/apex'

const columns = [
    {label: FIRST_NAME_FIELD.fieldApiName, fieldName:'FirstName', type:'text', editable: true},
    {label: LAST_NAME_FIELD.fieldApiName, fieldName:'LastName', type:'text', editable: true},
    {label: PHONE_FIELD.fieldApiName, fieldName:'Phone', type:'phone', editable: true},
    {label: EMAIL_FIELD.fieldApiName, fieldName:'Email', type:'email', editable: true},
    {type: 'button-icon', typeAttributes: {iconName:'utility:delete', variant:'border-filled', alternativeText:'Delete', name: 'Delete'}}
]

export default class AccountContactsInformation extends LightningElement {
    accountIdStored
    contacts
    error
    columns = columns
    draftValues = []

    @api
    get opportunityAccountId(){
        return this.accountIdStored
    }
    set opportunityAccountId(value){
        this.accountIdStored = value;
        this.getOpportunityAccountContacts();
    }

    getOpportunityAccountContacts(){
        getContacts({accountId: this.accountIdStored})
        .then( data => {
            this.error = undefined;
            this.contacts = data.map(item => {
                return {...item, rowIndex: Date.now().toString(36) + Math.random().toString(36).substr(2)}
            })
            console.log(this.contacts)
            this.onContactsChangeNotify();
        })
        .catch( error => {
             this.error = error;
             this.contacts = undefined;
             this.onContactsChangeNotify();
        })
     }

    @api 
    refresh(){
        //maybe for future uses
        console.log('refreshed contacts') 
    }

    handleCellChange(event){
        console.log(JSON.stringify(event.detail))
        let record = event.detail.draftValues[0]
        this.contacts = this.contacts.map(item => {
            return item.rowIndex == record.rowIndex ? {...item, ...record} : item
        })
        this.draftValues = [];
        this.onContactsChangeNotify()
    }
    handleRowAction(event){
        switch (event.detail.action.name) {
            case 'Delete':
                this.contacts = this.contacts.filter(item => item.rowIndex != event.detail.row.rowIndex)
                break;
            default:
                break;
        }
        console.log(this.contacts)
        this.onContactsChangeNotify()
    }
    handleAddContact(event){
        this.contacts = [...this.contacts, {rowIndex: Date.now().toString(36) + Math.random().toString(36).substr(2)}];
        this.onContactsChangeNotify()
    }

    onContactsChangeNotify(){
        let arr = [];
        if(this.contacts)
            this.contacts.forEach(element => {
                let {rowIndex, ...item} = element
                arr.push(item);
            });
        else
            arr = undefined;
        const event = new CustomEvent('contactschange',{
            detail: arr
        })
        this.dispatchEvent(event);
    }
}