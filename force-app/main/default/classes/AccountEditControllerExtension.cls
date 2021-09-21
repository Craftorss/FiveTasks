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
}
