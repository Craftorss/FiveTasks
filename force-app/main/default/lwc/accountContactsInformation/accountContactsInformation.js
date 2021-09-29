import { api, LightningElement, track } from 'lwc';
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Phone from '@salesforce/schema/Contact.Phone';
import Email from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/UpdateCompanyInformationCtrl.getContacts';

const columns = [
    {label: FirstName.fieldApiName, fieldName:'FirstName', type:'text', editable: true},
    {label: LastName.fieldApiName, fieldName:'LastName', type:'text', editable: true},
    {label: Phone.fieldApiName, fieldName:'Phone', type:'phone', editable: true},
    {label: Email.fieldApiName, fieldName:'Email', type:'email', editable: true},
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
            let iter = -1
            this.contacts = data.map(item => {
                iter++
                return {...item, rowIndex: iter}
            })
            console.log(this.contacts)
            this.onContactsChangeNotify();
       })
       .catch( error => {
            this.error = error;
            this.contacts = undefined;
            console.log(error);
       })
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
    //Как работая с lightning-datatable получить индекс строки? 
    /*
    Или же как не добавляя, в данном случае контакта, в орг. получить ему Id
    Ведь save нужно делать или не делать после всех изменений.
    Или же такие 'танцы с бубнами', где я сам добавляю id в object,
    что в компоненте иметь возможность всовывать в datatable запись с уникальным полем
    (для работы с lwc компонентами из lwc library, если самому таблицу писать - есть 
    <template iterator> (даже не index, а временный uid))
     */
    onContactsChangeNotify(){
        let arr = [];
        this.contacts.forEach(element => {
            let {rowIndex, ...item} = element
            arr.push(item);
        });
        const event = new CustomEvent('contactschange',{
            detail: arr
        })
        this.dispatchEvent(event);
    }
}