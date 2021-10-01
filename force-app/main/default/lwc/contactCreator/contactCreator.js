import { LightningElement } from 'lwc';
import FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import LAST_NAME from '@salesforce/schema/Contact.LastName';
import EMAIL from '@salesforce/schema/Contact.Email';
import CONTACT_OBJECT from '@salesforce/schema/Contact'

const fields = [FIRST_NAME, LAST_NAME, EMAIL]
const objectApiName = CONTACT_OBJECT
export default class ContactCreator extends LightningElement {
    fields = fields
    objectApiName = objectApiName

    handleSuccess(event){
        this.dispatchEvent(new ShowToastEvent({
            title: 'Contact created',
            message: 'Record Id: ' + event.detail.id,
            variant: 'success'
        }));
    }
}