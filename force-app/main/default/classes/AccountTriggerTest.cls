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
        system.assertEquals(37.422476, acc.Billing_Location__Latitude__s, 'Latitude not as expected');
        system.assertEquals(-122.084249, acc.Billing_Location__Longitude__s, 'Longitude not as expected');
    }
}
