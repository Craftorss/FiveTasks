//reworked Task 3
trigger AccountTrigger on Account (after insert, after update) {
    Set<Id> accsToHandler = new Set<Id>();
    if(Trigger.isUpdate){
        AccountTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    else {
        AccountTriggerHandler.handleAfterInsert(Trigger.new);
    }
}