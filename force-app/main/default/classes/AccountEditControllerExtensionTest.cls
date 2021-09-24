@isTest
public class AccountEditControllerExtensionTest {
    @isTest
    public static void AddLine_AddingContact(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account ac = new Account(Name='TestAcc');
        insert ac;
        Contact con = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=ac.Id);
        insert con;
        PageReference testPage = Page.AccountEdit;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(ac.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        AccountEditControllerExtension mc = new AccountEditControllerExtension(sc);
        mc.addLine();
        System.assertEquals(2, mc.dynamicContacts.size(),'New Contact adding failed');
    }
    @isTest
    public static void DeleteContact_DeletingContact(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );
        Test.setMock(HttpCalloutMock.class, fakeResponse);                                                            
        Account ac = new Account(Name='TestAcc');
        insert ac;
        Contact con = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=ac.Id);
        insert con;
        PageReference testPage = Page.AccountEdit;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(ac.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        AccountEditControllerExtension mc = new AccountEditControllerExtension(sc);
        mc.index = '0';
        mc.deleteContact();
        System.assertEquals(0, mc.dynamicContacts.size(), 'Deleting Contact failed');
    }
    @isTest
    public static void  Save_SaveCorrect(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );  
        Test.setMock(HttpCalloutMock.class, fakeResponse);        
        Account ac = new Account(Name='TestAcc');
        insert ac;
        Contact con = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=ac.Id);
        insert con;
        PageReference testPage = Page.AccountEdit;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(ac.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        AccountEditControllerExtension mc = new AccountEditControllerExtension(sc);

        PageReference pg = mc.save();
        
        String url = pg.getUrl();
        String idStr = url.substringAfterLast('/');
        Id newAccId = Id.valueOf(idStr);
        System.assertNotEquals(null, newAccId, 'Creating new Account failed');
    }

    @isTest
    public static void  Save_SaveIncorrect(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );        
        Test.setMock(HttpCalloutMock.class, fakeResponse);  
        Account ac = new Account(Name='TestAcc');
        insert ac;
        Contact con = new Contact(FirstName='Test1FN', LastName='Test1LN', AccountId=ac.Id);
        insert con;
        PageReference testPage = Page.AccountEdit;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(ac.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        AccountEditControllerExtension mc = new AccountEditControllerExtension(sc);
        mc.acct.Name = null;
        PageReference pg = mc.save();
        System.assertEquals(null, pg, 'Creating new Account failed');
    }
}