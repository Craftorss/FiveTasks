public class Task2Btch implements Database.Batchable<SObject>  {
    public Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('SELECT Send_Test_Email__c,(SELECT isPrimary, Contact.Email FROM OpportunityContactRoles WHERE isPrimary = true) FROM Opportunity WHERE Send_Test_Email__c = true');
    }
    public void execute(Database.BatchableContext context, List<Opportunity> opps){
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp = [SELECT Id  
                            FROM EmailTemplate
                            WHERE Name = 'Task2'
        ];
        
        for (Opportunity opp : opps){   
            if(opp.OpportunityContactRoles.size() > 0){
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
        update opps;
        try {
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
        } catch (EmailException ex){
            System.debug('Sending Email exception occurs' + ex.getMessage());
        }
    }

    public void finish(Database.BatchableContext context){
        return;
    }
}