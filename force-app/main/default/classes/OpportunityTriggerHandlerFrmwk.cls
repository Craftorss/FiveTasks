public class OpportunityTriggerHandlerFrmwk extends TriggerHandler {
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> newRecords;
    private List<Opportunity> oldRecords;

    public OpportunityTriggerHandlerFrmwk(){
        this.newMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        this.newRecords = (List<Opportunity>) Trigger.new;
        this.oldRecords = (List<Opportunity>) Trigger.old;
    }

    public override void beforeUpdate() {
        List<Opportunity> oppsSetClosedWon = new List<Opportunity>();
        for (Opportunity opp : newRecords) {
            if (OpportunityTriggerHandler.isSetClosedWon(opp, oldMap)){
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
            OpportunityTriggerHandler.handleAccountValidationAll(oppsWithRelated, newMap);
            OpportunityTriggerHandler.handlePrimaryEmailValidationAll(oppsWithRelated, newMap);
        }
    }

    public override void afterUpdate(){
        List<Opportunity> toNotifyOpps = new List<Opportunity>();
        for (Opportunity opp : newRecords) {
            if (OpportunityTriggerHandler.isSetClosedWon(opp, oldMap)){
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
            OpportunityTriggerHandler.handleSendMail(oppsWithRelated);
            System.debug('ToNotify' + oppsWithRelated);
        }
    }
}
