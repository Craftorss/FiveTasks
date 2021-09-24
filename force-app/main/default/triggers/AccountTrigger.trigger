trigger AccountTrigger on Account (after insert, after update) {
    Set<Id> accsToHandler = new Set<Id>();
    if(Trigger.isUpdate){
        for(Account newAc : Trigger.new){
            Account beforeAc = Trigger.oldMap.get(newAc.Id);
            if(newAc.BillingState != beforeAc.BillingState || 
            newAc.BillingStreet != beforeAc.BillingStreet ||
            newAc.BillingCountry != beforeAc.BillingCountry ||
            newAc.BillingPostalCode != beforeAc.BillingPostalCode ||
<<<<<<< HEAD
            newAc.BillingCity != beforeAc.BillingCity
            ){
                accsToHandler.add(newAc.Id);
                system.debug('got inside');
=======
            newAc.BillingCity != beforeAc.BillingCity){
                accsToHandler.add(newAc.Id);
>>>>>>> db4beea7d2b5e56fcc2d2aa02394e144b696d5cd
            }
        }
    }
    else 
        accsToHandler = Trigger.newMap.keySet();
    if (accsToHandler.size() > 0)
        AccountTriggerHandler.setCoordinates(accsToHandler);
}