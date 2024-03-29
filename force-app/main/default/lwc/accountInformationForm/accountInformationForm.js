import { api, LightningElement, track, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import BILLING_STREET_FIELD from '@salesforce/schema/Account.BillingStreet';
import BILLING_POSTAL_CODE_FIELD from '@salesforce/schema/Account.BillingPostalCode';
import BILLING_STATE_FIELD from '@salesforce/schema/Account.BillingState';
import BILLING_COUNTRY_FIELD from '@salesforce/schema/Account.BillingCountry';
import getAccount from '@salesforce/apex/UpdateCompanyInformationCtrl.getAccount';
import refreshApex from '@salesforce/apex'

const fieldsLabels = {
    "Name": NAME_FIELD.fieldApiName, 
    "BillingStreet": BILLING_STREET_FIELD.fieldApiName, 
    "BillingPostalCode": BILLING_POSTAL_CODE_FIELD.fieldApiName,
    "BillingState": BILLING_STATE_FIELD.fieldApiName,
    "BillingCountry": BILLING_COUNTRY_FIELD.fieldApiName
};

export default class AccountInformationForm extends LightningElement {
    accountIdStored
    error
    account
    fieldsLabels = fieldsLabels;

    @api
    get opportunityAccountId(){
        return this.accountIdStored
    }
    set opportunityAccountId(value){
        this.accountIdStored = value;
        this.getAccountInfo();
    }

    getAccountInfo(){
        console.log(this.accountIdStored)
        getAccount({accountId: this.accountIdStored})
        .then(data => {
            console.log(data);
            this.account = data;
            this.error = undefined;
            this.onAccountChangeNotify();
        })
        .catch(error => {
            console.log(error);
            this.error = error;
            this.account = undefined;
            this.onAccountChangeNotify();
        })
    }
    
    @api 
    refresh(){
        //maybe for future uses
        console.log('refreshed acc') 
    }

    handleChange(event){
        this.account[event.target.name] = event.target.value;
        this.onAccountChangeNotify()
    }

    onAccountChangeNotify(){
        const event = new CustomEvent('accountchange', {
            detail: this.account
        });
        this.dispatchEvent(event);
    }
}