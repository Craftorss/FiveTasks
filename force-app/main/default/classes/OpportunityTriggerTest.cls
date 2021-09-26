@isTest
public class OpportunityTriggerTest {
    @TestSetup
    static void makeData(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        List<Account> accs = new List<Account>{
            new Account(Name = 'YAYAD', BillingCity = 'some...'),
            new Account(Name = 'YAYAS'),
            new Account(Name = 'YAYAZ', BillingCity = 'some...', BillingCountry = 'USA',
                        BillingPostalCode='CA', BillingState='California', BillingStreet='Some'
                        )
        };        
        insert accs;
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(Name = 'dsa', StageName = 'Prospecting', 
                            CloseDate = System.today(), AccountId = accs[0].Id
                            ), 
            new Opportunity(Name = 'ddas', StageName = 'Prospecting',
                            CloseDate = System.today(), AccountId = accs[1].Id
                            ), 
            new Opportunity(Name = 'ddadss', StageName = 'Closed Won',
                            CloseDate = System.today(), AccountId = accs[1].Id
                            ),
            new Opportunity(Name = 'ddascsdfs', StageName = 'Prospecting',
                            CloseDate = System.today(),  AccountId = accs[2].Id
                            ),
            new Opportunity(Name = 'ddascsdfsSAD', StageName = 'Prospecting',
                            CloseDate = System.today()
                            ),
            new Opportunity(Name = 'ddascsdfsSADssd', StageName = 'Prospecting',
                            CloseDate = System.today(), AccountId = accs[2].Id
                            )
            };
        List<Contact> cons = new List<Contact>{
                new Contact(FirstName='ds', LastName='dsa', Email='kirill.huk@enway.com'),
                new Contact(FirstName='sd', LastName='dsad', Email='ietwe@mail.ru'),
                new Contact(FirstName='sd', LastName='dsad')
            };
        insert opps;
        insert cons;
        List<OpportunityContactRole> conRoles = new List<OpportunityContactRole>{
            new OpportunityContactRole(ContactId = cons[0].Id, OpportunityId = opps[0].Id, 
                                        isPrimary = true
            ),
            new OpportunityContactRole(ContactId = cons[1].Id, OpportunityId = opps[3].Id, 
                                        isPrimary = true
            ),
            new OpportunityContactRole(ContactId = cons[2].Id, OpportunityId = opps[5].Id, 
                                        isPrimary = true
            )
        };

        insert conRoles;
    }
    

    @isTest
    public static void OpportunityUpdate_SetToClosedWonAll(){
        List<Opportunity> opps =    [SELECT Id, StageName
                                    FROM Opportunity 
                                    ];
        for (Opportunity opp : opps) {
            opp.StageName = 'Closed Won';
        }
        Test.startTest();
        Database.update(opps, false);
        Test.stopTest();
        Integer count = [SELECT COUNT() 
                        FROM Opportunity 
                        WHERE StageName = 'Closed Won'
                        ];
        System.assertEquals(3, count, 'Stage should be Closed Won in 3 of 6');
    }
    @isTest
    public static void OpportunityUpdate_TestMail(){
        SingleRequestMock fakeResponse = 
        new SingleRequestMock(200, 'OK', 
                            '[{"location": {"lat": 37.422476'+
                            '"lng": -122.084249}}]', null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Account acc = new Account(Name = 'YAYAZ', BillingCity = 'some...', BillingCountry = 'USA',
                                    BillingPostalCode='CA', BillingState='California', BillingStreet='Some'
        );
        insert acc;
        Opportunity opp = new Opportunity(Name = 'dsa', StageName = 'Prospecting', 
                                        CloseDate = System.today(), AccountId = acc.Id
        );
        insert opp;
        Contact con = new Contact(FirstName='ds', LastName='dsa', Email='kirill.huk@enway.com');
        insert con;
        OpportunityContactRole oppRole = 
            new OpportunityContactRole(ContactId = con.Id, OpportunityId = opp.Id, 
                                        isPrimary = true
        );
        insert oppRole;
        opp.StageName = 'Closed Won';
        Test.startTest();
        Database.update(opp, false);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        Opportunity oppWithMail =   [SELECT (
                                        SELECT Id 
                                        FROM Emails
                                        ) 
                                    FROM Opportunity 
                                    WHERE Id = :opp.Id
                                    LIMIT 1
                                    ];
        System.assertEquals(1, oppWithMail.Emails.size(), 'There should be 1 email sent');
    }
    @isTest
    public static void AdditionalTests(){
        SendMailer.MassSendMailToPrimaryWithTemplate(null, 'zxfffffffffffffffffffffffffdsfdfsdf');
        BillingAddressHelper.isEmpty(new System.Address());
    }
}
