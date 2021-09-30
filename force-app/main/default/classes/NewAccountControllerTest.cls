//reworked Task 1
@isTest
public with sharing class NewAccountControllerTest {
    @isTest
    public static void AddLine_AddingContact(){
        Account account = new Account(Name='TestAcc');
        insert account;
        Contact contact = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=account.Id);
        insert contact;
        PageReference testPage = Page.AccountNew;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(account.Id));
        NewAccountController myController = new NewAccountController();
        myController.addLine();
        System.assertEquals(2, myController.dynamicContacts.size(),'New Contact adding failed');
    }
    @isTest
    public static void DeleteContact_DeletingContact(){                                                          
        Account account = new Account(Name='TestAcc');
        insert account;
        Contact contact = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=account.Id);
        insert contact;
        PageReference testPage = Page.AccountNew;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(account.Id));
        NewAccountController myController = new NewAccountController();
        myController.index = '0';
        myController.deleteContact();
        System.assertEquals(0, myController.dynamicContacts.size(), 'Deleting Contact failed');
    }
    @isTest
    public static void  Save_SaveCorrect(){     
        Account account = new Account(Name='TestAcc');
        insert account;
        Contact contact = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=account.Id);
        insert contact;
        PageReference testPage = Page.AccountNew;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(account.Id));
        NewAccountController myController = new NewAccountController();
        PageReference pageReference = myController.save();
        String url = pageReference.getUrl();
        String idStr = url.substringAfterLast('/');
        Id newAccountId = Id.valueOf(idStr);
        System.assertNotEquals(null, newAccountId, 'Creating new Account failed');
    }

    @isTest
    public static void  Save_SaveIncorrect(){
        Account account = new Account(Name='TestAcc');
        insert account;
        Contact contact = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=account.Id);
        insert contact;
        PageReference testPage = Page.AccountNew;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(account.Id));
        NewAccountController myController = new NewAccountController();
        myController.account.Name = null;
        PageReference pageReference = myController.save();
        System.assertEquals(null, pageReference, 'Creating new Account failed');
    }
}
