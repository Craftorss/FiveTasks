public with sharing class AccountEditControllerExtension {
    private Account acct;
    public List<Contact> dynamicContacts;

    public AccountEditControllerExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        this.dynamicContacts = [SELECT FirstName, LastName FROM Contact WHERE AccountId = :this.acct.Id];
    }
    public void addLine(){
        this.dynamicContacts.add(new Contact(AccountId = this.acct.Id));
    }
    public List<Contact> getDynamicContacts(){
        return this.dynamicContacts;
    }
}
