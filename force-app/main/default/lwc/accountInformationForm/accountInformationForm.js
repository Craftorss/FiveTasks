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
    }

    wiredAccount
    @wire(getAccount, {accountId:'$accountIdStored'})
    wiredGetAccount(response){
        this.wiredAccount = response;
        const {data, error} = response
        if(data){
            this.account = {...data}
            this.error = undefined
        } else if(error){
            this.account = undefined
            this.error = error
        }
        this.onAccountChangeNotify();
    }
    
    @api 
    refresh(){

        console.log('refreshed acc') 
    }

    handleChange(event){
        switch(event.target.name){
            case "name":
                this.account.Name = event.target.value
                break;
            case "billingStreet":
                this.account.BillingStreet = event.target.value
                break;
            case "billingState":
                this.account.BillingState = event.target.value
                break;
            case "billingCountry":
                this.account.BillingCountry = event.target.value
                break;
            case "billingPostalCode":
                this.account.BillingPostalCode = event.target.value
                break;
        }
        this.onAccountChangeNotify()
    }

    onAccountChangeNotify(){
        const event = new CustomEvent('accountchange', {
            detail: this.account
        });
        this.dispatchEvent(event);
    }
}