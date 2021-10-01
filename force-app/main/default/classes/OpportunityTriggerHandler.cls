//prerowrked Task 5
public class OpportunityTriggerHandler{
    public static void handleTrigger(List<Opportunity> newRecords, List<Opportunity> oldRecords,
                                    Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap,
                                    System.TriggerOperation triggerEvent 
                                    ){
        switch on triggerEvent {
            //Также перед закрытием опотьюнити нужно сделать 2 валидации
            //Email в primary контакте заполнен
            //Billing Address в аккаунте заполнен
            /*Я так понимаю, валидация имеется ввиду только по обновлению на Closed Won.
            Иначе при insert проверить BillingAddress на аккаунте ещё могу по AccountId,
            А вот для OpportunityContactRoles нужно, чтобы Opportunity Id уже был*/
            when BEFORE_UPDATE {
                validateOnSetClosedWon(newRecords, newMap, oldMap);
            }

            when AFTER_UPDATE {
                processOnSetClosedWon(newRecords, oldMap);
            }
        }
    }

    public static void validateOnSetClosedWon(List<Opportunity> newRecords, Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
        List<Opportunity> oppsSetClosedWon = new List<Opportunity>();
        for (Opportunity opportunity : newRecords) {
            if (isSetClosedWon(opportunity, oldMap)){
                oppsSetClosedWon.add(opportunity);
            }
        }
        if(!oppsSetClosedWon.isEmpty()){
            List<Opportunity> oppsWithRelated = [
                    SELECT Account.BillingAddress,(
                        SELECT Contact.Email 
                        FROM OpportunityContactRoles
                        WHERE isPrimary = true
                        )  
                    FROM Opportunity 
                    WHERE ID IN :oppsSetClosedWon 
            ];
            handleAccountValidationAll(oppsWithRelated, newMap);
            handlePrimaryEmailValidationAll(oppsWithRelated, newMap);
        }
    }

    public static void processOnSetClosedWon(List<Opportunity> newRecords, map<Id, Opportunity> oldMap){
        List<Opportunity> toNotifyOpps = new List<Opportunity>();
        for (Opportunity opportunity : newRecords) {
            if (isSetClosedWon(opportunity, oldMap)){
                toNotifyOpps.add(opportunity);
            }
        }
        if(!toNotifyOpps.isEmpty()){
            List<Opportunity> oppsWithRelated = [
                    SELECT (
                        SELECT Contact.Email 
                        FROM OpportunityContactRoles
                        WHERE isPrimary = true
                        )  
                    FROM Opportunity 
                    WHERE ID IN :toNotifyOpps 
            ];
            handleSendMail(oppsWithRelated);
            System.debug('ToNotify' + oppsWithRelated);
        }
    }

    public static void handleAccountValidationAll(List<Opportunity> opportunities, Map<Id,Opportunity> newMap){
        List<Opportunity> opportunitiesToCheckAddress = new List<Opportunity>();
        for(Opportunity opportunity : opportunities){
            if(opportunity.Account == null){
                newMap.get(opportunity.id).addError('No account for this Opportunity');
            }
            else 
                opportunitiesToCheckAddress.add(opportunity);
        }
        if(opportunitiesToCheckAddress.isEmpty())
            return;
        for (Opportunity opportunity : opportunitiesToCheckAddress) {
            if(BillingAddressHelper.isEmpty(opportunity.Account.BillingAddress))
                newMap.get(opportunity.id).addError('Account Billing Address is Empty');
        }  
    }
    
    public static void handlePrimaryEmailValidationAll(List<Opportunity> opportunities, Map<Id,Opportunity> newMap){
        for (Opportunity opportunity : opportunities) {
            if(opportunity.OpportunityContactRoles.isEmpty()){
                newMap.get(opportunity.id).addError('There is no primary contact"');
            }
            else {
                if(String.isBlank(opportunity.OpportunityContactRoles[0].Contact.Email)){
                    newMap.get(opportunity.id).AddError('Email is not specified on primary contact');
                }
            }
        }
    }
    public static void handleSendMail(List<Opportunity> opportunities){
        if(opportunities.isEmpty())
            return;
        else {
            SendMailer.MassSendMailToPrimaryWithTemplate(opportunities, 'Task2');
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
