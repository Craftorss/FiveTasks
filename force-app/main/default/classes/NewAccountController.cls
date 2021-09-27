public with sharing class NewAccountController {
    public Account account {get; set;}
    public List<Contact> dynamicContacts {get; set;}
    public String index {get; set;}

    public NewAccountController() {
        this.account = [SELECT Name, BillingStreet, BillingPostalCode, BillingState,
                                BillingCountry 
                        FROM Account 
                        WHERE Id = :ApexPages.currentPage().getParameters().get('id')
                        ];
        this.dynamicContacts = [SELECT FirstName, LastName 
                                FROM Contact 
                                WHERE AccountId = :this.account.Id
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
        Account accountBuff = new Account(Name = this.account.Name, BillingPostalCode = this.account.BillingPostalCode, 
                                  BillingStreet= this.account.BillingStreet, BillingState = this.account.BillingState,
                                  BillingCountry = this.account.BillingCountry
                                 );
        
        Savepoint savePoint = Database.setSavepoint();
        PageReference pageRef = null;
        try {
            insert accountBuff;
            for (Contact contact : this.dynamicContacts) {
                contact.AccountId = accountBuff.Id;
            }
            insert dynamicContacts;
            pageRef = new PageReference('/'+accountBuff.Id);
            pageRef.setRedirect(true);
        } catch (DmlException ex) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(savePoint);
        }
        return pageRef;
    }
}
