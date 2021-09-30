//reworked Task 2
@isTest
public class ProcessOpportunityTest {
    @TestSetup
    static void makeData(){
        List<Opportunity> opportunities = new List<Opportunity>{
            new Opportunity(Name='dsa', StageName='Prospecting', 
                            CloseDate=System.today(),Send_Test_Email__c = true
                            ), 
            new Opportunity(Name='ddas', StageName='Prospecting', 
                            CloseDate=System.today(),Send_Test_Email__c = true
                            )
            };
        List<Contact> contacts = new List<Contact>{
                new Contact(FirstName='ds', LastName='dsa', Email='kirill.huk@enway.com'),
                new Contact(FirstName='sd', LastName='dsad', Email='kirill.huk@enway.com')
            };
        insert opportunities;
        insert contacts;
        OpportunityContactRole contactRole = new OpportunityContactRole(ContactId = contacts[0].Id, 
                                                                        OpportunityId = opportunities[0].Id, 
                                                                        isPrimary = true
                                                                        );
        insert contactRole;
    }
    
    @isTest
    public static void Execute_CheckScheduler(){
        String cronExpr = '0 30 * * * ?';
        String cronExpr2 = '0 0 * * * ?';
        String jobName = 'Test Scheduled Job';
        String jobName2 = 'Test Scheduled Job 2';
        Test.startTest();
            ProcessOpportunitySchd schdJob = new ProcessOpportunitySchd();
            ProcessOpportunitySchd schdJob2 = new ProcessOpportunitySchd();
            System.schedule(jobName, cronExpr, schdJob);
            System.schedule(jobName2, cronExpr, schdJob2);
        Test.stopTest();
        
        system.assertEquals(2, [SELECT COUNT() FROM CronTrigger], 'A job should be scheduled'); 
    }
    @isTest
    public static void Execute_CheckProcessingBatch(){
        Test.startTest();
            ProcessOpportunityBatch batchTask = new ProcessOpportunityBatch();
            Database.executeBatch(batchTask, 2);
        Test.stopTest();
        
        system.assertEquals(0, [SELECT COUNT() FROM Opportunity WHERE Send_Test_Email__c = true], 'Failed processing batches'); 
    }
}
