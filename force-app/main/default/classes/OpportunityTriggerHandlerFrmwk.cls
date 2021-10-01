//prerowrked Task 5
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
        OpportunityTriggerHandler.validateOnSetClosedWon(newRecords, newMap, oldMap);
    }

    public override void afterUpdate(){
        OpportunityTriggerHandler.processOnSetClosedWon(newRecords, oldMap);
    }
}
