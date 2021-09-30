//prereworked Task 5
@isTest
public class OpportunityTriggerTest {
    @TestSetup
    static void makeData(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'OK', 
                                                            '[{"location": {"lat": 37.422476'+
                                                            '"lng": -122.084249}}]', null
                                                            );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        List<Account> accounts = new List<Account>{
            new Account(Name = 'YAYAD', BillingCity = 'some...'),
            new Account(Name = 'YAYAS'),
            new Account(Name = 'YAYAZ', BillingCity = 'some...', BillingCountry = 'USA',
                        BillingPostalCode='CA', BillingState='California', BillingStreet='Some'
                        )
        };        
        insert accounts;
        List<Opportunity> opportunities = new List<Opportunity>{
            new Opportunity(Name = 'dsa', StageName = 'Prospecting', 
                            CloseDate = System.today(), AccountId = accounts[0].Id
                            ), 
            new Opportunity(Name = 'ddas', StageName = 'Prospecting',
                            CloseDate = System.today(), AccountId = accounts[1].Id
                            ), 
            new Opportunity(Name = 'ddadss', StageName = 'Closed Won',
                            CloseDate = System.today(), AccountId = accounts[1].Id
                            ),
            new Opportunity(Name = 'ddascsdfs', StageName = 'Prospecting',
                            CloseDate = System.today(),  AccountId = accounts[2].Id
                            ),
            new Opportunity(Name = 'ddascsdfsSAD', StageName = 'Prospecting',
                            CloseDate = System.today()
                            ),
            new Opportunity(Name = 'ddascsdfsSADssd', StageName = 'Prospecting',
                            CloseDate = System.today(), AccountId = accounts[2].Id
                            )
            };
        List<Contact> contacts = new List<Contact>{
                new Contact(FirstName='ds', LastName='dsa', Email='kirill.huk@enway.com'),
                new Contact(FirstName='sd', LastName='dsad', Email='ietwe@mail.ru'),
                new Contact(FirstName='sd', LastName='dsad')
            };
        insert opportunities;
        insert contacts;
        List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>{
            new OpportunityContactRole(ContactId = contacts[0].Id, OpportunityId = opportunities[0].Id, 
                                        isPrimary = true
            ),
            new OpportunityContactRole(ContactId = contacts[1].Id, OpportunityId = opportunities[3].Id, 
                                        isPrimary = true
            ),
            new OpportunityContactRole(ContactId = contacts[2].Id, OpportunityId = opportunities[5].Id, 
                                        isPrimary = true
            )
        };

        insert contactRoles;
    }
    

    @isTest
    public static void OpportunityUpdate_SetToClosedWonAll(){
        List<Opportunity> opportunities =   [SELECT Id, StageName
                                            FROM Opportunity 
                                            ];
        for (Opportunity opportunity : opportunities) {
            opportunity.StageName = 'Closed Won';
        }
        Test.startTest();
        Database.update(opportunities, false);
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
        Account account = new Account(Name = 'YAYAZ', BillingCity = 'some...', BillingCountry = 'USA',
                                    BillingPostalCode='CA', BillingState='California', BillingStreet='Some'
        );
        insert account;
        Opportunity opportunity = new Opportunity(Name = 'dsa', StageName = 'Prospecting', 
                                        CloseDate = System.today(), AccountId = account.Id
        );
        insert opportunity;
        Contact contact = new Contact(FirstName='ds', LastName='dsa', Email='kirill.huk@enway.com');
        insert contact;
        OpportunityContactRole contactRole = 
            new OpportunityContactRole(ContactId = contact.Id, OpportunityId = opportunity.Id, 
                                        isPrimary = true
        );
        insert contactRole;
        opportunity.StageName = 'Closed Won';
        Test.startTest();
        Database.update(opportunity, false);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        Opportunity opportunityWithMail =   [SELECT (
                                                SELECT Id 
                                                FROM Emails
                                            ) 
                                            FROM Opportunity 
                                            WHERE Id = :opportunity.Id
                                            LIMIT 1
                                            ];
        System.assertEquals(1, opportunityWithMail.Emails.size(), 'There should be 1 email sent');
    }
    @isTest
    public static void AdditionalTests(){
        SendMailer.MassSendMailToPrimaryWithTemplate(null, 'zxfffffffffffffffffffffffffdsfdfsdf');
        BillingAddressHelper.isEmpty(new System.Address());
    }
}
