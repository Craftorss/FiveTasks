//prereworked Task 5
trigger OpportunityTrigger on Opportunity (before insert, after insert, 
                                            before update, after update, 
                                            before delete, after delete, 
                                            after undelete
                                            ){
    new OpportunityTriggerHandlerFrmwk().run(); 
/*  static handler methods implementation...  
    OpportunityTriggerHandler.handleTrigger(Trigger.new, Trigger.old, 
                                            Trigger.newMap, Trigger.oldMap, 
                                            Trigger.operationType);
*/
}