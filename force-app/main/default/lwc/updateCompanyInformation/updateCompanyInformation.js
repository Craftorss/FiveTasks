import { api, LightningElement, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions'

export default class UpdateCompanyInformation extends LightningElement {
    account = {
        name:'AccNAME', 
        billingStreet:'Michigan Avenue here we are',
        biilingPostalCode:'60601',
        billingState:'IL',
        billingCountry:'USA'
    }

    closeAction(){
        this.dispatchEvent(
            new CloseActionScreenEvent()
        );
    }
}