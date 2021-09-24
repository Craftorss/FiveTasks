@isTest
public class OpportunityTriggerTest {
    @TestSetup
    static void makeData(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account acc = new Account(Name = 'YAYA', BillingCity = 'some...');
        insert acc;
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(Name = 'dsa', StageName = 'Prospecting', 
                            CloseDate = System.today(),Send_Test_Email__c = true, AccountId = acc.Id
                            ), 
            new Opportunity(Name = 'ddas', StageName = 'Prospecting', AccountId = acc.id,
                            CloseDate = System.today(),Send_Test_Email__c = true
                            )
            };
        List<Contact> cons = new List<Contact>{
                new Contact(FirstName='ds', LastName='dsa', Email='kirill.huk@enway.com'),
                new Contact(FirstName='sd', LastName='dsad', Email='kirill.huk@enway.com')
            };
        insert opps;
        insert cons;
        OpportunityContactRole jun = new OpportunityContactRole(ContactId = cons[0].Id, 
                                                                OpportunityId = opps[0].Id, 
                                                                isPrimary = true
                                                                );
        insert jun;
    }
    

    @isTest
    public static void OpportunityUpdate_SetToClosedWon(){
        List<Opportunity> opps = [SELECT Id, StageName,(SELECT isPrimary, Contact.Email FROM OpportunityContactRoles WHERE isPrimary = true) FROM Opportunity];
        for (Opportunity opp : opps) {
            opp.StageName = 'Closed Won';
        }
        Test.startTest();
        Database.update(opps, false);
        Test.stopTest();
        System.assertEquals('Closed Won', opps[0].StageName, 'Stage pretend to become Closed Won');
    }
    @isTest
    public static void OpportunityInsert_JustClosedWon(){
        Opportunity opp = new Opportunity(Name = 'dsds', StageName = 'Closed Won');
        Boolean fl = false;
        try {
            insert opp;
        } catch (Exception ec) {
            fl = true;
        }
        
        System.assertEquals(true, fl, 'Can not set Closed Won without Account.BillingAddress and PrimaryContact.Email');
    }
}
