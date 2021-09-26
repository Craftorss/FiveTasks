public class SendMailer {
    public static void MassSendMailToPrimaryWithTemplate(List<Opportunity> opps, String emailTemplateName){
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp = [SELECT Id  
                            FROM EmailTemplate
                            WHERE Name = :emailTemplateName
                            ];
        if(temp == null){
            System.debug('Invalid Email template name');
            return;
        }
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
