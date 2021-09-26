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
                List<Opportunity> oppsSetClosedWon = new List<Opportunity>();
                for (Opportunity opp : newRecords) {
                    if (isSetClosedWon(opp, oldMap)){
                        oppsSetClosedWon.add(opp);
                    }
                }
                if(!oppsSetClosedWon.isEmpty()){
                    List<Opportunity> oppsWithRelated = [SELECT Account.BillingAddress,(
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

            when AFTER_UPDATE {
                List<Opportunity> toNotifyOpps = new List<Opportunity>();
                for (Opportunity opp : newRecords) {
                    if (isSetClosedWon(opp, oldMap)){
                        toNotifyOpps.add(opp);
                    }
                }
                if(!toNotifyOpps.isEmpty()){
                    List<Opportunity> oppsWithRelated = [SELECT (
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
        }
    }

    public static void handleAccountValidationAll(List<Opportunity> opps, Map<Id,Opportunity> newMap){
        List<Opportunity> checkAccAddr = new List<Opportunity>();
        for(Opportunity opp : opps){
            if(opp.Account == null){
                newMap.get(opp.id).addError('No account for this Opportunity');
            }
            else 
                checkAccAddr.add(opp);
        }
        if(checkAccAddr.isEmpty())
            return;
        for (Opportunity opp : checkAccAddr) {
            if(BillingAddressHelper.isEmpty(opp.Account.BillingAddress))
                newMap.get(opp.id).addError('Account Billing Address is Empty');
        }  
    }
    
    public static void handlePrimaryEmailValidationAll(List<Opportunity> opps, Map<Id,Opportunity> newMap){
        for (Opportunity opp : opps) {
            if(opp.OpportunityContactRoles.isEmpty()){
                newMap.get(opp.id).addError('There is no primary contact"');
            }
            else {
                if(String.isBlank(opp.OpportunityContactRoles[0].Contact.Email)){
                    newMap.get(opp.id).AddError('Email is not specified on primary contact');
                }
            }
        }
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
