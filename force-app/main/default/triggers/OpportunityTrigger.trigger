trigger OpportunityTrigger on Opportunity (before insert, after insert, 
                                            before update, after update, 
                                            before delete, after delete, 
                                            after undelete
                                            ){
    OpportunityTriggerHandler.handleTrigger(Trigger.new, Trigger.old, 
                                            Trigger.newMap, Trigger.oldMap, 
                                            Trigger.operationType);
}