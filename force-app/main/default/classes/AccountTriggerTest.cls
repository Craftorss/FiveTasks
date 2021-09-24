@isTest
public class AccountTriggerTest {
    @isTest
    public static void AccountInsert_WithBilling(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                                '[{"location": {"lat": 37.422476, "lng": -122.084249}}]', 
                                                              null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account acc = new Account(Name='das', BillingStreet = '310 Constitution Place Austin, TX 78767 USA',
                                BillingState = 'TX', BillingCity = 'Austin', BillingCountry = 'USA'
                                );
        Test.startTest();
        insert acc;
        Test.stopTest();
        Account updAcc = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :acc.Id];
        system.assertEquals(37.422476, updAcc.Billing_Location__Latitude__s, 'Latitude not as expected');
        system.assertEquals(-122.084249, updAcc.Billing_Location__Longitude__s, 'Longitude not as expected');
    }
    public static void AccountInsert_WithoutBilling(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                                '[{"location": {"lat": 37.422476, "lng": -122.084249}}]', 
                                                              null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account acc = new Account(Name='das');
        Test.startTest();
        insert acc;
        Test.stopTest();
        Account updAcc = [SELECT Billing_Location__Latitude__s, Billing_Location__Longitude__s FROM Account WHERE Id = :acc.Id];
        system.assertEquals(null, updAcc.Billing_Location__Latitude__s, 'Latitude should be null');
        system.assertEquals(null, updAcc.Billing_Location__Longitude__s, 'Longitude should be null');
    }
}
