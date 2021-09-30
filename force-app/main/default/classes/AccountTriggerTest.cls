//reworked Task 3
@isTest
public class AccountTriggerTest {
    @isTest
    public static void AccountInsert_WithBilling(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                                '[{"location": {"lat": 37.422476, "lng": -122.084249}}]', 
                                                              null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account account = new Account(Name='das', BillingStreet = '310 Constitution Place Austin, TX 78767 USA',
                                BillingState = 'TX', BillingCity = 'Austin', BillingCountry = 'USA'
                                );
        Test.startTest();
        insert account;
        Test.stopTest();
        Account updatedAccount = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :account.Id];
        system.assertEquals(37.422476, updatedAccount.Billing_Location__Latitude__s, 'Latitude not as expected');
        system.assertEquals(-122.084249, updatedAccount.Billing_Location__Longitude__s, 'Longitude not as expected');
    }
    public static void AccountInsert_WithoutBilling(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                                '[{"location": {"lat": 37.422476, "lng": -122.084249}}]', 
                                                              null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account account = new Account(Name='das');
        Test.startTest();
        insert account;
        Test.stopTest();
        Account updatedAccount = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :account.Id];
        system.assertEquals(null, updatedAccount.Billing_Location__Latitude__s, 'Latitude should be null');
        system.assertEquals(null, updatedAccount.Billing_Location__Longitude__s, 'Longitude should be null');
    }
    @isTest
    public static void AccountInsert_WithoutBillingRespError(){
        SingleRequestMock fakeResponse = new SingleRequestMock(500, 'INVALID_REQUEST', '', null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account account = new Account(Name='das', BillingStreet = '310 Constitution Place Austin, TX 78767 USA');
        Test.startTest();
        insert account;
        Test.stopTest();
        Account updatedAccount = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :account.Id];
        system.assertEquals(null, updatedAccount.Billing_Location__Latitude__s, 'Latitude should be null');
        system.assertEquals(null, updatedAccount.Billing_Location__Longitude__s, 'Longitude should be null');
    }
    @isTest
    public static void AccountUpdate_WithBilling(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                                '[{"location": {"lat": 37.422476, "lng": -122.084249}}]', 
                                                              null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account account = new Account(Name='das', BillingStreet = '310 Constitution Place Austin, TX 78767 USA',
                                        BillingState = 'TX', BillingCity = 'Austin', BillingCountry = 'USA', BillingPostalCode = 'SA'
                                    );
        insert account;
        Account insertedAccount = [SELECT BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                                    BillingCountry FROM Account
                                 ];
        insertedAccount.BillingStreet = '210 Constitution Place Austin, TX 78767 USA';
        Test.startTest();
            update insertedAccount;
        Test.stopTest();
        Account updatedAccount = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :account.Id];
        system.assertEquals(37.422476, updatedAccount.Billing_Location__Latitude__s, 'Latitude not as expected');
        system.assertEquals(-122.084249, updatedAccount.Billing_Location__Longitude__s, 'Longitude not as expected');
    }
    @isTest
    public static void AccountUpdate_RespSpoiledBody(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                                '[{"location": }]', 
                                                              null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account account = new Account(Name='das', BillingStreet = '310 Constitution Place Austin, TX 78767 USA',
                                        BillingState = 'TX', BillingCity = 'Austin', BillingCountry = 'USA'
                                    );
        insert account;
        Test.startTest();
            update account;
        Test.stopTest();
        Account updatedAccount = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :account.Id];
        system.assertEquals(null, updatedAccount.Billing_Location__Latitude__s, 'Latitude not as expected');
        system.assertEquals(null, updatedAccount.Billing_Location__Longitude__s, 'Longitude not as expected');
    }
}
