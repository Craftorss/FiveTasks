public with sharing class AccountEditControllerExtension {
    public Account acct;
    public List<Contact> dynamicContacts;

    public AccountEditControllerExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        this.dynamicContacts = [SELECT FirstName, LastName 
                                FROM Contact 
                                WHERE AccountId = :this.acct.Id
                                ];
        this.dynamicContacts = this.dynamicContacts.deepClone();
    }

    public void addLine(){
        this.dynamicContacts.add(new Contact());
    }

    public List<Contact> getDynamicContacts(){
        return this.dynamicContacts;
    }

    public void DeleteContact(){
        String gotIdString = Apexpages.currentpage().getParameters().get('contactId');
        Id gotId = Id.valueOf(gotIdString);
        Integer selectedContactIndex;
        for (Integer i = 0; i < this.dynamicContacts.size(); i++) {
            if(this.dynamicContacts[i].Id == gotId){
                selectedContactIndex = i;
                break;
            }
        }
        this.dynamicContacts.remove(selectedContactIndex);
    }

    public PageReference save(){
        Account acc = new Account(Name = this.acct.Name, BillingPostalCode = this.acct.BillingPostalCode, 
                                  BillingStreet= this.acct.BillingStreet, BillingState = this.acct.BillingState,
                                  BillingCountry = this.acct.BillingCountry
                                 );
        
        Savepoint savePoint = Database.setSavepoint();
        PageReference pageRef = null;
        try {
            insert acc;
            for (Contact con : this.dynamicContacts) {
                con.AccountId = acc.Id;
            }
            insert dynamicContacts;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Work done succesfully!'));
            pageRef = new PageReference('/'+acc.Id);
            pageRef.setRedirect(true);
        } catch (DmlException ex) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(savePoint);
        }
        return pageRef;
    }
}
