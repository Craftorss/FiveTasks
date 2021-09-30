//reworked Task 2
public class ProcessOpportunityBatch implements Database.Batchable<SObject> { 
    public Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('SELECT Send_Test_Email__c,(SELECT isPrimary, Contact.Email FROM OpportunityContactRoles WHERE isPrimary = true) FROM Opportunity WHERE Send_Test_Email__c = true');
    }
    public void execute(Database.BatchableContext context, List<Opportunity> opportunities){
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> emailTemplatesList =    [SELECT Id
                                                    FROM EmailTemplate
                                                    WHERE Name = 'Task2'
                                                    ];
        if(emailTemplatesList.isEmpty())
            return;
        for (Opportunity opportunity : opportunities){   
            if(opportunity.OpportunityContactRoles.size() > 0){
                if(String.isNotBlank(opportunity.OpportunityContactRoles[0].Contact.Email)){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTemplateId(emailTemplatesList[0].Id);
                    message.setTargetObjectId(opportunity.OpportunityContactRoles[0].Contact.Id);
                    message.setWhatId(opportunity.Id);
                    message.setSaveAsActivity(true);
                    message.toAddresses = new String[] {opportunity.OpportunityContactRoles[0].Contact.Email};
                    messages.add(message);
                }
            }
            opportunity.Send_Test_Email__c = false;
        }
        update opportunities;
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
