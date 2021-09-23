public class Task2Btch implements Database.Batchable<SObject>  {
    public Database.QueryLocator Start(Database.BatchableContext context){
        return Database.getQueryLocator(
            'SELECT Send_Test_Email__c,' + 
                '(SELECT Contact,' +
                    '(SELECT Email' +
                    'FROM Contact'+
                    ')'+
                 'FROM ContactRoles' +
                 'WHERE IsPrimary = true' +
                 ')' +   
            'FROM Opportunity'+
            'WHERE Send_Test_Email__c = true'
        );
    }
    public void Execute(Database.BatchableContext context, List<Opportunity> opps){
        //List<Opportunity> oppss = [SELECT Send_Test_Email__c, (SELECT Contact, (SELECT Email FROM Contact ) FROM ContactRoles WHERE isPrimary = true) FROM Opportunity WHERE Send_Test_Email__c = true];
        for (Opportunity opp : opps){   
            opp.Send_Test_Email__c = false;
        }
        EmailTemplate temp = [SELECT Id, Subject, Description, HtmlValue,
                             DeveloperName, Body  
                             FROM EmailTemplate
                             WHERE Name = 'Task2'
                             ];
        System.debug(temp);
    }

    public void Finish(Database.BatchableContext context){
        return;
    }
}