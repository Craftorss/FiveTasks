public class Task2Btch implements Database.Batchable<SObject>  {
    public Database.QueryLocator Start(Database.BatchableContext context){
        return Database.getQueryLocator(
            'SELECT Send_Test_Email__c,' + 
                '(SELECT isPrimary, Contact.Email' +
                 'FROM OpportunityContactRoles' +
                 'WHERE IsPrimary = true' +
                 ')' +   
            'FROM Opportunity'+
            'WHERE Send_Test_Email__c = true'
        );
    }
    public void Execute(Database.BatchableContext context, List<Opportunity> opps){
        //List<Opportunity> oppss = [SELECT Send_Test_Email__c,(SELECT isPrimary, Contact.Email FROM OpportunityContactRoles WHERE isPrimary = true) FROM Opportunity WHERE Send_Test_Email__c = true];
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate temp = [SELECT Id, Subject, Description, HtmlValue,
                            DeveloperName, Body  
                            FROM EmailTemplate
                            WHERE Name = 'Task2'
        ];
        
        for (Opportunity opp : opps){   
            if(opp.OpportunityContactRoles != null){
                if(String.isNotBlank(opp.OpportunityContactRoles[0].Contact.Email)){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTemplateId(temp.Id);
                    message.setTargetObjectId(opp.OpportunityContactRoles[0].Contact.Id);
                    message.setWhatId(opp.Id);
                    message.setSaveAsActivity(true);
                    message.toAddresses = new String[] {opp.OpportunityContactRoles[0].Contact.Email};
                    messages.add(message);
                }
            }
            opp.Send_Test_Email__c = false;
        }

        
        try{
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
            for(Messaging.SendEmailResult result : results){
                if(result.isSuccess()){
                    System.debug('The Email to send succesfully');
                }
                else {
                    for(Messaging.SendEmailError error : result.errors)
                    System.debug('The Email to ' + error.targetobjectid + ' failed to send with following: ' + error.message);
                }
            }
        } catch (Exception ex){
            System.debug('Sending Email exception occurs' + ex.getMessage());
        }
    }

    public void Finish(Database.BatchableContext context){
        return;
    }
}