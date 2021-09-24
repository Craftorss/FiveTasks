public class OpportunityTriggerHandler{
    public static void handleTrigger(List<Opportunity> newRecords, List<Opportunity> oldRecords,
                                    Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap,
                                    System.TriggerOperation triggerEvent 
                                    ){
        switch on triggerEvent {
            when BEFORE_INSERT, BEFORE_UPDATE {
                for (Opportunity opp : newRecords) {
                    if (isSetClosedWon(opp, oldMap)){
                        handleAccountValidation(opp);
                        handlePrimaryEmailValidation(opp);
                    }
                }
            }
            when AFTER_INSERT, AFTER_UPDATE {
                List<Opportunity> toNotifyOpps = new List<Opportunity>();
                for (Opportunity opp : newRecords) {
                    if (isSetClosedWon(opp, oldMap)){
                        toNotifyOpps.add(opp);
                    }
                }
                handleSendMail(toNotifyOpps);
                System.debug('ToNotifyOpps '+toNotifyOpps);
            }
        }
    }

    public static Boolean handleAccountValidation(Opportunity opp){
        Account acc =   [SELECT BillingAddress
                        FROM Account 
                        WHERE Id = :opp.AccountId
                        ];
        if(BillingAddressHelper.isEmpty(acc.BillingAddress)){
            opp.addError('Account Billing Address is Empty');
            return false;
        }
        return true;
    }
    public static Boolean handlePrimaryEmailValidation(Opportunity opp){
        OpportunityContactRole primaryConRole = [SELECT Contact.Email FROM OpportunityContactRole WHERE OpportunityId = :opp.Id AND isPrimary = true];
        Boolean fl = true;
        if(primaryConRole == null){
            opp.AddError('There is no primary contact');
            fl = false;
        }
        else{
            if(String.isBlank(primaryConRole.Contact.Email)){
                opp.AddError('Email is not specified on primary contact');
                fl = false;
            }
        }
        return fl;
    }
    public static void handleSendMail(List<Opportunity> opps){
        if(opps.isEmpty())
            return;
        else {
            SendMailer.MassSendMailToPrimaryWithTemplate(opps, 'Task2');
        }
    }
    public static Boolean isSetClosedWon(Opportunity newOpp, Map<Id, Opportunity> oldMap){
        if(String.IsBlank(newOpp.StageName))
            return false;
        if(newOpp.StageName == 'Closed Won'){
            if(oldMap == null)
                return true;
            Opportunity oldOpp = oldMap.get(newOpp.id);
            if(oldOpp.StageName == newOpp.StageName)
                return false;
            else 
                return true;
        }
        else 
            return false;
    }
}
