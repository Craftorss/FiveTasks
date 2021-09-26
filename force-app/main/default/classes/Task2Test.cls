@isTest
public class Task2Test {
    @TestSetup
    static void makeData(){
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(Name='dsa', StageName='Prospecting', 
                            CloseDate=System.today(),Send_Test_Email__c = true
                            ), 
            new Opportunity(Name='ddas', StageName='Prospecting', 
                            CloseDate=System.today(),Send_Test_Email__c = true
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
    public static void Execute_CheckScheduler(){
        String cronExpr = '0 30 * * * ?';
        String jobName = 'Test Scheduled Job';
        Test.startTest();
            Task2Schd schd = new Task2Schd();
            System.schedule(jobName, cronExpr, schd);
        Test.stopTest();
        
        system.assertEquals(1, [SELECT COUNT() FROM CronTrigger], 'A job should be scheduled'); 
    }
    @isTest
    public static void Execute_CheckProcessingBatch(){
        Test.startTest();
            Task2Btch task = new Task2Btch();
            Database.executeBatch(task, 2);
        Test.stopTest();
        
        system.assertEquals(0, [SELECT COUNT() FROM Opportunity WHERE Send_Test_Email__c = true], 'Failed processing batches'); 
    }
}
