import { api, LightningElement, wire } from 'lwc';
import Name from '@salesforce/schema/Account.Name';
import BillingStreet from '@salesforce/schema/Account.BillingStreet';
import BillingPostalCode from '@salesforce/schema/Account.BillingPostalCode';
import BillingState from '@salesforce/schema/Account.BillingState';
import BillingCountry from '@salesforce/schema/Account.BillingCountry';
import getAccount from '@salesforce/apex/UpdateCompanyInformationCtrl.getAccount';

export default class AccountInformationForm extends LightningElement {
    accountIdStored
    error
    account

    fieldsLabels = {
        "Name": Name.fieldApiName, 
        "BillingStreet": BillingStreet.fieldApiName, 
        "BillingPostalCode": BillingPostalCode.fieldApiName,
        "BillingState": BillingState.fieldApiName,
        "BillingCountry": BillingCountry.fieldApiName
    };

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

    //Это явно как-то не так должно делаться
    handleChange(event){
        switch(event.target.name){
            case "name":
                this.account.Name = event.target.value
                this.onAccountChangeNotify()
                break;
            case "billingStreet":
                this.account.BillingStreet = event.target.value
                this.onAccountChangeNotify()
                break;
            case "billlingState":
                this.account.BillingState = event.target.value
                this.onAccountChangeNotify()
                break;
            case "billingCountry":
                this.account.BillingCountry = event.target.value
                this.onAccountChangeNotify()
                break;
            case "billingPostalCode":
                this.account.BillingPostalCode = event.target.value
                this.onAccountChangeNotify()
                break;
        }
    }

    onAccountChangeNotify(){
        const event = new CustomEvent('accountchange', {
            detail: this.account
        });
    }


}