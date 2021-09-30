public class SendMailer {
    public static void MassSendMailToPrimaryWithTemplate(List<Opportunity> opportunities, String emailTemplateName){
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> emailTemplateList = [SELECT Id  
                                                FROM EmailTemplate
                                                WHERE Name = :emailTemplateName 
                                                LIMIT 1
                                                ];
        if(emailTemplateList.isEmpty()){
            System.debug('Invalid Email template name');
            return;
        }
        for (Opportunity opportunity : opportunities){
            if(opportunity.OpportunityContactRoles.size() > 0){
                if(String.isNotBlank(opportunity.OpportunityContactRoles[0].Contact.Email)){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTemplateId(emailTemplateList[0].Id);
                    message.setTargetObjectId(opportunity.OpportunityContactRoles[0].Contact.Id);
                    message.setWhatId(opportunity.Id);
                    message.setSaveAsActivity(true);
                    message.toAddresses = new String[] {opportunity.OpportunityContactRoles[0].Contact.Email};
                    messages.add(message);
                }
            }
        }

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
        for(Messaging.SendEmailResult result : results){
            if(result.isSuccess()){
                System.debug('The Email to send succesfully');
            }
            else {
                for(Messaging.SendEmailError error : result.errors)
                    System.debug('The Email to ' + error.targetObjectId + ' failed to send with following: ' + error.message);
            }
        }
    }
}
