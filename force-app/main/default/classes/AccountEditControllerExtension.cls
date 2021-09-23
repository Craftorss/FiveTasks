public with sharing class AccountEditControllerExtension {
    public Account acct {get; set;}
    public List<Contact> dynamicContacts {get; set;}
    public String index {get; set;}

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

    public void deleteContact(){
        this.dynamicContacts.remove(Integer.valueOf(this.index));
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
            pageRef = new PageReference('/'+acc.Id);
            pageRef.setRedirect(true);
        } catch (DmlException ex) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(savePoint);
        }
        return pageRef;
    }
}